if SERVER then
    AddCSLuaFile()

    resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_hdn.vmt")
end

roles.InitCustomTeam(ROLE.name, {
    icon = "vgui/ttt/dynamic/roles/icon_hdn"
})

function ROLE:PreInitialize()
	self.color = Color(0, 0, 0, 255)

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
            ply:SetStalkerMode(true)
            STATUS:AddStatus(ply, "ttt2_hdn_invisbility")
            ply:GiveEquipmentWeapon("weapon_ttt_hd_knife")
            ply:GiveEquipmentWeapon("weapon_ttt_hd_nade")
            ply:GiveEquipmentItem("item_ttt_climb")
        end
    end)
end