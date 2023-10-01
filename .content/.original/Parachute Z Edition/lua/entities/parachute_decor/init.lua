
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Size = 0

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self:SetModel("models/parachute.mdl")
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_BBOX )
	self:DrawShadow( true )
	
	self:SetCollisionBounds(Vector(-self.Size, -self.Size, -self.Size), Vector(self.Size, self.Size, self.Size))
	
	-- Don't collide with the player
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetNetworkedString("Owner", "World")
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
if self:GetParent():GetNWBool("Parachute") == false then self:Remove() end
end

/*---------------------------------------------------------
Touch
---------------------------------------------------------*/
function ENT:Touch( ent )	
end