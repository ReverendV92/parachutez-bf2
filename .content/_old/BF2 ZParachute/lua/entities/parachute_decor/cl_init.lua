
/*
Get the Fuck Out of this Code

ZParachute @ Zoey
BF2 Redux @ Jesse V92
Model @ Nirrti
*/

include('shared.lua')

function ENT:Initialize()
self:SetModelScale(Vector(1,1,1))
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
