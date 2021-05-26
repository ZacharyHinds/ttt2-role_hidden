if SERVER then
    AddCSLuaFile()

    resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_hdn.vmt")
end

roles.InitCustomTeam(ROLE.name, {
    icon = "vgui/ttt/dynamic/roles/icon_hdn",
    color = Color(255, 255, 255)
})

function ROLE:PreInitialize()
	self.color = Color(0, 0, 0)

	self.abbr = "hdn"
	self.score.surviveBonusMultiplier = 0.5
	self.score.timelimitMultiplier = -0.5
	self.score.killsMultiplier = 5
	self.score.teamKillsMultiplier = -16
	self.score.bodyFoundMuliplier = 0

	self.defaultTeam = TEAM_HIDDEN
	self.defaultEquipment = SPECIAL_EQUIPMENT

	self.conVarData = {
		pct = 0.13,
		maximum = 1,
		minPlayers = 8,
		credits = 1,
		togglable = true,
		random = 20
	}
end

function ROLE:Initialize()
    if SERVER and JESTER then
        self.networkRoles = {JESTER}
    end
end

if SERVER then

    function ROLE:RemoveRoleLoadout(ply, isRoleChange)
        if ply:GetMaxHealth() > 100 then
            ply:SetMaxHealth(100)
        end
        ply:SetHealth(math.Clamp(ply:Health(), 1, ply:GetMaxHealth()))
        ply:SetMaxHealth(100)
        ply:RemoveEquipmentWeapon("weapon_ttt_hd_knife")
        ply:RemoveEquipmentWeapon("weapon_ttt_hd_nade")
        ply:RemoveEquipmentItem("item_ttt_climb")
        ply:SetStalkerMode(false)
        STATUS:RemoveStatus(ply, "ttt2_hdn_invisbility")
    end

    hook.Add("KeyPress", "HiddenEnterStalker", function(ply, key)
        if ply:GetSubRole() ~= ROLE_HIDDEN or not ply:Alive() or ply:IsSpec() then return end
        if ply:GetNWBool("ttt2_hd_stalker_mode", false) then return end

        if key == IN_RELOAD then
            local c = (#util.GetAlivePlayers() - 1) * GetConVar("ttt2_hdn_health_bonus"):GetInt()
            local hp = math.Clamp(ply:Health() + c, ply:Health(), GetConVar("ttt2_hdn_health_max"):GetInt())
            local max_hp = math.Clamp(100 + c, ply:GetMaxHealth(), GetConVar("ttt2_hdn_health_max"):GetInt())
            ply:SetMaxHealth(max_hp)
            ply:SetHealth(hp)
            ply:SetStalkerMode(true)
            STATUS:AddStatus(ply, "ttt2_hdn_invisbility")
            ply:GiveEquipmentWeapon("weapon_ttt_hd_knife")
            ply:GiveEquipmentWeapon("weapon_ttt_hd_nade")
            ply:GiveEquipmentItem("item_ttt_climb")
        end
    end)
end
