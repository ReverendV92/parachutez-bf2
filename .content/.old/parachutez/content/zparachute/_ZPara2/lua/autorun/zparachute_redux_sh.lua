
AddCSLuaFile()

-------------------------------------------------------
-------------------------------------------------------
--	ZParachute by Zoey
--	Overhaul by V92 with permission from Z
--	Profile Link:	http://steamcommunity.com/id/JesseVanover/
--	Workshop Link:	http://steamcommunity.com/sharedfiles/filedetails/?id=450085695
-------------------------------------------------------
-------------------------------------------------------

if !ConVarExists("vnt_debug_prints") then				CreateClientConVar( "vnt_debug_prints", '1', true, false )	end
if !ConVarExists("vnt_zparachute_mdl") then				CreateClientConVar( "vnt_zparachute_mdl", "models/jessev92/justcause/parachute.mdl", true, false ) end
if !ConVarExists("vnt_zparachute_jumpdeploy") then		CreateClientConVar( "vnt_zparachute_jumpdeploy", 1, true, false ) end
if !ConVarExists("vnt_zparachute_colourmode") then		CreateClientConVar( "vnt_zparachute_colourmode", 3,	true, false )	end
if !ConVarExists("vnt_zparachute_colour_r") then		CreateClientConVar( "vnt_zparachute_colour_r", 255,	true, false )	end
if !ConVarExists("vnt_zparachute_colour_g") then		CreateClientConVar( "vnt_zparachute_colour_g", 255,	true, false )	end
if !ConVarExists("vnt_zparachute_colour_b") then		CreateClientConVar( "vnt_zparachute_colour_b", 255,	true, false )	end
if !ConVarExists("vnt_zparachute_delay") then			CreateConVar( "vnt_zparachute_delay", 15,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } )	end
if !ConVarExists("vnt_zparachute_behaviour") then		CreateConVar( "vnt_zparachute_behaviour", 0,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } )	end
if !ConVarExists("vnt_zparachute_speed_i") then			CreateConVar( "vnt_zparachute_speed_i", 350,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } )	end
if !ConVarExists("vnt_zparachute_speed_i_down") then	CreateConVar( "vnt_zparachute_speed_i_down", 275,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } )	end
if !ConVarExists("vnt_zparachute_speed_f") then			CreateConVar( "vnt_zparachute_speed_f", 450,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } )	end
if !ConVarExists("vnt_zparachute_speed_f_down") then	CreateConVar( "vnt_zparachute_speed_f_down", 320,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } )	end
if !ConVarExists("vnt_zparachute_speed_b") then			CreateConVar( "vnt_zparachute_speed_b", 256,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } )	end
if !ConVarExists("vnt_zparachute_speed_b_down") then	CreateConVar( "vnt_zparachute_speed_b_down", 200,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } )	end

if GetConVarNumber( "vnt_debug_prints" ) != 0 then	print("ZParachute Redux - Shared File Loading...")	end

--	 AutoDL the Workshop copy, so that you can not have to sit through a 30 minute download of each file...
if SERVER then	resource.AddWorkshop("450085695")	end

--	Precache Models

util.PrecacheModel( "models/jessev92/gtaiv/parachute.mdl"	)
util.PrecacheModel( "models/jessev92/justcause/parachute.mdl"	)
util.PrecacheModel( "models/jessev92/bf2/parachute.mdl"	)
util.PrecacheModel( "models/jessev92/bf2142/parachute.mdl"	)
util.PrecacheModel( "models/jessev92/frontlines/parachute.mdl"	)
util.PrecacheModel( "models/jessev92/ww2_rl/parachute.mdl"	)
util.PrecacheModel( "models/jessev92/ww2_rl/parachute_backpack_closed.mdl"	)
util.PrecacheModel( "models/jessev92/ww2_rl/parachute_backpack_open.mdl"	)
util.PrecacheModel( "models/jessev92/ww2_rl/parachute_deployed.mdl"	)
util.PrecacheModel( "models/jessev92/military/mw2_parachute.mdl"	)
util.PrecacheModel( "models/jessev92/military/mw2_parachute_ground_skins.mdl"	)

--	Precache Sounds

util.PrecacheSound("ambient/fire/mtov_flame2.wav")
util.PrecacheSound("npc/combine_soldier/zipline_clip1.wav")
util.PrecacheSound("npc/combine_soldier/zipline_clip2.wav")

sound.Add( {
	name 		= "CmbSoldier_ZipLine_Clip",
	channel 	= CHAN_AUTO,
	volume		= 1.0,
	level		= 50,
	pitchstart	= 90,
	pitchend	= 110,
	sound		= { "npc/combine_soldier/zipline_clip1.wav", "npc/combine_soldier/zipline_clip2.wav"}
} )

sound.Add({
	name				= "V92_ZPWep_Deploy",
	channel				= CHAN_BODY,
	volume				= 1.0,
	level				= 100,
	pitchstart			= 95,
	pitchend			= 105,
	sound				= {"jessev92/parachute/deploy1.wav","jessev92/parachute/deploy2.wav","jessev92/parachute/deploy3.wav","jessev92/parachute/deploy4.wav","jessev92/parachute/deploy5.wav"}
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

	Panel:AddControl( "Checkbox", 	{ 
	Label = "Jump to Deploy",	
	Command = "vnt_zparachute_jumpdeploy",
	Type = "bool", 	
	}  )

	Panel:AddControl( "Header", { 
	Text = "Mode" ,
	Description	=[[Parachute Custom Colour Modes:
	0: Default Colour
	1: Weapon Colour
	2: Player Colour
	3: Picker Colour Below
	]]
	}  )

	Panel:AddControl( "Slider", 	{ 
	Label = "Colour Mode",	
	Command = "vnt_zparachute_colourmode",
	Type = "int", 	
	Min = "0", 	
	Max = "3"
	}  )

	Panel:AddControl( "Color", { 
	Label = "#tool.balloon.color", 
	Red = "vnt_zparachute_colour_r", 
	Green = "vnt_zparachute_colour_g", 
	Blue = "vnt_zparachute_colour_b", 
	ShowAlpha = "0", 
	ShowHSV = "1",
	ShowRGB = "1" }  )			

	Panel:AddControl( "Header",	{
	Text	= "Behavior",
	Description	=	[[Parachute Unique Behaviour Modes:
	0: Unique Behaviour for Each Chute Model
	1: Behaviour Defined by CVars
	2: Behaviour is Standard for ALL Models
	]]
	} )
	
	Panel:AddControl( "Slider", 	{ 
	Label = "Behavior Mode",	
	Command = "vnt_zparachute_behaviour",
	Type = "int", 	
	Min = "0", 	
	Max = "2"
	}  )
	
	Panel:AddControl( "Slider", 	{ 
	Label = "Speed - Idle Forward",	
	Command = "vnt_zparachute_speed_i",
	Type = "int", 	
	Min = "1", 	
	Max = "750"
	}  )

	Panel:AddControl( "Slider", 	{ 
	Label = "Speed - Idle Down",	
	Command = "vnt_zparachute_speed_i_down",
	Type = "int", 	
	Min = "1", 	
	Max = "500"
	}  )

	Panel:AddControl( "Slider", 	{ 
	Label = "Speed - Forward",	
	Command = "vnt_zparachute_speed_f",
	Type = "int", 	
	Min = "1", 	
	Max = "500"
	}  )

	Panel:AddControl( "Slider", 	{ 
	Label = "Speed - Forward Down",	
	Command = "vnt_zparachute_speed_f_down",
	Type = "int", 	
	Min = "1", 	
	Max = "500"
	}  )

	Panel:AddControl( "Slider", 	{ 
	Label = "Speed - Back",	
	Command = "vnt_zparachute_speed_b",
	Type = "int", 	
	Min = "1", 	
	Max = "1000"
	}  )

	Panel:AddControl( "Slider", 	{ 
	Label = "Speed - Back Down",	
	Command = "vnt_zparachute_speed_b_down",
	Type = "int", 	
	Min = "1", 	
	Max = "500"
	}  )

	Panel:AddControl( "Checkbox", 	{ 
	Label = "Debug Prints",	
	Command = "vnt_debug_prints",
	Type = "bool", 	
	}  )

end

local	function ZPIndex()	spawnmenu.AddToolMenuOption( "Options", "V92",   "ZParachute",   "ZParachute",    "",    "",    vntZParachuteOptions )	end
hook.Add( "PopulateToolMenu", "ZPIndex", ZPIndex )



if GetConVarNumber( "vnt_debug_prints" ) != 0 then	print("ZParachute Redux - Shared File Loaded!")	end
