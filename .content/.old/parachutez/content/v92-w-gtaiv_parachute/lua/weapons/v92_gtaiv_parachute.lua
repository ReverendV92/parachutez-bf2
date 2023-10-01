
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
SWEP.Base = VNT_BASE_WEAPON_PARACHUTE -- (Weapon) Base to derive from
list.Add( "VNTParachutes", SWEP ) -- Add the parachute to a list so we can auto deploy it

------------------------------------------------------
--	Client Information								--
--	Info used in the client block of the weapon		--
------------------------------------------------------

SWEP.Settings.Weapon = "v92_gtaiv_parachute" -- (String) Name of the weapon script
SWEP.WeaponEntityName = SWEP.Settings.Weapon .. "_ent" -- (String) Name of the weapon entity in Lua/Entities/Entityname.lua
SWEP.PrintName = "GTAIV" -- (String) Printed name on menu
SWEP.Category = VNT_CATEGORY_GTAIV -- (String) Category
SWEP.Instructions = VNTCB.instructions -- (String) Instruction
SWEP.Author = VNTCB.author -- (String) Author
SWEP.Contact = VNTCB.contact -- (String) Contact
SWEP.Purpose = VNTCB.purpose -- (String) Purpose
SWEP.Settings.WorkshopID = "895161301" -- (Integer) Workshop ID number of the upload that contains this file.

------------------------------------------------------
--	Model Information								--	
--	Model settings and infomation					--
------------------------------------------------------

SWEP.UseHands = true -- (Boolean) Leave at false unless the model uses C_Arms
SWEP.ViewModelFlip = false -- (Boolean) Only used for vanilla CS:S models
SWEP.ViewModel = Model( "models/weapons/c_arms.mdl" ) -- (String) View model before deployment - v_*
SWEP.WorldModel = Model( "models/jessev92/gtaiv/weapons/parachute_harness_w.mdl" ) -- (String) World model - w_*

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

SWEP.Settings.Parachute.Models.PreView = Model( "models/weapons/c_arms.mdl" ) -- (String) View model before deployment - v_*
SWEP.ViewModelOpen = Model( "models/jessev92/ffow/weapons/parachute_c.mdl" ) -- (String) View model after deployment - v_*
SWEP.WorldModelPacked = Model( "models/jessev92/gtaiv/weapons/parachute_harness_w.mdl" ) -- (String) World model before deployment - w_*
SWEP.WorldModelOpen = Model( "models/jessev92/gtaiv/weapons/parachute_harness_w.mdl" ) -- (String) World model after deployment - w_*
SWEP.Settings.Parachute.Models.Flight = Model( "models/jessev92/gtaiv/items/parachute.mdl" ) -- (String) Name of the parachute model while active
SWEP.GroundModel = Model( "models/jessev92/rnl/weapons/parachute_open_2017_w.mdl" ) -- (String) Name of the parachute model when you land
SWEP.Settings.Parachute.Delay = 1.5 -- (Float) Delay between pulls

SWEP.Sounds = {

	["Freefall"] = Sound( "RNL.Parachute.Wind.NoFlap" ) ,
	["Deploy"] = Sound( "RNL.Parachute.Deploy" ) ,
	["Ride"] = Sound( "RNL.Parachute.Wind" ) ,
	["Land"] = Sound( "BF3.Equipment.Parachute.Land" ) ,
	["Unclip"] = Sound( "Combine_Soldier.ZipLine.Clip" ) ,

}

if CLIENT then

	SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/" .. SWEP.Settings.Weapon )
	SWEP.RenderGroup = RENDERGROUP_BOTH
	language.Add( SWEP.Settings.Weapon , SWEP.PrintName )
	killicon.Add( SWEP.Settings.Weapon , "vgui/entities/" .. SWEP.Settings.Weapon , Color( 255 , 255 , 255 ) )

elseif SERVER then

	resource.AddWorkshop( SWEP.Settings.WorkshopID )

end --	Setup Clientside Info - This block must be in every weapon!

SWEP.Sequences.Draw = { "draw" }
SWEP.Sequences.Holster = { "holster" }
SWEP.Sequences.Idle = { "idle" }
SWEP.Sequences.ParachuteForward = { "forward" }
SWEP.Sequences.ParachuteLeft = { "left" }
SWEP.Sequences.ParachuteRight = { "right" }
SWEP.Sequences.ParachuteBack = { "back" }
