L = LANG.GetLanguageTableReference("de")

-- GENERAL ROLE LANGUAGE STRINGS
L[HIDDEN.name] = "Verborgene"
L[HIDDEN.defaultTeam] = "Team Verborgene"
L["hilite_win_" .. HIDDEN.defaultTeam] = "Die Verborgenen gewinnen"
L["info_popup_" .. HIDDEN.name] = [[Du bist der Verborgene! 
Drücke Nachladen, um dich dauerhauft zu verwandeln und mit dem Töten zu beginnen.]]
L["body_found_" .. HIDDEN.abbr] = "Es war ein Verborgener!"
L["search_role_" .. HIDDEN.abbr] = "Diese Person war ein Verborgener!"
L["target_" .. HIDDEN.name] = "Verborgener"
L["ttt2_desc_" .. HIDDEN.name] = [[Der Verborgene ist ein neutraler Killer. Durch das Entfesseln seiner Kraft gewinnt er an Geschwindigkeit und wird unsichtbar.
Allerdings stehen ihm nur noch ein Messer und Spezialgranaten zur Verfügung.]]

--Weapons
L["weapon_ttt_hdn_nade_name"] = "Blendgranate"
L["weapon_ttt_hdn_knife_name"] = "Verborgenes Messer"

--EPOP
L["hdn_epop_title"] = "{nick} ist der Verborgene!"
L["hdn_epop_desc"] = "Tötet ihn, bevor er euch alle tötet!"
L["hdn_epop_defeat_title"] = "{nick}, der Verborgene, wurde besiegt!"
L["hdn_epop_defeat_desc"] = "Der Verborgene ist keine Gefahr mehr."

--EVENT STRINGS
L["hdn_activate_title"] = "Ein Verborgener hat seine Kräfte enfesselt"
L["hdn_activate_desc"] = "{nick} hat den Verborgen-Modus aktiviert"
L["hdn_defeat_title"] = "Ein Verborgener wurde besiegt"
L["hdn_defeat_score"] = "Verborgenen besiegt: "
L["tooltip_hdn_defeat_score"] = "Verborgenen besiegt: {score}"

