
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
	self:SetSkin( GetConVar("vnt_parachutez_cl_style"):GetInt() )

	timer.Simple( 10 , function()

		SafeRemoveEntity( self )

	end)

end

function ENT:Think( )

	return false

end
