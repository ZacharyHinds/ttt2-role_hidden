AddCSLuaFile()

SWEP.Base = "weapon_tttbasegrenade"

if CLIENT then
    SWEP.PrintName = "weapon_ttt_hdn_nade_name"
    SWEP.Author = "Wasted"
end

SWEP.Primary.Ammo = "none" 
SWEP.Primary.Damage = 30
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 3
SWEP.Primary.ClipMax = 3
SWEP.Primary.Sound = Sound("weapons/knife/knife_slash2.wav")
SWEP.Primary.HitForce = 50

SWEP.Grenades = 0
SWEP.Throwing = false
SWEP.TimeUntillThrow = 0

SWEP.Range = 90

SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 90
SWEP.ViewModel = "models/weapons/cstrike/c_eq_flashbang.mdl" 
SWEP.WorldModel = ""
SWEP.Kind = WEAPON_SPECIAL

SWEP.SwayScale = 1
SWEP.BobScale = 1

function SWEP:GetGrenadeName()
    return "ttt_hdnade_proj"
end
