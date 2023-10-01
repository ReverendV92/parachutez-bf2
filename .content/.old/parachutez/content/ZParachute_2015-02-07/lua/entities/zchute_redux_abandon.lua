
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName		= "Abandoned ZParachute"
ENT.Author			= "Zoey/V92"
ENT.Contact			= "Lucky9Two on Steam"
ENT.Purpose			= "Saving your stupid ass"
ENT.Instructions	= "Bind a key to \"parachute\""

if SERVER then
	
	ENT.Size = 0
	
	--	Initialize
	function ENT:Initialize()
		self:SetModel( GetConVarString( "vnt_zparachute_mdl" )	)
		self:SetMoveType( MOVETYPE_FLYGRAVITY )
		self:SetSolid( SOLID_BBOX )
		self:DrawShadow( true )
		self:SetGravity(-0.5)
		self:SetCollisionBounds(Vector(-self.Size, -self.Size, -self.Size), Vector(self.Size, self.Size, self.Size))	
		-- Don't collide with the player
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self:SetNetworkedString("Owner", "World")
		self.RemoveMe = CurTime() + 10
	end

	--	Think
	function ENT:Think()	if self.RemoveMe and CurTime() >= self.RemoveMe then self:Remove() end	end

	--	Touch
	function ENT:Touch( ent )	end

	--	Think
	function ENT:Think()
		if self.RemoveMe and CurTime() >= self.RemoveMe then self:Remove() end
	end

	--	OnRemove
	function ENT:OnRemove()	end

	--	PhysicsUpdate
	function ENT:PhysicsUpdate()	end

	--	PhysicsCollide
	function ENT:PhysicsCollide(data,phys)	end

end

if CLIENT then
	
	function ENT:Initialize()
		self:SetModelScale(1, 1)
		--self:EnableMatrix( "RenderMultiply", (1,1,1) )
	end

	--	Draw
	function ENT:Draw()		self:DrawModel()	end

	--	IsTranslucent
	function ENT:IsTranslucent()	return true	end

end
