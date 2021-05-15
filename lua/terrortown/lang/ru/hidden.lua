L = LANG.GetLanguageTableReference("ru")

-- GENERAL ROLE LANGUAGE STRINGS
L[HIDDEN.name] = "Хайдэн"
L[HIDDEN.defaultTeam] = "Команда Хайдэнов"
L["hilite_win_" .. HIDDEN.defaultTeam] = "Победа Хайдэнов"
L["info_popup_" .. HIDDEN.name] = [[Вы Хайдэн! 
Нажмите Перезарядку, чтобы окончательно трансформироваться и начать убивать.]]
L["body_found_" .. HIDDEN.abbr] = "Он был Хайдэном!"
L["search_role_" .. HIDDEN.abbr] = "Этот человек был Хайдэном!"
L["target_" .. HIDDEN.name] = "Хайдэн"
L["ttt2_desc_" .. HIDDEN.name] = [[Хайдэн - нейтральный убийца. Высвобождая свою силу, он обретает скорость и невидимость, но
ограничен использовать только свой нож и особую гранату.]]

--Weapons
L["weapon_ttt_hdn_nade_name"] = "Оглушающая граната"
L["weapon_ttt_hdn_knife_name"] = "Нож Хайдэна"

--EPOP
L["hdn_epop_title"] = "{nick} является Хайдэном!"
L["hdn_epop_desc"] = "Убейте их, пока они не убили всех вас!"
L["hdn_epop_defeat_title"] = "{nick}, был убит, будучи Хайденом!"
L["hdn_epop_defeat_desc"] = "Вы пережили угрозу Хайдэна."

--EVENT STRINGS
L["hdn_activate_title"] = "Хайдэн активировал свою силу"
L["hdn_activate_desc"] = "{nick} вошёл в режим Хайдэна"
L["hdn_defeat_title"] = "Хайдэн был побеждён"
L["hdn_defeat_score"] = "Побеждённые Хайдэном: "
L["tooltip_hdn_defeat_score"] = "Побеждённые Хайдэном: {score}"

