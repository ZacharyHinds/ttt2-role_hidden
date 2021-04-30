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
