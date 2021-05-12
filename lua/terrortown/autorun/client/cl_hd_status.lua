hook.Add("Initialize", "ttt2_hdn_status_init", function()
    STATUS:RegisterStatus("ttt2_hdn_knife_recharge", {
        hud = Material("vgui/ttt/hdn/icon_knife.vmt"),
        type = "bad"
    })

    STATUS:RegisterStatus("ttt2_hdn_nade_recharge", {
        hud = Material("vgui/ttt/hdn/icon_grenade.vmt"),
        type = "bad"
    })

    STATUS:RegisterStatus("ttt2_hdn_invisbility", {
        hud = Material("vgui/ttt/dynamic/roles/icon_hdn.vmt"),
        type = "good",
        DrawInfo = function()
            local ply = LocalPlayer()
            if ply:Health() >= ply:GetMaxHealth() - 25 then
                return tostring(100) .. "%"
            else
                return tostring(math.Round(math.Clamp((ply:Health() / (ply:GetMaxHealth() - 25) * 100), 0, 50))) .. "%"
            end
        end
    })
end)

hook.Add("TTTRenderEntityInfo", "ttt2_hidden_stalker_targetid", function(tData)
    if not HIDDEN then return end
    
    local ent = tData:GetEntity()
    
    if not ent:IsPlayer() then return end

    local ply = LocalPlayer()

    -- if ply:GetTeam() == TEAM_HIDDEN or ent:GetTeam() ~= TEAM_HIDDEN then return end
    if not ent:GetNWBool("ttt2_hd_stalker_mode", false) then return end

    tData:EnableText(false)
    tData:EnableOutline(false)

end)