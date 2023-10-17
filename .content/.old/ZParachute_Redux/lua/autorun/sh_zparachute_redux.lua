
AddCSLuaFile()

-------------------------------------------------------
-------------------------------------------------------
--	ZParachute by Zoey
--	Overhaul by V92 with permission from Z
--	Profile Link:	http://steamcommunity.com/id/JesseVanover/
--	Workshop Link:	http://steamcommunity.com/sharedfiles/filedetails/?id=484061347
-------------------------------------------------------
-------------------------------------------------------

if !ConVarExists("VNT_Debug_Prints") then				CreateClientConVar( "VNT_Debug_Prints", '1', true, false ) end
if !ConVarExists("VNT_ZParachute_mdl") then				CreateClientConVar( "VNT_ZParachute_mdl", "models/jessev92/justcause/parachute.mdl", true, true ) end
if !ConVarExists("VNT_ZParachute_jumpdeploy") then		CreateClientConVar( "VNT_ZParachute_jumpdeploy", 1, true, true ) end
if !ConVarExists("VNT_ZParachute_colourmode") then		CreateClientConVar( "VNT_ZParachute_colourmode", 3,	true, true ) end
if !ConVarExists("VNT_ZParachute_colour_r") then		CreateClientConVar( "VNT_ZParachute_colour_r", 255,	true, true ) end
if !ConVarExists("VNT_ZParachute_colour_g") then		CreateClientConVar( "VNT_ZParachute_colour_g", 255,	true, true ) end
if !ConVarExists("VNT_ZParachute_colour_b") then		CreateClientConVar( "VNT_ZParachute_colour_b", 255,	true, true ) end
if !ConVarExists("VNT_ZParachute_Sensitivity") then		CreateClientConVar( "VNT_ZParachute_Sensitivity", 1, true, true ) end
if !ConVarExists("VNT_ZParachute_delay") then			CreateConVar( "VNT_ZParachute_delay", 15,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } ) end
if !ConVarExists("VNT_ZParachute_behaviour") then		CreateConVar( "VNT_ZParachute_behaviour", 0,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } ) end
if !ConVarExists("VNT_ZParachute_speed_i") then			CreateConVar( "VNT_ZParachute_speed_i", 350,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } ) end
if !ConVarExists("VNT_ZParachute_speed_i_down") then	CreateConVar( "VNT_ZParachute_speed_i_down", 275,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } ) end
if !ConVarExists("VNT_ZParachute_speed_f") then			CreateConVar( "VNT_ZParachute_speed_f", 450,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } ) end
if !ConVarExists("VNT_ZParachute_speed_f_down") then	CreateConVar( "VNT_ZParachute_speed_f_down", 320,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } ) end
if !ConVarExists("VNT_ZParachute_speed_b") then			CreateConVar( "VNT_ZParachute_speed_b", 256,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } ) end
if !ConVarExists("VNT_ZParachute_speed_b_down") then	CreateConVar( "VNT_ZParachute_speed_b_down", 200,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } ) end
if !ConVarExists("VNT_ZParachute_AllowWeapons") then	CreateConVar( "VNT_ZParachute_AllowWeapons", 0,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } ) end

if GetConVarNumber( "VNT_Debug_Prints" ) != 0 then	print("[V92] sh_ZParachuteRedux.lua Loading...") end

--	 AutoDL the Workshop copy, so that you can not have to sit through a 30 minute download of each file...
if SERVER then	resource.AddWorkshop("484061347") end

--	Precache Models

util.PrecacheModel( "models/jessev92/gtaiv/parachute.mdl"	)
util.PrecacheModel( "models/jessev92/justcause/parachute.mdl"	)
util.PrecacheModel( "models/jessev92/bf2/parachute.mdl"	)
util.PrecacheModel( "models/jessev92/bf2142/parachute.mdl"	)
util.PrecacheModel( "models/jessev92/frontlines/parachute.mdl"	)
util.PrecacheModel( "models/jessev92/resliber/items/parachute.mdl"	)
util.PrecacheModel( "models/jessev92/resliber/items/parachute_backpack_closed.mdl"	)
util.PrecacheModel( "models/jessev92/resliber/items/parachute_backpack_open.mdl"	)
util.PrecacheModel( "models/jessev92/resliber/items/parachute_deployed.mdl"	)
util.PrecacheModel( "models/jessev92/military/mw2_parachute.mdl"	)
util.PrecacheModel( "models/jessev92/military/mw2_parachute_ground_skins.mdl"	)

--	Precache Sounds

util.PrecacheSound("ambient/fire/mtov_flame2.wav")
util.PrecacheSound("npc/combine_soldier/zipline_clip1.wav")
util.PrecacheSound("npc/combine_soldier/zipline_clip2.wav")

sound.Add({	name 		= "CmbSoldier_ZipLine_Clip",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 50,
	pitch		= { 90, 110 },
	sound		= { "npc/combine_soldier/zipline_clip1.wav", "npc/combine_soldier/zipline_clip2.wav"}
} )

sound.Add({	name		= "V92_ZPWep_Deploy",
	channel		= CHAN_BODY,
	volume		= 1.0,
	level		= 100,
	pitch		= { 105, 110 },
	--sound		= {"jessev92/parachute/deploy1.wav","jessev92/parachute/deploy2.wav","jessev92/parachute/deploy3.wav","jessev92/parachute/deploy4.wav","jessev92/parachute/deploy5.wav"}
	sound		= {"common/null.wav"}
})

sound.Add({	name		= "V92_ZP_BF2142_Deploy",
	channel		= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 105, 110 },
	sound		= {"jessev92/bf2142/vehicles/parachute_open.wav"}
})

sound.Add({	name		= "V92_ZP_BF2_Deploy",
	channel		= CHAN_BODY,
	volume		= 1.0,
	level		= 75,
	pitch		= { 105, 110 },
	sound		= {"jessev92/bf2/vehicles/parachute_deploy.wav"}
})

sound.Add({	name		= "V92_ZP_BF2_Idle",
	channel		= CHAN_STATIC,
	volume		= 1.0,
	level		= 75,
	pitch		= { 105, 110 },
	sound		= {"jessev92/bf2/vehicles/parachute_ride_loop.wav"}
})

local	function vntZParachuteOptions( Panel )

	Panel:ClearControls()

	Panel:AddControl( "Header", { 
	Text = "ZParachute" ,
	Description	=[[Welcome to ZParachute!
	You can find all the options and controls to customize the addon below.
	To select a parachute model, 
	use your context menu key and
	open the ZParachute menu at the top left.

	Leave Feedback Here:
	http://steamcommunity.com/groups/firestormstudios
	
	Task List Here:
	https://trello.com/b/BHzhSvWl/zparachute
	
	Enjoy!
	]]
	}  )

	--[[
	Panel:AddControl( "Checkbox", 	{ 
	Label = "Jump to Deploy",	
	Command = "VNT_ZParachute_jumpdeploy",
	Type = "bool", 	
	}  )
	--]]

	Panel:AddControl( "Header", { 
	Text = "Mode" ,
	Description	=[[Parachute Custom Colour Modes:
	0: Default Colour
	1: Weapon Colour
	2: Player Colour
	3: Picker Colour Below]]
	}  )

	Panel:AddControl( "Slider", 	{ 
	Label = "Colour Mode",	
	Command = "VNT_ZParachute_colourmode",
	Type = "int", 	
	Min = "0", 	
	Max = "3"
	}  )

	Panel:AddControl( "Color", { 
	Label = "#tool.balloon.color", 
	Red = "VNT_ZParachute_colour_r", 
	Green = "VNT_ZParachute_colour_g", 
	Blue = "VNT_ZParachute_colour_b", 
	ShowAlpha = "0", 
	ShowHSV = "1",
	ShowRGB = "1" }  ) 		

	Panel:AddControl( "Slider", 	{ 
	Label = "Turning Sensitivity",	
	Command = "VNT_ZParachute_sensitivity",
	Type = "float", 	
	Min = "0", 	
	Max = "5"
	}  )

	Panel:AddControl( "Header",	{
	Text	= "Behavior",
	Description	=	[[Parachute Unique Behaviour Modes:
	0: Unique Behaviour for Each Chute Model
	1: Behaviour Defined by CVars
	2: Behaviour is Standard for ALL Models]]
	} )
	
	Panel:AddControl( "Slider", 	{ 
	Label = "Behavior Mode",	
	Command = "VNT_ZParachute_behaviour",
	Type = "int", 	
	Min = "0", 	
	Max = "2"
	}  )
	
	Panel:AddControl( "Slider", 	{ 
	Label = "Speed - Idle Forward",	
	Command = "VNT_ZParachute_speed_i",
	Type = "int", 	
	Min = "1", 	
	Max = "750"
	}  )

	Panel:AddControl( "Slider", 	{ 
	Label = "Speed - Idle Down",	
	Command = "VNT_ZParachute_speed_i_down",
	Type = "int", 	
	Min = "1", 	
	Max = "500"
	}  )

	Panel:AddControl( "Slider", 	{ 
	Label = "Speed - Forward",	
	Command = "VNT_ZParachute_speed_f",
	Type = "int", 	
	Min = "1", 	
	Max = "500"
	}  )

	Panel:AddControl( "Slider", 	{ 
	Label = "Speed - Forward Down",	
	Command = "VNT_ZParachute_speed_f_down",
	Type = "int", 	
	Min = "1", 	
	Max = "500"
	}  )

	Panel:AddControl( "Slider", 	{ 
	Label = "Speed - Back",	
	Command = "VNT_ZParachute_speed_b",
	Type = "int", 	
	Min = "1", 	
	Max = "1000"
	}  )

	Panel:AddControl( "Slider", 	{ 
	Label = "Speed - Back Down",	
	Command = "VNT_ZParachute_speed_b_down",
	Type = "int", 	
	Min = "1", 	
	Max = "500"
	}  )
	
	Panel:AddControl( "Checkbox", 	{ 
	Label = "Allow Weapons During Flight",	
	Command = "VNT_ZParachute_AllowWeapons",
	Type = "bool", 	
	}  )

	Panel:AddControl( "Checkbox", 	{ 
	Label = "Debug Prints",	
	Command = "VNT_Debug_Prints",
	Type = "bool", 	
	}  )

end

local	function ZPIndex() spawnmenu.AddToolMenuOption( "Options", "V92",   "ZParachute",   "ZParachute",    "",    "",    vntZParachuteOptions ) end
hook.Add( "PopulateToolMenu", "ZPIndex", ZPIndex )

if GetConVarNumber( "VNT_Debug_Prints" ) != 0 then	print("[V92] sh_ZParachuteRedux.lua Loaded!") end
