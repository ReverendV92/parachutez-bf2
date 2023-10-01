
------------------------------------------------------
if not VNTCB then return false end --	Prevent this file from loading if for some odd reason the base Lua isn't loaded
------------------------------------------------------

AddCSLuaFile()

ENT.PrintName = "Parachute"

if not VNTCB then
	Error( "V92 Content Bases not mounted; Removing Entity:\n" .. ENT.PrintName )
	return false
end

ENT.Base = VNT_BASE_WEAPON_ENTITY
ENT.Type = "anim"
ENT.Author = VNTCB.author
ENT.Information = "Uses a Parachute"
ENT.Category = VNT_CATEGORY_RNL
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.SWepName = "v92_rnl_parachute" -- (String) Name of the weapon entity in Lua/weapons/swep_name.lua
ENT.WeaponName = ENT.SWepName .. "_ent"	-- (String) Name of this entity
ENT.SEntModel = Model( "models/jessev92/rnl/weapons/parachute_closed_2017_w.mdl" ) -- (String) Model to use
