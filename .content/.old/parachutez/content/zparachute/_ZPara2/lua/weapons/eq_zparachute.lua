
AddCSLuaFile()

if GetConVarNumber( "vnt_debug_prints" ) >= 1 then	print("[V92] weapons/eq_zparachute.lua Loading...")	end

resource.AddFile( "models/jessev92/weapons/parachute_c.mdl" )

--	Info/Client Stuff
local	_SELFENTNAME			= "eq_zparachute"
local	_INFONAME				= "ZParachute"
local	_T						= true
local	_F						= false

if CLIENT then

	SWEP.Category			= "92nd Development Unit"
	SWEP.PrintName			= _INFONAME
	SWEP.Author				= "V92"
	SWEP.Slot				= 92
	SWEP.SlotPos			= 92
	SWEP.DrawAmmo 			= _F
	SWEP.WepSelectIcon 		= surface.GetTextureID("vgui/hud/".. _SELFENTNAME )
	language.Add(_SELFENTNAME, _INFONAME)	
	killicon.Add( _SELFENTNAME, "vgui/entities/".. _SELFENTNAME , Color( 255, 255, 255 ) )

end

SWEP.AutoSwitchTo			= _T
SWEP.AutoSwitchFrom 		= _F
SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= _F
SWEP.ViewModel				= "models/JesseV92/weapons/parachute_c.mdl"
SWEP.WorldModel				= ""
SWEP.UseHands				= _T
SWEP.HoldType 				= "duel"	
SWEP.Spawnable				= _F
SWEP.AdminSpawnable			= _F
SWEP.AdminOnly				= _T
SWEP.Primary.Ammo 			= "none"
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip 	= -1

function SWEP:Initialize()	self:SetWeaponHoldType(self.HoldType) end
function SWEP:DrawHUD() end
function SWEP:PrimaryAttack() end
function SWEP:CanPrimaryAttack() return false end
function SWEP:SecondaryAttack() end
function SWEP:CanSecondaryAttack() return false end
function SWEP:Reload() end

function SWEP:Deploy() 
	local _VM = self.Owner:GetViewModel()
	_VM:SendViewModelMatchingSequence( _VM:LookupSequence( "Deploy" ) )
end

function SWEP:Holster() 
	self.Owner:ConCommand("lastinv")
	local _VM = self.Owner:GetViewModel()
	_VM:SendViewModelMatchingSequence( _VM:LookupSequence( "idle" ) )
end

function SWEP:AdjustMouseSensitivity()
	return 0.1
end

function SWEP:Think()

	local _P = self.Owner
	local _VM = self.Owner:GetViewModel()
	
	if _P:KeyDown( IN_BACK ) then
		_VM:SendViewModelMatchingSequence( _VM:LookupSequence( "Back" ) )
	elseif _P:KeyDown( IN_FORWARD ) then
		_VM:SendViewModelMatchingSequence( _VM:LookupSequence( "Forward" ) )
	elseif _P:KeyDown(IN_MOVERIGHT) or	_P:KeyDown(IN_RIGHT) then
		_VM:SendViewModelMatchingSequence( _VM:LookupSequence( "Right" ) )
	elseif _P:KeyDown(IN_MOVELEFT) or	_P:KeyDown(IN_LEFT) then
		_VM:SendViewModelMatchingSequence( _VM:LookupSequence( "Left" ) )
	else
		_VM:SendViewModelMatchingSequence( _VM:LookupSequence( "idle" ) )
	end
	
end

function SWEP:OnDrop() 
	if IsValid( self ) then 
		self:Remove() 
	end
end
