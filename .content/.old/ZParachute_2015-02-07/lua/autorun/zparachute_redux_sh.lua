
AddCSLuaFile()

print("ZParachute Redux - Shared File Loading...")

--	 AutoDL the Workshop copy, so that you can not have to sit through a 30 minute download of each file...
if SERVER then	resource.AddWorkshop("105699464")	end

--	Precache Models

util.PrecacheModel( "models/jessev92/parachute_gtaiv.mdl"	)
util.PrecacheModel( "models/jessev92/parachute_justcause.mdl"	)
util.PrecacheModel( "models/jessev92/bf2/parachute.mdl"	)
util.PrecacheModel( "models/jessev92/frontlines/parachute.mdl"	)
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

--[[

--	Auto-DL Models

resource.AddFile( "models/jessev92/parachute_gtaiv.mdl"	)
resource.AddFile( "models/jessev92/parachute_justcause.mdl"	)
resource.AddFile( "models/jessev92/bf2/parachute.mdl"	)
resource.AddFile( "models/jessev92/frontlines/parachute.mdl"	)
resource.AddFile( "models/jessev92/military/mw2_parachute.mdl"	)
resource.AddFile( "models/jessev92/military/mw2_parachute_ground_skins.mdl"	)

--	Auto-DL Materials

resource.AddFile( "materials/models/jessev92/bf2/parachute_c.vmt"	)
resource.AddFile( "materials/models/jessev92/frontlines/SKV_SD_Parachute_c.vmt"	)
resource.AddFile( "materials/models/jessev92/gtaiv/mw2_para.vmt"	)
resource.AddFile( "materials/models/jessev92/gtaiv/para_gta_proxy.vmt"	)
resource.AddFile( "materials/models/jessev92/gtaiv/parachute.vmt"	)
resource.AddFile( "materials/models/jessev92/justcause/parachute_cables.vmt"	)
resource.AddFile( "materials/models/jessev92/justcause/parachute_cloth.vmt"	)
resource.AddFile( "materials/models/jessev92/mw2/mw2_para.vmt"	)
resource.AddFile( "materials/models/jessev92/mw2/mw2_para_bf2.vmt"	)
resource.AddFile( "materials/models/jessev92/mw2/mw2_para_gta.vmt"	)
resource.AddFile( "materials/models/jessev92/mw2/mw2_para_gta_proxy.vmt"	)
resource.AddFile( "materials/models/jessev92/mw2/mw2_para_kaos.vmt"	)

--	Auto-DL Sounds

resource.AddFile(	"sound/npc/combine_soldier/zipline_clip1.wav"	)
resource.AddFile(	"sound/npc/combine_soldier/zipline_clip2.wav"	)

--]]

print("ZParachute Redux - Shared File Loaded!")