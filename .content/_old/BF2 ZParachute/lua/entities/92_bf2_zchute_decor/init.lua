
/*
Get the Fuck Out of this Code

ZParachute @ Zoey
BF2 Redux @ Jesse V92
Model @ Nirrti
*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Size = 0

function ENT:Initialize()

	self:SetModel("models/jessev92/bf2/parachute.mdl")
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_BBOX )
	self:DrawShadow( true )
	
	self:SetCollisionBounds(Vector(-self.Size, -self.Size, -self.Size), Vector(self.Size, self.Size, self.Size))
	
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetNetworkedString("Owner", "World")
end

function ENT:Think()
if self:GetOwner():IsValid() then
self:SetAngles(self:GetOwner():GetAngles())
//self:SetPos(self:GetOwner():GetPos() + self:GetOwner():GetUp()*100 + self:GetOwner():GetForward()*10)
self:SetPos(self:GetOwner():GetPos() + self:GetOwner():GetUp()*1 + self:GetOwner():GetForward()*10)
end
if self:GetOwner().Parachuting == false then self:Remove() end
end