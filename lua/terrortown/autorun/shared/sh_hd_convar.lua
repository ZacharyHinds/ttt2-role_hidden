CreateConVar("ttt2_hdn_knife_damage", "60", {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- Primary attack damage for knife, require restart
CreateConVar("ttt2_hdn_knife_swing", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- Primary attack speed for knife, requires restart
CreateConVar("ttt2_hdn_knife_delay", "15", {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- Recharge time for thrown knife in seconds
CreateConVar("ttt2_hdn_nade_delay", "30", {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- Recharge time for stun grenade in seconds
CreateConVar("ttt2_hdn_health_bonus", "8", {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- Bonus health gained per player 
CreateConVar("ttt2_hdn_health_max", "300", {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- Maximun ammount of health the player can have
CreateConVar("ttt2_hdn_speed", "1.6", {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- Movement Bonus

hook.Add("TTTUlxDynamicRCVars", "ttt2_hdn_ulx_convars", function(tbl)
    tbl[ROLE_HIDDEN] = tbl[ROLE_HIDDEN] or {}
        
    table.insert(tbl[ROLE_HIDDEN], {
        cvar = "ttt2_hdn_knife_damage",
        slider = true,
        min = 1,
        max = 100,
        desc = "ttt2_hdn_knife_damage (def. 60)"
    })
        
	table.insert(tbl[ROLE_HIDDEN], {
        cvar = "ttt2_hdn_knife_swing",
        slider = true,
        min = 1,
        max = 2,
		decimal = 1,
        desc = "ttt2_hdn_knife_swing (def. 1)"
    })
        
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
        
    table.insert(tbl[ROLE_HIDDEN], {
        cvar = "ttt2_hdn_health_bonus",
        slider = true,
        min = 1,
        max = 50,
        desc = "ttt2_hdn_health_bonus (def. 8)"
    })
	
	table.insert(tbl[ROLE_HIDDEN], {
        cvar = "ttt2_hdn_health_max",
        slider = true,
        min = 100,
        max = 500,
        desc = "ttt2_hdn_health_max (def. 300)"
    })
	
	table.insert(tbl[ROLE_HIDDEN], {
        cvar = "ttt2_hdn_speed",
        slider = true,
        min = 1,
        max = 2,
		decimal = 1,
        desc = "ttt2_hdn_speed_max (def. 1.6)"
    })
end)
