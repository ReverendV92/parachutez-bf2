
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.PrintName		= "Active ZParachute"
ENT.Author			= "Zoey/V92"
ENT.Contact			= "Lucky9Two on Steam"
ENT.Purpose			= "Saving your stupid ass"
ENT.Instructions	= "Bind a key to \"parachute\""

if SERVER then

	ENT.Size = 0
	
	--	Initialize
	function ENT:Initialize()
		self:SetModel( GetConVarString( "zparachute_mdl" )	)
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( true )
		self:SetCollisionBounds(Vector(-self.Size, -self.Size, -self.Size), Vector(self.Size, self.Size, self.Size))
		-- Don't collide with the player
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self:SetNetworkedString("Owner", "World")
	end

	--	Think
	function ENT:Think()
		if self:GetOwner():IsValid() then
			self:SetAngles(self:GetOwner():GetAngles())
			--self:SetRenderAngles(self:GetOwner():GetRenderAngles())
			self:SetPos(self:GetOwner():GetPos() + self:GetOwner():GetUp()*2 + self:GetOwner():GetForward()*-4)
			--self:SetRenderOrigin(self:GetOwner():GetRenderOrigin() + self:GetOwner():GetUp()*1 + self:GetOwner():GetForward()*10)
		end
		if self:GetOwner().Parachuting == false then self:Remove() end
	end

	--	OnRemove
	function ENT:OnRemove()	end

	--	PhysicsUpdate
	function ENT:PhysicsUpdate()	end

	--	PhysicsCollide
	function ENT:PhysicsCollide(data,phys)	end
	
end
	
if CLIENT then
	function ENT:Think()
		local owner = self:GetOwner()
		if owner:IsValid() then
			--self:SetParent( "ValveBiped.Bip01_Spine2" )
			--self:SetAngles(self:GetOwner():GetAngles())
			--self:SetRenderAngles(self:GetOwner():GetAngles())
			--self:SetPos(self:GetOwner():GetPos() + self:GetOwner():GetUp()*1 + self:GetOwner():GetForward()*10)
			self:SetRenderOrigin(owner:GetPos() + owner:GetUp()*5 + owner:GetForward()*-2)
		end
		--if self:GetOwner().Parachuting == false then self:Remove() end
	end	
	
	function ENT:Initialize()
		self:SetModelScale(1, 1)
		--self:EnableMatrix( "RenderMultiply", (1,1,1) )
	end

	--	Draw
	function ENT:Draw()		self:DrawModel()	end

	--	IsTranslucent
	function ENT:IsTranslucent()	return true	end

end
