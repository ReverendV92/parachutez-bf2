
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName		= "Abandoned ZParachute"
ENT.Author			= "Zoey/V92"
ENT.Contact			= "V92 on Steam"
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
	function ENT:Think()	
		if self.RemoveMe and CurTime() >= self.RemoveMe then self:Remove() end	
		if (GetConVarString("vnt_zparachute_mdl") == "models/jessev92/gtaiv/parachute.mdl") then
			if(GetConVar("vnt_zparachute_colourmode"):GetInt() == 0) then
				colour = Vector(255,255,255)
				self:SetSkin( 0 )
			elseif(GetConVar("vnt_zparachute_colourmode"):GetInt() == 1) then
				self:SetSkin( 1 )
				colour = Vector(self.Owner:GetWeaponColor().x * 255,self.Owner:GetWeaponColor().y * 255,self.Owner:GetWeaponColor().z * 255)
			elseif(GetConVar("vnt_zparachute_colourmode"):GetInt() == 2) then
				self:SetSkin( 1 )
				colour = Vector(self.Owner:GetPlayerColor().x * 255,self.Owner:GetPlayerColor().y * 255,self.Owner:GetPlayerColor().z * 255)
			elseif(GetConVar("vnt_zparachute_colourmode"):GetInt() >= 3) then
				self:SetSkin( 1 )
				colour = Vector(GetConVar("vnt_zparachute_colour_r"):GetInt(),GetConVar("vnt_zparachute_colour_g"):GetInt(),GetConVar("vnt_zparachute_colour_b"):GetInt())
			end
			self:SetColor( Color( colour.x, colour.y, colour.z, 255) )
		end
	end

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
