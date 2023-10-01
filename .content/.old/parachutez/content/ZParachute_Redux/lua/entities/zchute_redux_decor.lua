
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.PrintName		= "Active ZParachute"
ENT.Author			= "Zoey/V92"
ENT.Contact			= "V92 on Steam"
ENT.Purpose			= "Saving your stupid ass"
ENT.Instructions	= "Bind a key to \"parachute\""

if SERVER then

	ENT.Size = 0
	
	local	_IDLESND	= Sound("V92_ZP_BF2_Idle")
	--	Initialize
	function ENT:Initialize()
		self:SetModel( GetConVarString( "vnt_zparachute_mdl" ) )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( true )
		self:SetCollisionBounds(Vector(-self.Size, -self.Size, -self.Size), Vector(self.Size, self.Size, self.Size))
		-- Don't collide with the player
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self:SetNetworkedString("Owner", "World") 
		--self:EmitSound("V92_ZPWep_Deploy") 
		if (GetConVarString("vnt_zparachute_mdl") == "models/jessev92/bf2142/parachute.mdl") then
			self:EmitSound( Sound("V92_ZP_BF2142_Deploy") )
		else
			self:EmitSound( Sound("V92_ZP_BF2_Deploy") )
		end	
		self.LoopingSound	=	CreateSound( self, _IDLESND)
		self.LoopingSound:Play()
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
	function ENT:OnRemove()
		self.LoopingSound:Stop()
	end

	--	PhysicsUpdate
	function ENT:PhysicsUpdate() end

	--	PhysicsCollide
	function ENT:PhysicsCollide(data,phys) end
	
elseif CLIENT then

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
	function ENT:Draw() 	
		self:DrawModel() 
	end

	--	IsTranslucent
	--function ENT:IsTranslucent() return true	end

end
