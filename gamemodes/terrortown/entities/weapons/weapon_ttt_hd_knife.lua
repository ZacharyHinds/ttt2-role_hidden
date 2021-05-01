if SERVER then
    AddCSLuaFile()
end

if CLIENT then
    SWEP.PrintName = "weapon_ttt_hdn_knife_name"
end

SWEP.ViewModelFlip = false 
SWEP.ViewModelFOV = 54
SWEP.DrawCrosshair = true 

SWEP.Base = "weapon_tttbase"

SWEP.HoldType = "knife"
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.UseHands = true 

SWEP.Primary.Damage = 60
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true 
SWEP.Primary.Delay = 2
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 12

SWEP.Kind = WEAPON_SPECIAL

SWEP.HitDistance = 64

SWEP.AllowDrop = false
SWEP.IsSilent = true

-- Pull out faster than standard guns
SWEP.DeploySpeed = 2

local swingSound = Sound("WeaponFrag.Throw")
local hitSound = Sound("Flesh.ImpactHard")

function SWEP:Initialize()
    self:SetHoldType("knife")
end

-- function SWEP:Holster()
--     return false
-- end

function SWEP:Equip(owner)
    if not SERVER or not owner then return end
    self.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
    self.WorldModel = ""
    net.Start("ttt2_hdn_network_wep")
    net.WriteEntity(self)
    net.WriteString("")
    net.Broadcast()
    STATUS:RemoveStatus(owner, "ttt2_hdn_knife_recharge")
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
    local owner = self:GetOwner()

    if not IsValid(owner) or owner:GetSubRole() ~= ROLE_HIDDEN or not owner:GetNWBool("ttt2_hd_stalker_mode", false) then return end

    owner:LagCompensation(true)

    local spos = owner:GetShootPos()
    local sdest = spos + (owner:GetAimVector() * 70)

    local kmins = Vector(1, 1, 1) * -10
    local kmaxs = Vector(1, 1, 1) * 10

    local trace = util.TraceHull({
        start = spos,
        endpos = sdest,
        filter = owner,
        mask = MASK_SHOT_HULL,
        mins = kmins,
        maxs = kmaxs
    })

    
    if not IsValid(trace.Entity) then
        trace = util.TraceLine({
            start = spos,
            endpos = sdest,
            filter = owner,
            mask = MASK_SHOT_HULL
        })
    end
    
    local tgt = trace.Entity
    
    if IsValid(tgt) then
        self:SendWeaponAnim(ACT_VM_MISSCENTER)

        local eData = EffectData()
        eData:SetStart(spos)
        eData:SetOrigin(trace.HitPos)
        eData:SetNormal(trace.Normal)
        eData:SetEntity(tgt)

        if tgt:IsPlayer() or tgt:GetClass() == "prop_ragdoll" then
            owner:SetAnimation(PLAYER_ATTACK1)

            self:SendWeaponAnim(ACT_VM_MISSCENTER)

            util.Effect("BloodImpact", eData)
        end
    else
        self:SendWeaponAnim(ACT_VM_MISSCENTER)
    end

    if SERVER then owner:SetAnimation(PLAYER_ATTACK1) end
    
    if SERVER and trace.Hit and trace.HitNonWorld and IsValid(tgt) then
        if tgt:IsPlayer() and tgt:Health() < (self.Primary.Damage + 5) then
            self:Murder(trace, spos, sdest)
        elseif tgt:IsPlayer() then
            local dmg = DamageInfo()
            dmg:SetDamage(self.Primary.Damage)
            dmg:SetAttacker(owner)
            dmg:SetInflictor(self)
            dmg:SetDamageForce(owner:GetAimVector() * 5)
            dmg:SetDamagePosition(owner:GetPos())
            dmg:SetDamageType(DMG_SLASH)

            tgt:DispatchTraceAttack(dmg, spos + (owner:GetAimVector() * 3), sdest)
        end
    end

    owner:LagCompensation(false)
end

function SWEP:Murder(trace, spos, sdest)
    local tgt = trace.Entity
    local owner = self:GetOwner()

    local dmg = DamageInfo()
    dmg:SetDamage(2000)
    dmg:SetAttacker(owner)
    dmg:SetInflictor(self)
    dmg:SetDamageForce(owner:GetAimVector())
    dmg:SetDamagePosition(owner:GetPos())
    dmg:SetDamageType(DMG_SLASH)

    local retrace = util.TraceLine({
        start = spos,
        endpos = sdest,
        filter = owner,
        mask = MASK_SHOT_HULL
    })

    if retrace.Entity ~= tgt then
        local center = tgt:LocalToWorld(tgt:OBBCenter())

        retrace = util.TraceLine({
            start = spos,
            endpos = sdest,
            filter = owner,
            mask = MASK_SHOT_HULL
        })
    end

    local bone = retrace.PhysicsBone
    local pos = retrace.HitPos
    local norm = trace.Normal

    local angle = Angle(-28, 0, 0) + norm:Angle()
    angle:RotateAroundAxis(angle:Right(), -90)

    pos = pos - (angle:Forward() * 7)

    tgt.effect_fn = function(rag)
        local moreTrace = util.TraceLine({
            start = pos,
            endpos = pos + norm * 40,
            filter = ignore,
            mask = MASK_SHOT_HULL
        }) 

        if IsValid(moreTrace.Entity) and moreTrace.Entity == rag then
            bone = moreTrace.PhysicsBone
            pos = moreTrace.HitPos
            angle = Angle(-28, 0, 0) + moreTrace.Normal:Angle()
            angle:RotateAroundAxis(angle:Right(), -90)
            pos = pos - (angle:Forward() * 10)
        end

        local knife = ents.Create("prop_physics")
        knife:SetModel("models/weapons/w_knife_t.mdl")
        knife:SetPos(pos)
        knife:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        knife:SetAngles(angle)

        knife.CanPickup = false 

        knife:Spawn()

        local phys = knife:GetPhysicsObject()

        if IsValid(phys) then
            phys:EnableCollisions(false)
        end

        constraint.Weld(rag, knife, bone, 0, 0, true)

        rag:CallOnRemove("ttt_knife_cleanup", function()
            SafeRemoveEntity(knife)
        end)
    end

    tgt:DispatchTraceAttack(dmg, spos + owner:GetAimVector() * 3, sdest)
end

function SWEP:SecondaryAttack()
    self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
 
 
    self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
 
    if SERVER then
       local owner = self:GetOwner()
       if not IsValid(owner) then return end
 
       owner:SetAnimation(PLAYER_ATTACK1)
 
       local angle = owner:EyeAngles()
 
       if angle.p < 90 then
          angle.p = -10 + angle.p * ((90 + 10) / 90)
       else
          angle.p = 360 - angle.p
          angle.p = -10 + angle.p * -((90 + 10) / 90)
       end
 
       local vel = math.Clamp((90 - angle.p) * 5.5, 550, 800)
 
       local vfw = angle:Forward()
       local vrt = angle:Right()
 
       local src = owner:GetPos() + (owner:Crouching() and owner:GetViewOffsetDucked() or owner:GetViewOffset())
 
       src = src + (vfw * 1) + (vrt * 3)
 
       local thr = vfw * vel + owner:GetVelocity()
 
       local knife_angle = Angle(-28,0,0) + angle
       knife_angle:RotateAroundAxis(knife_angle:Right(), -90)
 
       local knife = ents.Create("ttt_hd_knife_proj")
       if not IsValid(knife) then return end
       knife:SetPos(src)
       knife:SetAngles(knife_angle)
 
       knife:Spawn()
 
       knife.Damage = self.Primary.Damage
 
       knife:SetOwner(owner)
 
       local phys = knife:GetPhysicsObject()
       if IsValid(phys) then
          phys:SetVelocity(thr)
          phys:AddAngleVelocity(Vector(0, 1500, 0))
          phys:Wake()
       end
 
       self:Remove()
    end
 end
