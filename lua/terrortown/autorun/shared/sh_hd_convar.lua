CreateConVar("ttt2_hdn_knife_delay", "15", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_hdn_nade_delay", "30", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_hdn_stun_duration", "5", {FCVAR_ARCHIVE, FCVAR_NOTIFY})

hook.Add("TTTUlxDynamicRCVars", "ttt2_hdn_ulx_convars", function(tbl)
    tbl[ROLE_HIDDEN] = tbl[ROLE_HIDDEN] or {}

    table.insert(tbl[ROLE_HIDDEN], {
        cvar = "ttt2_hdn_knife_delay",
        slider = true,
        min = 1,
        max = 60,
        desc = "ttt2_hdn_knife_delay (def. 15)"
    })

    table.insert(tbl[ROLE_HIDDEN], {
        cvar = "ttt2_hdn_nade_delay",
        slider = true,
        min = 1,
        max = 60,
        desc = "ttt2_hdn_nade_delay (def. 30)"
    })

    table.insert(tbl[ROLE_HIDDEN], {
        cvar = "ttt2_hdn_stun_duration",
        slider = true,
        min = 1,
        max = 30,
        desc = "ttt2_hdn_stun_duration (def. 5)"
    })
end)