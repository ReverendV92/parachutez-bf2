--
-- Get the Fuck Out of this Code
-- ZParachute @ Zoey
-- BF2 Redux @ Jesse V92
--
AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "Abandoned BF2 parachute"
ENT.Author = "Zoey/V92"
ENT.Contact = "Facepunch"
ENT.Purpose = ""
ENT.Instructions = ""

--[[---------------------------------------------------------
OnRemove
---------------------------------------------------------]]
function ENT:OnRemove( )
end

--[[---------------------------------------------------------
PhysicsUpdate
---------------------------------------------------------]]
function ENT:PhysicsUpdate( )
end

--[[---------------------------------------------------------
PhysicsCollide
---------------------------------------------------------]]
function ENT:PhysicsCollide( data , phys )
end

if CLIENT then
	function ENT:Initialize( )
		self:SetModelScale( 1 , 1 )
	end

	--self:EnableMatrix( "RenderMultiply", (1,1,1) )
	function ENT:Draw( )
		self:DrawModel( )
	end

	function ENT:IsTranslucent( )
		return true
	end
elseif SERVER then
	resource.AddWorkshop( "105699464" )
	ENT.Size = 0

	function ENT:Initialize( )
		--self:SetModel( "models/jessev92/bf2/parachute.mdl" )
		self:SetModel( "models/jessev92/codmw2/parachute_ground_skins.mdl" )
		self:SetMoveType( MOVETYPE_FLYGRAVITY )
		--self:SetSolid( SOLID_BBOX )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetSkin( 1 )
		--self:DrawShadow( false )
		self:DrawShadow( true )
		--self:SetGravity(-0.5)
		--self:SetGravity(30.0)
		self:SetCollisionBounds( Vector( -self.Size , -self.Size , -self.Size ) , Vector( self.Size , self.Size , self.Size ) )
		-- Don't collide with the player
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self:SetNetworkedString( "Owner" , "World" )
		--self.RemoveMe = CurTime() + 15
		self.RemoveMe = CurTime( ) + 15
	end

	--	Think
	function ENT:Think( )
		if self.RemoveMe and CurTime( ) >= self.RemoveMe then
			self:Remove( )
		end
	end

	--	Touch
	function ENT:Touch( ent )
	end
end