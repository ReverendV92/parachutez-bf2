AddCSLuaFile()
util.PrecacheModel( "models/jessev92/military/mw2_parachute.mdl" )
util.PrecacheModel( "models/jessev92/bf2/parachute.mdl" )
util.PrecacheSound( "ambient/fire/mtov_flame2.wav" )
util.PrecacheSound( "npc/combine_soldier/zipline_clip1.wav" )
util.PrecacheSound( "npc/combine_soldier/zipline_clip2.wav" )

sound.Add({	name 		= "CmbSoldier_ZipLine_Clip",
	channel 	= CHAN_BODY,
	volume		= 1.0,
	level		= 50,
	pitch		= { 90, 110 },
	sound		= { "npc/combine_soldier/zipline_clip1.wav", "npc/combine_soldier/zipline_clip2.wav"}
} )

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
