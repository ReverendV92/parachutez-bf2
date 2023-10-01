
AddCSLuaFile( )

------------------------------------------------------
if not VNTCB then return false end --	Prevent this file from loading if for some odd reason the base Lua isn't loaded
------------------------------------------------------
--	Jesse V92's Custom SWep Base					--
--	Start Date:	2016/07/14							--
--	Purpose: Create a good SWep base				--
------------------------------------------------------
--	If you want to make weapons, you need to change	--
--		only the values listed with comments below.	--
--	The rest of it has been coded so it will read	--
--		these values and react properly.			--
--	If you want to make SWeps, refer to samples.	--
--	Those will show you in how to make SWeps.		--
--	When in doubt, contact me.						--
------------------------------------------------------
--	REMOVE LINES YOU DID NOT CHANGE!				--
--	THIS WILL SPEED UP LOAD TIMES!					--
------------------------------------------------------
--	Spawn settings									--
--	Can we spawn this?								--
------------------------------------------------------

SWEP.Spawnable = true -- (Boolean) Can be spawned via the menu
SWEP.AdminOnly = false -- (Boolean) Admin only spawnable
SWEP.Base = VNTCB.Bases.WepParachute -- (Weapon) Base to derive from
list.Add( "VNTParachutes", SWEP ) -- Add the parachute to a list so we can auto deploy it

------------------------------------------------------
--	Client Information								--
--	Info used in the client block of the weapon		--
------------------------------------------------------

--SWEP.WeaponName = VNTCB.Bases.WepParachute -- (String) Name of the weapon script
SWEP.WeaponName = "v92_bf2142_parachute" -- (String) Name of the weapon script
SWEP.WeaponEntityName = SWEP.WeaponName .. "_ent" -- (String) Name of the weapon entity in Lua/Entities/Entityname.lua
SWEP.PrintName = "Parachute" -- (String) Printed name on menu
SWEP.Category = VNTCB.Category.BF2142 -- (String) Category
SWEP.Instructions = VNTCB.instructions -- (String) Instruction
SWEP.Author = VNTCB.author -- (String) Author
SWEP.Contact = VNTCB.contact -- (String) Contact
SWEP.Purpose = VNTCB.purpose -- (String) Purpose
SWEP.WorkshopID = "895159273" -- (Integer) Workshop ID number of the upload that contains this file.

------------------------------------------------------
--	Model Information								--	
--	Model settings and infomation					--
------------------------------------------------------

SWEP.UseHands = true -- (Boolean) Leave at false unless the model uses C_Arms
SWEP.ViewModelFlip = false -- (Boolean) Only used for vanilla CS:S models
SWEP.ViewModel = Model( "models/jessev92/weapons/unarmed_c.mdl" ) -- (String) View model - v_*
SWEP.WorldModel = Model( "models/jessev92/rnl/weapons/parachute_closed_2017_w.mdl" ) -- (String) World model - w_*

------------------------------------------------------
--	Primary Fire Settings							--
--	Settings for the primary fire of the weapon		--
------------------------------------------------------

SWEP.Primary.ClipSize = -1 -- (Integer) Size of a magazine
SWEP.Primary.DefaultClip = 1 -- (Integer) Default number of ammo you spawn with
SWEP.Primary.Ammo = "parachute" -- (String) Primary ammo used by the weapon, bullets probably
SWEP.Secondary.Ammo = "none" -- (String) Primary ammo used by the weapon, bullets probably

------------------------------------------------------
--	Parachute										--
--	HQ, Send in the Fly-Boys!						--
------------------------------------------------------

SWEP.ViewModelPacked = Model( "models/jessev92/weapons/unarmed_c.mdl" ) -- (String) View model before deployment - v_*
SWEP.ViewModelOpen = Model( "models/jessev92/ffow/weapons/parachute_c.mdl" ) -- (String) View model after deployment - v_*
SWEP.WorldModelPacked = Model( "models/jessev92/rnl/weapons/parachute_closed_2017_w.mdl" ) -- (String) World model before deployment - w_*
SWEP.WorldModelOpen = Model( "models/jessev92/rnl/weapons/parachute_open_2017_w.mdl" ) -- (String) World model after deployment - w_*
SWEP.ParachuteModel = Model( "models/jessev92/bf2142/items/parachute.mdl" ) -- (String) Name of the parachute model while active
SWEP.GroundModel = Model( "models/props_junk/metal_paintcan001a.mdl" ) -- (String) Name of the parachute model when you land
SWEP.FireDelay = 1.5 -- (Float) Delay between pulls

SWEP.ParachuteModelOffset = Vector( 0 , 0 , 100 ) -- Used to fix the position of models

SWEP.Sounds = {

	["Freefall"] = Sound( "BF3.Equipment.Freefall.Loop" ) ,
	["Deploy"] = Sound( "BF2142.Parachute.Deploy" ) ,
	["Ride"] = Sound( "BF3.Equipment.Parachute.Ride" ) ,
	["Land"] = Sound( "BF3.Equipment.Parachute.Land" ) ,
	["Unclip"] = Sound( "Combine_Soldier.ZipLine.Clip" ) ,

}

if CLIENT then

	SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/" .. SWEP.WeaponName )
	SWEP.RenderGroup = RENDERGROUP_BOTH
	language.Add( SWEP.WeaponName , SWEP.PrintName )
	killicon.Add( SWEP.WeaponName , "vgui/entities/" .. SWEP.WeaponName , Color( 255 , 255 , 255 ) )

elseif SERVER then

	resource.AddWorkshop( SWEP.WorkshopID )

end --	Setup Clientside Info - This block must be in every weapon!

SWEP.SeqDraw = { "draw" }
SWEP.SeqHolster = { "holster" }
SWEP.SeqIdle = { "idle" }
SWEP.SeqParachuteForward = { "forward" }
SWEP.SeqParachuteLeft = { "left" }
SWEP.SeqParachuteRight = { "right" }
SWEP.SeqParachuteBack = { "back" }
