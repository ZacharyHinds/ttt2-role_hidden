if SERVER then
    AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "ttt_basegrenade_proj"
ENT.Model = Model("models/weapons/w_eq_flashbang_thrown.mdl")

AccessorFunc(ENT, "radius", "Radius", FORCE_NUMBER)
AccessorFunc(ENT, "dmg", "Dmg", FORCE_NUMBER)

function ENT:Initialize()
    if not self:GetRadius() then self:SetRadius(256) end
    if not self:GetDmg() then self:SetDmg(30) end

    return self.BaseClass.Initialize(self)
end

function ENT:Explode(trace)
    if SERVER then
        self:SetNoDraw(true)
        self:SetSolid(SOLID_NONE)

        local pos = self:GetPos()

        local eData = EffectData()
        eData:SetStart(pos)
        eData:SetOrigin(pos)
        eData:SetScale(self:GetRadius() * 0.3)
        eData:SetMagnitude(self:GetDmg())
        
        if trace.Fraction ~= 1.0 then
            eData:SetNormal(trace.HitNormal)
        end

        util.Effect("Explosion", eData, true, true)

        util.BlastDamage(self, self:GetThrower(), pos, self:GetRadius(), self:GetDmg())

        local plys = ents.FindInSphere(pos, self:GetRadius())
        for i = 1, #plys do
            local ply = plys[i]
            if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() or ply:IsSpec() then continue end
            ply:SetNWBool("ttt2_hd_nade_stun", true)
        end
        timer.Simple(GetConVar("ttt2_hdn_stun_duration"):GetInt(), function()
            for i = 1, #plys do
                local ply = plys[i]
                if not IsValid(ply) or not ply:IsPlayer() then continue end
                ply:SetNWBool("ttt2_hd_nade_stun", false)
            end
        end)

        self:SetDetonateExact(0)
        local owner = self:GetOwner()
        local time = GetConVar("ttt2_hdn_nade_delay"):GetInt()
        STATUS:AddTimedStatus(owner, "ttt2_hdn_nade_recharge", time, true)
        timer.Simple(time, function()
            if GetRoundState() ~= ROUND_ACTIVE or not IsValid(owner) then return end
            if owner:GetSubRole() ~= ROLE_HIDDEN or not owner:GetNWBool("ttt2_hd_stalker_mode", false) then return end
            owner:GiveEquipmentWeapon("weapon_ttt_hd_nade")
        end)
        self:Remove()
    else
        local spos = self:GetPos()
        local trs = util.TraceLine({
            start = spos + Vector(0, 0, 64),
            endpos = spos + Vector(0, 0, -128),
            filter = self,
        })
        util.Decal("Scorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)

        self:SetDetonateExact(0)
    end
end

if CLIENT then
    hook.Add("RenderScreenspaceEffects", "HiddenNadeBlurEffect", function()
        local client = LocalPlayer()
        local add = 0.2
        local draw = 1
        local delay = 0.01
        if client:GetNWBool("ttt2_hd_nade_stun", false) then
            DrawMotionBlur(add, draw, delay)
        end
    end)
end