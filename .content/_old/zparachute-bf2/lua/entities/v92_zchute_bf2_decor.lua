--
-- Get the Fuck Out of this Code
-- ZParachute @ Zoey
-- BF2 Redux @ Jesse V92
--
AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "Decorative BF2 parachute"
ENT.Author = "Zoey"
ENT.Contact = "Facepunch"
ENT.Purpose = ""
ENT.Instructions = ""

if CLIENT then
	function ENT:Initialize( )
		self:SetModelScale( 1 , 1 )
	end

	--self:EnableMatrix( "RenderMultiply", (1,1,1) )
	function ENT:Think( )
		local owner = self:GetOwner( )

		if owner:IsValid( ) then
			--self:SetParent( "ValveBiped.Bip01_Spine2" )
			--self:SetAngles(self:GetOwner():GetAngles())
			--self:SetRenderAngles(self:GetOwner():GetAngles())
			--self:SetPos(self:GetOwner():GetPos() + self:GetOwner():GetUp()*1 + self:GetOwner():GetForward()*10)
			self:SetRenderOrigin( owner:GetPos( ) + owner:GetUp( ) * 5 + owner:GetForward( ) * -2 )
		end
	end

	--if self:GetOwner().Parachuting == false then self:Remove() end
	function ENT:Draw( )
		self:DrawModel( )
	end

	function ENT:IsTranslucent( )
		return true
	end
elseif SERVER then
	resource.AddWorkshop( "105699464" )
	ENT.Size = 0
	local	_IDLESND	= Sound("V92_ZP_BF2_Idle")

	function ENT:Initialize( )
		self:SetModel( "models/jessev92/bf2/parachute.mdl" )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_BBOX )
		self:DrawShadow( true )
		self:SetCollisionBounds( Vector( -self.Size , -self.Size , -self.Size ) , Vector( self.Size , self.Size , self.Size ) )
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self:SetNetworkedString( "Owner" , "World" )
		self.LoopingSound	=	CreateSound( self, _IDLESND)
		self.LoopingSound:Play()
	end

	function ENT:Think( )
		if self:GetOwner( ):IsValid( ) then
			self:SetAngles( self:GetOwner( ):GetAngles( ) )
			--self:SetRenderAngles(self:GetOwner():GetRenderAngles())
			self:SetPos( self:GetOwner( ):GetPos( ) + self:GetOwner( ):GetUp( ) * 2 + self:GetOwner( ):GetForward( ) * -4 )
		end

		--self:SetRenderOrigin(self:GetOwner():GetRenderOrigin() + self:GetOwner():GetUp()*1 + self:GetOwner():GetForward()*10)
		if self:GetOwner( ).Parachuting == false then
			self:Remove( )
		end
	end
	
	function ENT:OnRemove()
		self.LoopingSound:Stop()
	end

end