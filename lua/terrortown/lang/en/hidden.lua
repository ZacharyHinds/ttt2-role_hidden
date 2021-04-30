L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[HIDDEN.name] = "Hidden"
L[HIDDEN.defaultTeam] = "Team Hiddens"
L["hilite_win_" .. HIDDEN.defaultTeam] = "Team Hiddens Win"
L["info_popup_" .. HIDDEN.name] = [[You are the Hidden! 
Press Reload to transform permanently and begin killing.]]
L["body_found_" .. HIDDEN.abbr] = "They were a Hidden!"
L["search_role_" .. HIDDEN.abbr] = "This person was a Hidden!"
L["target_" .. HIDDEN.name] = "Hidden"
L["ttt2_desc_" .. HIDDEN.name] = [[The Hidden is a neutral killer. By unleashing their power, they gain speed and invisibility but 
are limited to their knife and special grenade.]]

--Weapons
L["weapon_ttt_hdn_nade_name"] = "Stun Grenade"
L["weapon_ttt_hdn_knife_name"] = "Hidden's Knife"

--EPOP
L["hdn_epop_title"] = "{nick} is the Hidden!"
L["hdn_epop_desc"] = "Kill them before they kill you all!"
L["hdn_epop_defeat_title"] = "{nick} the Hidden has been defeated!"
L["hdn_epop_defeat_desc"] = "You survived the Hidden threat."

--EVENT STRINGS
L["hdn_activate_title"] = "A Hidden activated their power"
L["hdn_activate_desc"] = "{nick} entered Hidden mode"
L["hdn_defeat_title"] = "A Hidden has been defeated"
L["hdn_defeat_score"] = "Hidden Defeated: "
L["tooltip_hdn_defeat_score"] = "Hidden Defeated: {score}"

