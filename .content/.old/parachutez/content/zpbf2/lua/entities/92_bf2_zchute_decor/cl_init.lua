
/*
Get the Fuck Out of this Code

ZParachute @ Zoey
BF2 Redux @ Jesse V92
Model @ Nirrti
*/

include('shared.lua')

function ENT:Initialize()
self:SetModelScale(1, 1)
--self:EnableMatrix( "RenderMultiply", (1,1,1) )
end

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

/*---------------------------------------------------------
Draw
---------------------------------------------------------*/
function ENT:Draw()
	self:DrawModel()
end


/*---------------------------------------------------------
IsTranslucent
---------------------------------------------------------*/
function ENT:IsTranslucent()
	return true
end
