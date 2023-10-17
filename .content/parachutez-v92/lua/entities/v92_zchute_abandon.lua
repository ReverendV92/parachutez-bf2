
AddCSLuaFile( )

ENT.Type = "anim"
ENT.PrintName = "Ditched BF2 ZParachute"
ENT.Author = "Magenta/V92"

ENT.Spawnable = false
ENT.AdminOnly = true

function ENT:Initialize( )

	self:SetModel( Model( "models/v92/parachutez/abandoned.mdl" ) )
	self:SetMoveType( MOVETYPE_FLYGRAVITY )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetSkin( 1 )
	self:DrawShadow( true )
	self:SetCollisionBounds( Vector( -1 , -1 , -1 ) , Vector( 1 , 1 , 1 ) )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetNetworkedString( "Owner" , "World" )
	self:EmitSound( "VNT_ParachuteZ_DetachClip" )
	self.RemoveMe = CurTime( ) + 10
	self:SetSkin( GetConVar("vnt_parachutez_cl_style"):GetInt() )

end

function ENT:Think( )

	if not SERVER then return false end

	if self.RemoveMe < CurTime( ) then

		if SERVER then

			SafeRemoveEntity( self )

		end

	end

end
