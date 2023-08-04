function ParachuteShake(UCMD)
if LocalPlayer().Parachuting == true then
UCMD:SetViewAngles((UCMD:GetViewAngles() + Angle(math.sin(RealTime()*35) * 0.01, math.sin(RealTime()*35) * 0.01, 0)))
end
end
hook.Add("CreateMove", "ParachuteShake", ParachuteShake)

local function PARAIsIn( um )
LocalPlayer().Parachuting = um:ReadBool()
end
usermessage.Hook( "PARAIsIn", PARAIsIn )