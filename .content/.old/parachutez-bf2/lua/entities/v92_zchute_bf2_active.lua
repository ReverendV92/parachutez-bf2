
AddCSLuaFile( )

ENT.Type = "anim"
ENT.PrintName = "Active BF2 ZParachute"
ENT.Author = "Magenta/V92"

ENT.Spawnable = false
ENT.AdminOnly = true

function ENT:Initialize( )

	self:SetModel( Model( "models/jessev92/bf2/parachute.mdl" ) )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_BBOX )
	self:DrawShadow( true )
	self:SetCollisionBounds( Vector( -1 , -1 , -1 ) , Vector( 1 , 1 , 1 ) )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetNetworkedString( "Owner" , "World" )
	self:EmitSound( "VNT_ParachuteZ_BF2_Deploy" )

end

function ENT:Think( )

	local owner = self:GetOwner( )

	if owner:IsValid( ) then

		if CLIENT then

			self:SetRenderOrigin( owner:GetPos( ) + owner:GetUp( ) * 5 + owner:GetForward( ) * -2 )

		end

		if SERVER then

			self:SetAngles( self:GetOwner( ):GetAngles( ) )
			self:SetPos( self:GetOwner( ):GetPos( ) + self:GetOwner( ):GetUp( ) * 2 + self:GetOwner( ):GetForward( ) * -4 )

		end

	end

	if owner.Parachuting == false then

		if SERVER and IsValid( self ) then

			SafeRemoveEntity( self )

		end

	end

end

function ENT:OnRemove( )

	if SERVER and IsValid( self ) then

		SafeRemoveEntity( self )

	end

end
