
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName		= "Landed ZParachute"
ENT.Author			= "Zoey/V92"
ENT.Contact			= "Lucky9Two on Steam"
ENT.Purpose			= "Saving your stupid ass"
ENT.Instructions	= "Bind a key to \"parachute\""

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

if SERVER then
	
	ENT.Size = 0

	parachuteCatchTwentyTwo = {
		"models/jessev92/bf2/parachute.mdl",
		"models/jessev92/frontlines/parachute.mdl",
		"models/jessev92/parachute_gtaiv.mdl"	
	}
	
	--	Initialize
	function ENT:Initialize()
		self:SetModel(	"models/jessev92/military/mw2_parachute_ground_skins.mdl"	)
		
		if GetConVarString( "zparachute_mdl" ) == "models/jessev92/bf2/parachute.mdl" then
			self:SetSkin( 1	)
		elseif GetConVarString( "zparachute_mdl" ) == "models/jessev92/frontlines/parachute.mdl" then
			self:SetSkin( 2	)
		elseif GetConVarString( "zparachute_mdl" ) == "models/jessev92/parachute_gtaiv.mdl" then
			self:SetSkin( 3	)		
		elseif GetConVarString( "zparachute_mdl" ) != parachuteCatchTwentyTwo then
			self:SetSkin( 0	)
		end
		self:SetMoveType( MOVETYPE_FLYGRAVITY )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( true )
		self:SetGravity(0.1)
		self:SetCollisionBounds(Vector(-self.Size, -self.Size, -self.Size), Vector(self.Size, self.Size, self.Size))
		-- Don't collide with the player
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self:SetNetworkedString("Owner", "World")
		self.RemoveMe = CurTime() + 30
	end

	--	Touch
	function ENT:Touch( ent )	end

	--	Think
	function ENT:Think()	if self.RemoveMe and CurTime() >= self.RemoveMe then self:Remove() end	end
	
	--	OnRemove
	function ENT:OnRemove()	end

	--	PhysicsUpdate
	function ENT:PhysicsUpdate()	end

	--	PhysicsCollide
	function ENT:PhysicsCollide(data,phys)	end

end