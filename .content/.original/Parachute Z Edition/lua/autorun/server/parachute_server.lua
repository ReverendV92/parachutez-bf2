function DoParachute(ply)
if ply:GetMoveType() == MOVETYPE_NOCLIP then return end
if ply:InVehicle() then return end
if ply:OnGround() then return end
if ply:GetNWBool("Parachute") then return end
if ply:GetVelocity():Length() < 750 then return end
ply.EndParaTime = nil
ply.WindTimer = CurTime() + 1
ply:SetNWInt("FlarePara",1)
ply:ViewPunch(Angle(35,0,0))
ply:SetNWBool("Parachute",true)
ply:EmitSound("ambient/fire/mtov_flame2.wav",100,90)
local Para = ents.Create("parachute_decor")
Para:SetOwner(ply)
Para:SetPos(ply:GetPos() + ply:GetUp()*115 + ply:GetForward()*10)
Para:SetAngles(ply:GetAngles())
Para:SetParent(ply)
Para:Spawn()
end
concommand.Add("parachutedo",DoParachute)

function ParachuteKey()
for k,v in pairs (player.GetAll()) do
if !v:GetNWBool("Parachute") and v:GetVelocity():Length() > 1100 and v.WindTimer and CurTime() >= v.WindTimer then
if v:GetMoveType() == MOVETYPE_NOCLIP then return end
if v:InVehicle() then return end
v.WindTimer = CurTime() + 8
v:ConCommand("play ambient/wind/windgust_strong.wav")
end
if v:GetNWBool("Parachute") then
if v.EndParaTime and CurTime() >= v.EndParaTime then
v.EndParaTime = nil
v.WindTimer = CurTime() + 1
v:SetNWBool("Parachute",false)
v:SetNWInt("FlarePara",1)
v:ViewPunch(Angle(-13,0,0))
v:EmitSound("npc/combine_soldier/zipline_clip1.wav")
local ParaAB = ents.Create("parachute_abandon")
ParaAB:SetOwner(v)
ParaAB:SetPos(v:GetPos() + v:GetUp()*115 + v:GetForward()*10)
ParaAB:SetAngles(v:GetAngles())
ParaAB:Spawn()
end
if v:KeyDown(IN_USE) then
v:SetNWInt("FlarePara", v:GetNWInt("FlarePara") - 0.005)
if v:GetNWInt("FlarePara") < 0.4 then v:SetNWInt("FlarePara",0.4) end
end
if v:KeyDown(IN_FORWARD) then
v:SetLocalVelocity(v:GetForward()*195*v:GetNWInt("FlarePara") - v:GetUp()*325*v:GetNWInt("FlarePara"))
elseif v:KeyDown(IN_MOVELEFT) then
v:SetLocalVelocity(v:GetRight()*-190*v:GetNWInt("FlarePara") - v:GetUp()*325*v:GetNWInt("FlarePara"))
elseif v:KeyDown(IN_MOVERIGHT) then
v:SetLocalVelocity(v:GetRight()*190*v:GetNWInt("FlarePara") - v:GetUp()*325*v:GetNWInt("FlarePara"))
elseif v:KeyDown(IN_BACK) then
v:SetLocalVelocity(v:GetForward()*-195*v:GetNWInt("FlarePara") - v:GetUp()*325*v:GetNWInt("FlarePara"))
else
v:SetLocalVelocity(v:GetUp()*-325*v:GetNWInt("FlarePara"))
end
end
if v:KeyDown(IN_DUCK) and v:KeyDown(IN_WALK) and v:GetNWBool("Parachute") then
v:SetNWBool("Parachute",false)
v:SetNWInt("FlarePara",1)
v:ViewPunch(Angle(-13,0,0))
v:EmitSound("npc/combine_soldier/zipline_clip1.wav")
local ParaAB = ents.Create("parachute_abandon")
ParaAB:SetOwner(v)
ParaAB:SetPos(v:GetPos() + v:GetUp()*115 + v:GetForward()*10)
ParaAB:SetAngles(v:GetAngles())
ParaAB:Spawn()
end
if v:OnGround() and v:GetNWBool("Parachute") then
if v.EndParaTime then return end
v.EndParaTime = CurTime() + 1
end
if v:KeyReleased(IN_JUMP) then
v:ConCommand("parachutedo")
end
end
end
hook.Add("Think","ParachuteKey",ParachuteKey)