
AddCSLuaFile()

dg_backpack_config = {}

dg_backpack_config["model"] = "models/props_c17/suitcase001a.mdl" -- Model of the parachute pickupable entity
dg_backpack_config["pickup_sound"] = "player/footsteps/snow6.wav" -- Sound when picking up the parachute
dg_backpack_config["pickup_denied_sound"] = "common/wpn_select.wav" -- We already have a parachute equipped


dg_backpack_config["chat_color_prefix"] = Color(125, 0, 125)
dg_backpack_config["chat_color_sentence"] = Color(255, 255, 255)

dg_backpack_config["picked_up_message"] = "Parachute equipped"
dg_backpack_config["already_equipped_message"] = "You already have a parachute !"
-- The following option sets the velocity required for the parachute to be triggered by space
-- This was defaulted at 600 in the base addon.
-- The lower the number, the less upward speed is required to open the parachute.
-- Setting this to 1 would allow you to activate it when jumping from a curb.
-- 1000 and you would need to fall from pretty high to gain enough speed to activate it

-- From testing, it seems like 500 is a pretty good sweetspot, but feel free to change it to whatever you want,
-- This option is there for that !
dg_backpack_config["velocity_required_to_activate"] = 500
