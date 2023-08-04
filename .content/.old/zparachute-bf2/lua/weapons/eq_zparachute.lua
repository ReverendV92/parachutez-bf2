
AddCSLuaFile()

if GetConVarNumber( "VNT_Debug_Prints" ) >= 1 then	print("[V92] weapons/eq_zparachute.lua Loading...")	end

if CLIENT then

	local	_SELFENTNAME			= "eq_zparachute"
	local	_INFONAME				= "ZParachute"
	SWEP.Category			= "92nd Dev Unit"
	SWEP.PrintName			= _INFONAME
	SWEP.Author				= "V92"
	SWEP.Slot				= 92
	SWEP.SlotPos			= 92
	SWEP.DrawAmmo 			= _F
	SWEP.WepSelectIcon 		= surface.GetTextureID("vgui/hud/".. _SELFENTNAME )
	language.Add(_SELFENTNAME, _INFONAME)	
	killicon.Add( _SELFENTNAME, "vgui/entities/".. _SELFENTNAME , Color( 255, 255, 255 ) )

end

SWEP.AutoSwitchTo			= true
SWEP.AutoSwitchFrom 		= false
SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= Model("models/JesseV92/weapons/parachute_c.mdl")
SWEP.WorldModel				= Model("models/jessev92/resliber/weapons/parachute_backpack_open_w.mdl")
SWEP.UseHands				= true
SWEP.HoldType 				= "duel"	
SWEP.Spawnable				= false
SWEP.AdminOnly				= true
SWEP.Primary.Ammo 			= "none"
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip 	= -1
SWEP.Secondary.Ammo 		= "none"
SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1

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
	--return ( 0.1 * GetConVarNumber("VNT_ZParachute_Sensitivity") )
	return 0.75
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
