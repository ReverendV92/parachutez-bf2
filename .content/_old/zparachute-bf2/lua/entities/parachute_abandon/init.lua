
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Size = 0

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self:SetModel("models/parachute.mdl")
	self:SetMoveType( MOVETYPE_FLYGRAVITY )
	self:SetSolid( SOLID_BBOX )
	self:DrawShadow( true )
	self:SetGravity(-0.5)
	
	self:SetCollisionBounds(Vector(-self.Size, -self.Size, -self.Size), Vector(self.Size, self.Size, self.Size))
	
	-- Don't collide with the player
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetNetworkedString("Owner", "World")
	
	self.RemoveMe = CurTime() + 15
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
if self.RemoveMe and CurTime() >= self.RemoveMe then self:Remove() end
end

/*---------------------------------------------------------
Touch
---------------------------------------------------------*/
function ENT:Touch( ent )	
end