
if SERVER then
   AddCSLuaFile()
   
   resource.AddFile("materials/vgui/ttt/hdn/icon_grenade.vmt")
   resource.AddFile("materials/vgui/ttt/hdn/icon_knife.vmt")
   resource.AddFile("materials/hud/hvision.vmt")
   resource.AddFile("materials/hud/hvision_dx6.vmt")

   util.AddNetworkString("ttt2_hdn_epop")
   util.AddNetworkString("ttt2_hdn_epop_defeat")
   util.AddNetworkString("ttt2_hdn_network_wep")
end

local plymeta = FindMetaTable("Player")

if not plymeta then
    Error("[TTT2 HIDDEN] FAILED TO FIND PLAYER TABLE")
end

local CLOAK_FULL = 4
local CLOAK_PARTIAL = 2
local CLOAK_NONE = 1

if CLIENT then
    local function HiddenWallhack()
        local client = LocalPlayer()

        if client:GetBaseRole() ~= ROLE_HIDDEN then return end

        if client:GetNWBool("ttt2_hd_stalker_mode", false) then
            render.UpdateScreenEffectTexture()
            render.SetMaterial(Material("hud/hvision.vmt", "noclamp smooth"))
            render.DrawScreenQuad()
        end

        if client:GetSubRole() ~= ROLE_HIDDEN then return end

        local plys = player.GetAll()
        -- for i = 1, #plys do
        --     local ply = plys[i]
        --     outline.Add(ply, Color(255, 255, 255), OUTLINE_MODE_VISIBLE)
        -- end

        if not client.hiddenHackAlpha then
            client.hiddenHackAlpha = 0
        end

        local velocity = client:GetVelocity()
        if math.abs(velocity.x) > 1 or math.abs(velocity.y) > 1 or math.abs(velocity.z) > 1 or not client:GetNWBool("ttt2_hd_stalker_mode", false) then 
            client.hiddenHackAlpha = math.Clamp(client.hiddenHackAlpha - 5, 0, 255)
        else
            client.hiddenHackAlpha = math.Clamp(client.hiddenHackAlpha + 2, 0, 255)
        end

        if client.hiddenHackAlpha <= 0 then return end

        local ang = client:EyeAngles()
        local pos = client:EyePos() + ang:Forward() * 10

        ang = Angle(ang.p + 90, ang.y, 0)

        render.ClearStencil()
        render.SetStencilEnable(true)
        render.SetStencilWriteMask(255)
        render.SetStencilTestMask(255)
        render.SetStencilReferenceValue(15)
        render.SetStencilFailOperation(STENCILOPERATION_KEEP)
        render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
        render.SetStencilPassOperation(STENCILOPERATION_KEEP)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
        render.SetBlend(0)


        for i = 1, #plys do
            local ply = plys[i]
            if not ply:IsActive() then continue end
            ply:DrawModel()
        end

        render.SetBlend(1)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)

        cam.Start3D2D(pos, ang, 1)

        surface.SetDrawColor(255, 255, 255, client.hiddenHackAlpha)
        surface.DrawRect(-ScrW(), -ScrH(), ScrW() * 2, ScrH() * 2)

        cam.End3D2D()

        for i = 1, #plys do
            local ply = plys[i]
            if not ply:IsActive() then continue end
            ply:DrawModel()

        end

        render.SetStencilEnable(false)
    end

    hook.Add("PostDrawOpaqueRenderables", "HiddenPlayerVision", HiddenWallhack)

    ColorMod = {}
    ColorMod[ "$pp_colour_addr" ] = 0.09
    ColorMod[ "$pp_colour_addg" ] = 0.03
    ColorMod[ "$pp_colour_addb" ] = 0
    ColorMod[ "$pp_colour_brightness" ] = 0
    ColorMod[ "$pp_colour_contrast" ] = 0.9
    ColorMod[ "$pp_colour_colour" ] = 1
    ColorMod[ "$pp_colour_mulr" ] = 1  
    ColorMod[ "$pp_colour_mulg" ] = 1 
    ColorMod[ "$pp_colour_mulb" ] = 1 

    local function DoHiddenVision()
        local client = LocalPlayer()
        if not client:Alive() or client:IsSpec() then return end
        if client:GetBaseRole() ~= ROLE_HIDDEN or not client:GetNWBool("ttt2_hd_stalker_mode") then return end

        DrawColorModify(ColorMod)
        ColorMod[ "$pp_colour_addr" ] = .09
        ColorMod[ "$pp_colour_addg" ] = .03
	    ColorMod[ "$pp_colour_contrast" ] = 0.9
	    ColorMod[ "$pp_colour_colour" ] = 1

        cam.Start3D(EyePos(), EyeAngles())

        render.SuppressEngineLighting(true)
        render.SetColorModulation(1, 1, 1)
        render.SuppressEngineLighting(false)

        cam.End3D()
    end

    hook.Add("RenderScreenspaceEffects", "HiddenVisionRender", DoHiddenVision)
end

if SERVER then
    local function ActivateCloaking(ply)
        ply.hiddenColor = ply:GetColor()
        ply.hiddenRenderMode = ply:GetRenderMode()
        ply.hiddenMat = ply:GetMaterial()

        -- local ply_color = table.Copy(ply.hiddenColor)
        -- ply_color.a = math.Round(ply_color.a * 0.05)
        local ply_color = Color(255, 255, 255, 50)

        ply:SetColor(ply_color)
        ply:SetMaterial("sprites/heatwave")
        ply:SetRenderMode(RENDERMODE_TRANSALPHA)
    end

    local max_pct = 0.6
    local health_threshold = 25
    local min_alpha = 0.1
    local max_alpha = 0.7

    function plymeta:SetCloakMode(cloak, delta, offset, override)
        delta  = delta or 1
        offset = offset or 0

        local clr = self:GetColor()
        if not self.hiddenColor then self.hiddenColor = clr end
        local render = self:GetRenderMode()
        if not self.hiddenRenderMode then self.hiddenRenderMode = render end
        local mat = self:GetMaterial()
        if not self.hiddenMat then self.hiddenMat = mat end

        if cloak == CLOAK_FULL then
            mat = "sprites/heatwave"
            clr = Color(255, 255, 255, 3)
            render = RENDERMODE_TRANSALPHA
            self:SetNWInt("ttt2_hd_cloak_strength", 100)

        elseif cloak == CLOAK_PARTIAL then
            --local pct = math.Clamp(self:Health() / (self:GetMaxHealth() - 25), 0, 1)

            local pct = math.Clamp((self:Health() / (self:GetMaxHealth() - health_threshold) - 1) * -max_pct, 0, 1)
            local alpha = (override and offset) or (pct + offset) * delta
            mat = self.hiddenMat
            clr = self.hiddenColor

            alpha = math.Clamp(alpha, min_alpha, max_alpha)
            clr.a = alpha * 255
            self:SetNWInt("ttt2_hd_cloak_strength", (1 - alpha) * 100)

        else
            clr = self.hiddenColor
            render = self.hiddenRenderMode
            mat = self.hiddenMat
            self.hiddenCloakTimeout = nil
            self:SetNWInt("ttt2_hd_cloak_strength", 0)
        end
        self:SetColor(clr)
        self:SetRenderMode(render)
        self:SetMaterial(mat)
        self.hiddenCloakMode = cloak
    end

    function plymeta:GetCloakMode()
        return self.hiddenCloakMode
    end

    function plymeta:UpdateCloaking(timeout, delay, alphaOffset, override)
        if not IsValid(self) or not self:IsPlayer() then return end
        if GetRoundState() ~= ROUND_ACTIVE or self:GetBaseRole() ~= ROLE_HIDDEN then self:SetCloakMode(CLOAK_NONE) return end  
        if self:IsSpec() or not self:Alive() then self:SetCloakMode(CLOAK_NONE) return end
        if not self:GetNWBool("ttt2_hd_stalker_mode", false) then self:SetCloakMode(CLOAK_NONE) return end

        if timeout then
            self.hiddenCloakDelay = delay or (8 * (self:Health() / self:GetMaxHealth()))
            self.hiddenCloakTimeout = CurTime() + self.hiddenCloakDelay
            self.hiddenAlphaOffset = alphaOffset or 0
        elseif self.hiddenCloakTimeout and self.hiddenCloakTimeout > CurTime() then
            timeout = true
        end

        if timeout then
            local start = self.hiddenCloakTimeout - self.hiddenCloakDelay
            local delta = (1 - (CurTime() - start) / self.hiddenCloakDelay)

            self:SetCloakMode(CLOAK_PARTIAL, delta, self.hiddenAlphaOffset, override)
        else
            self:SetCloakMode(CLOAK_FULL)
        end
    end

    hook.Add("Think", "HiddenCloakThink", function()
        local plys = player.GetAll()
        for i = 1, #plys do
            local ply = plys[i]
            if ply:GetSubRole() ~= ROLE_HIDDEN or ply:GetCloakMode() == CLOAK_NONE then continue end
            ply:UpdateCloaking()
        end
    end)

    hook.Add("EntityTakeDamage", "TTT2HiddenTakeDamage", function(tgt, dmg)
        if not IsValid(tgt) or not tgt:IsPlayer() or not tgt:Alive() or tgt:IsSpec() then return end
        if tgt:GetSubRole() ~= ROLE_HIDDEN then return end
        if not tgt:GetNWBool("ttt2_hd_stalker_mode", false) then return end
        tgt:UpdateCloaking(true, 5) -- default time of 5 seconds
    end)

    local function DeactivateCloaking(ply)
        ply:SetColor(ply.hiddenColor)
        ply:SetRenderMode(ply.hiddenRenderMode)
        ply:SetMaterial(ply.hiddenMat)
    end

    local function BetterWeaponStrip(ply, exclude_class)
        if not ply or not IsValid(ply) or not ply:IsPlayer() then return end
    
        local weps = ply:GetWeapons()
        for i = 1, #weps do
          local wep = weps[i]
          local wep_class = wep:GetClass()
          if (wep.Kind == WEAPON_EQUIP or wep.Kind == WEAPON_EQUIP2 or wep.Kind == WEAPON_HEAVY or wep.Kind == WEAPON_PISTOL or wep.Kind == WEAPON_NADE) and not exclude_class[wep_class] then
            ply:StripWeapon(wep_class)
          else
            wep.WorldModel = ""
            net.Start("ttt2_hdn_network_wep")
            net.WriteEntity(wep)
            net.WriteString(wep.WorldModel)
            net.Broadcast()
          end
        end
    end

    function plymeta:ActivateHiddenStalker()
        if self:GetSubRole() ~= ROLE_HIDDEN then return end

        local exclude_tbl = {}
        exclude_tbl["weapon_ttt_hd_knife"] = true
        exclude_tbl["weapon_ttt_hd_nade"] = true
        BetterWeaponStrip(self, exclude_tbl)

        self:SetNWBool("ttt2_hd_stalker_mode", true)
        self:SetNWInt("ttt2_hd_cloak_strength", 100)
        self:UpdateCloaking()

        -- events.Trigger(EVENT_HDN_ACTIVATE, self)
    end

    function plymeta:DeactivateHiddenStalker()
        self:SetNWBool("ttt2_hd_stalker_mode", false)
        self:UpdateCloaking()
        -- DeactivateCloaking(self)
    end

    function plymeta:SetStalkerMode(bool)
        if bool then
            self:ActivateHiddenStalker()
            net.Start("ttt2_hdn_epop")
            net.WriteString(self:Nick())
            -- net.SendOmit(self)
            net.Broadcast()
        else
            self:DeactivateHiddenStalker()
        end
    end

    local function ResetHiddenRole()
        local plys = player.GetAll()
        for i = 1, #plys do
            local ply = plys[i]
            ply:SetNWBool("ttt2_hd_stalker_mode", false)
            ply:SetNWBool("ttt2_hd_nade_stun", false)
            ply.hiddenCloakTimeout = nil
            ply.hiddenUseTimeout = nil
        end
    end

    hook.Add("TTTPrepRound", "ResetHiddenRole", ResetHiddenRole)
    hook.Add("TTTBeginRound", "ResetHiddenRole", ResetHiddenRole)
    hook.Add("TTTEndRound", "ResetHiddenRole", ResetHiddenRole)

    hook.Add("PlayerCanPickupWeapon", "NoHiddenPickups", function(ply, wep)
        if not IsValid(ply) or not ply:Alive() or ply:IsSpec() then return end
        if ply:GetSubRole() ~= ROLE_HIDDEN or not ply:GetNWBool("ttt2_hd_stalker_mode", false) then return end

        return (wep:GetClass() == "weapon_ttt_hd_knife" or wep:GetClass() == "weapon_ttt_hd_nade")
    end)

    hook.Add("PlayerCanPickupWeapon", "NoPickupHiddenKnife", function(ply, wep)
        if wep:GetClass() ~= "weapon_ttt_hd_knife" then return end
        if not IsValid(ply) or not ply:Alive() or ply:IsSpec() then return end

        return ply:GetSubRole() == ROLE_HIDDEN
    end)

    hook.Add("TTT2StaminaRegen", "HiddenStaminaMod", function(ply, stamMod)
        if not IsValid(ply) or not ply:Alive() or ply:IsSpec() then return end
        if ply:GetSubRole() ~= ROLE_HIDDEN or not ply:GetNWBool("ttt2_hd_stalker_mode") then return end

        stamMod[1] = stamMod[1] * 1.5
    end)

    hook.Add("ScalePlayerDamage", "HiddenDmgPreTransform", function(ply, _, dmginfo)
        local attacker = dmginfo:GetAttacker()
        if attacker:GetBaseRole() ~= ROLE_HIDDEN then return end
        if attacker:GetNWBool("ttt2_hd_stalker_mode") then return end

        dmginfo:ScaleDamage(0.2)
    end)

    hook.Add("DoPlayerDeath", "TTT2HiddenDied", function(ply, attacker, dmgInfo)
        if ply:GetSubRole() ~= ROLE_HIDDEN or not ply:GetNWBool("ttt2_hd_stalker_mode", false) then return end

        ply:SetStalkerMode(false)
        -- events.Trigger(EVENT_HDN_DEFEAT, ply, attacker, dmgInfo)
        net.Start("ttt2_hdn_epop_defeat")
        net.WriteString(ply:Nick())
        net.Broadcast()
    end)

    hook.Add("PlayerSpawn", "TTT2HiddenRespawn", function(ply)
        if ply:GetBaseRole() ~= ROLE_HIDDEN then return end
        ply:SetStalkerMode(false)
    end)
end

hook.Add("TTTPlayerSpeedModifier", "HiddenSpeedBonus", function(ply, _, _, speedMod)
    if ply:GetSubRole() ~= ROLE_HIDDEN or not ply:GetNWBool("ttt2_hd_stalker_mode") then return end

    speedMod[1] = speedMod[1] * 1.6
end)

if CLIENT then
    net.Receive("ttt2_hdn_epop", function()
        EPOP:AddMessage({
            text = LANG.GetParamTranslation("hdn_epop_title", {nick = net.ReadString()}),
            color = HIDDEN.ltcolor
            },
            LANG.GetTranslation("hdn_epop_desc")
        )
    end)

    net.Receive("ttt2_hdn_epop_defeat", function()
        EPOP:AddMessage({
            text = LANG.GetParamTranslation("hdn_epop_defeat_title", {nick = net.ReadString()}),
            color = HIDDEN.ltcolor
            },
            LANG.GetTranslation("hdn_epop_defeat_desc")
        )
    end)

    net.Receive("ttt2_hdn_network_wep", function()
                net.ReadEntity().WorldModel = net.ReadString()
    end)
end