
AddCSLuaFile( )

ENT.Type = "anim"
ENT.PrintName = "Ditched Parachute"
ENT.Author = "Isemenuk27"

ENT.Spawnable = false
ENT.AdminOnly = true
--ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize( )

	self:SetModel( "models/parashute/parachute_ground.mdl" )
	self:SetMoveType( MOVETYPE_FLYGRAVITY )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( true )
	self:SetCollisionBounds( Vector( -1 , -1 , -1 ) , Vector( 1 , 1 , 1 ) )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetNetworkedString( "Owner" , "World" )
	self:EmitSound( "BF2_Parachute_DetachClip" )
	self.FadeMe = CurTime() + 7
	self.RemoveMe = CurTime() + 10
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	self.Color = Color(255, 255, 255, 255)
end

function ENT:Think()
	if CLIENT then return false end

	if self.RemoveMe < CurTime() then
		SafeRemoveEntity( self )
	end
end

function ENT:Draw()
	if self.FadeMe < CurTime() then
		self.Color.a = math.Remap( CurTime() - self.FadeMe, 0, self.RemoveMe - self.FadeMe, 255, 0) 
		self:SetColor(self.Color)
	end
	self:DrawModel()
end