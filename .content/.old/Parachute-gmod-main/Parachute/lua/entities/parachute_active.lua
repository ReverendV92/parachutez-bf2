
AddCSLuaFile( )

ENT.Type = "anim"
ENT.PrintName = "Active Parachute"
ENT.Author = "Isemenuk27"

ENT.Spawnable = false
ENT.AdminOnly = true

function ENT:Initialize( )

	self:SetModel( "models/parashute/parachute.mdl" )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:DrawShadow( true )
	self:SetCollisionBounds( Vector( -1 , -1 , -1 ) , Vector( 1 , 1 , 1 ) )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:EmitSound( "BF2_Parachute_Deploy" )

end

local offset, noattoffset = Vector(0,0,-70), Vector(0,0,-20)

local useatt = CreateConVar("parachute_usechestatt", "0", FCVAR_ARCHIVE)

function ENT:Draw()
	local ply = self:GetOwner()
	local ang
	local pos

	local obj = ply:LookupAttachment( "chest" )

	if obj and useatt:GetBool() then
		local att = ply:GetAttachment( obj )
		pos = att.Pos + offset
		ang = att.Ang
	else
		pos = ply:GetPos() + noattoffset
		ang = ply:GetAngles()
	end

	ang[1] = 0
	ang[3] = 0

	self:SetAngles( ang )
	self:SetPos( pos )
	self:SetRenderOrigin( pos )

	self:DrawModel()
end

function ENT:Think( )
	if CLIENT then return end
	local owner = self:GetOwner()
	if !IsValid(owner) then SafeRemoveEntity( self ) return end
	self:SetPos(owner:GetPos())
	if owner.Parachuting then return end
	SafeRemoveEntity( self )
end

function ENT:OnRemove( )
	if CLIENT then return end
	SafeRemoveEntity( self )
end
