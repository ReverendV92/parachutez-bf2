
AddCSLuaFile()

if GetConVarNumber( "VNT_Debug_Prints" ) >= 1 then	print("[V92] weapons/eq_zparachute.lua Loading...")	end

local	_SELFENTNAME	= "eq_vpara_bf2"
local	_INFONAME		= "VParachute"
if CLIENT then

	SWEP.Category			= "92nd Dev Unit"
	SWEP.PrintName			= _INFONAME
	SWEP.Author				= "V92"
	SWEP.Slot				= 6
	SWEP.SlotPos			= 60
	SWEP.DrawAmmo 			= true
	SWEP.WepSelectIcon 		= surface.GetTextureID("vgui/hud/".. _SELFENTNAME )
	language.Add(_SELFENTNAME, _INFONAME)	
	killicon.Add( _SELFENTNAME, "vgui/entities/".. _SELFENTNAME , Color( 255, 255, 255 ) )

end

--SWEP.AutoSwitchTo			= true
--SWEP.AutoSwitchFrom 		= false
SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= Model("models/JesseV92/weapons/parachute_c.mdl")
SWEP.WorldModel				= Model("models/jessev92/resliber/weapons/parachute_backpack_closed_w.mdl")
SWEP.UseHands				= true
SWEP.HoldType 				= "duel"	
SWEP.Spawnable				= true
SWEP.AdminOnly				= true
SWEP.Primary.Ammo 			= "none"
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip 	= -1
SWEP.Secondary.Ammo 		= "none"
SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.IsParachuting			= false

function SWEP:Deploy()
end

function SWEP:Initialize()	
	self:SetWeaponHoldType(self.HoldType) 
end

function SWEP:DrawHUD() end
function SWEP:PrimaryAttack() end
function SWEP:CanPrimaryAttack() return false end
function SWEP:SecondaryAttack() end
function SWEP:CanSecondaryAttack() return false end
function SWEP:Reload()	end
function SWEP:Holster() 
	local	_P	=	self.Owner
	if _P.GetNWBool( "VNTParachuting" ) == false	then
		return true
	else
		return false
	end
end

function SWEP:Think()
	local	_P	=	self.Owner
	local	_VM	=	_P:GetViewModel()
	local	_ORGGRAVY	=	_P:GetGravity()
	local	_DEPLOYTIME	=	CurTime()
	if _P.GetNWBool( "VNTParachuting", false ) == false and _P:IsValid() and _P:Alive() then
		_VM:SendViewModelMatchingSequence( _VM:LookupSequence( "idleup" ) )
		if	_P:GetMoveType() == MOVETYPE_NOCLIP or	_P:InVehicle()	or	_P:OnGround() then return false end
		if _P:KeyDown( IN_RELOAD ) and !_P.GetNWBool( "VNTParachuting", false ) == true then 
			if SERVER then
				_P:SetNWBool( "VNTParachuting", true )
				_P:EmitSound("jessev92/bf3/foley/parachute/deploy_1.wav")
			end
			if CLIENT then
				_VM:SendViewModelMatchingSequence( _VM:LookupSequence( "Deploy" ) )
				_P:ViewPunch(Angle(35,0,0))
			end
			self.WorldModel	=		Model("models/jessev92/bf2/weapons/parachute_w.mdl")
		elseif _P:KeyDown( IN_RELOAD ) and _P.GetNWBool( "VNTParachuting", false ) == true then 
			return false
		end
	end

	if _P.GetNWBool( "VNTParachuting", false ) == true and _P:IsValid() and _P:Alive() then
		if CLIENT then
			if _P:KeyDown(IN_FORWARD) then
				_VM:SendViewModelMatchingSequence( _VM:LookupSequence( "Forward" ) )
			elseif _P:KeyDown(IN_BACK) then
				_VM:SendViewModelMatchingSequence( _VM:LookupSequence( "Back" ) )
			else
				_VM:SendViewModelMatchingSequence( _VM:LookupSequence( "Idle" ) )
			end
			if	_P:OnGround() then
				_P:ViewPunch(Angle(35,0,0))
			end
		end
		if SERVER then
			if _P:KeyDown(IN_USE) and _P.FlarePara > 0.4 then
				if GetConVarNumber( "VNT_Debug_Prints" ) >= 1 then	print( "ZP - User Flaring Chute" )	end
				_P.FlarePara = _P.FlarePara - 0.005
				if _P.FlarePara < 0.4 then
					_P:SetNWBool( "VNTParachuting", false )
					self:EmitSound("jessev92/bf3/foley/parachute/land_1.wav")
					_P:StripWeapon( _SELFENTNAME )
				end
			elseif not _P:KeyDown(IN_USE) and _P.FlarePara < 1 then
				_P.FlarePara = _P.FlarePara + 0.005
			end			
			if _P:KeyDown(IN_FORWARD) then
				_P:SetLocalVelocity(	_P:GetForward() * 350 * _P.FlarePara * 1.1 - _P:GetUp()*320*_P.FlarePara	)
			elseif _P:KeyDown(IN_BACK) then
				_P:SetLocalVelocity(_P:GetForward()*125*_P.FlarePara*1.1 - _P:GetUp()*175*_P.FlarePara)
			else
				_P:SetLocalVelocity(_P:GetForward()*250*_P.FlarePara*1.1 - _P:GetUp()*300*_P.FlarePara)
			end
			if	_P:OnGround() or _P:WaterLevel() > 0 then
				_P:SetNWBool( "VNTParachuting", false )
				_P:StripWeapon( _SELFENTNAME )
				_P:ConCommand("lastinv")
			end
		end
		
	end
end
