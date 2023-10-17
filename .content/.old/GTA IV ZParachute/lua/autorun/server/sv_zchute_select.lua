function ParachuteKey(ply, key)
	if key == IN_JUMP and ply:IsValid() and ply:Alive() then
	if ply:GetMoveType() == MOVETYPE_NOCLIP or ply:InVehicle() or ply:OnGround() or ply.Parachuting == true or ply:GetVelocity().z > -600 then return end
	ply.EndParaTime = nil
	ply.Parachuting = true
	umsg.Start("PARAIsIn",ply)
	umsg.Bool(ply.Parachuting)
	umsg.End()
	ply.FlarePara = 1
	ply:ViewPunch(Angle(35,0,0))
	ply:EmitSound("ambient/fire/mtov_flame2.wav",100,90)
	local Para = ents.Create("chute-gta1_dec")
	Para:SetOwner(ply)
	Para:SetPos(ply:GetPos() + ply:GetUp()*100 + ply:GetForward()*10)
	Para:SetAngles(ply:GetAngles())
	Para:Spawn()
	end
end
hook.Add( "KeyPress", "ParachuteKey", ParachuteKey )

function ParachuteThink()
for k,v in pairs (player.GetAll()) do
if v.Parachuting == true then
if not v:Alive() then
v.EndParaTime = nil
v.Parachuting = false
umsg.Start("PARAIsIn",v)
umsg.Bool(v.Parachuting)
umsg.End()
v.FlarePara = 1
v:ViewPunch(Angle(-18.5,0,0))
v:EmitSound("npc/combine_soldier/zipline_clip2.wav")
local ParaAB = ents.Create("chute-gta1_bndn")
ParaAB:SetOwner(v)
ParaAB:SetPos(v:GetPos() + v:GetUp()*100 + v:GetForward()*10)
ParaAB:SetAngles(v:GetAngles())
ParaAB:Spawn()
end
if v.EndParaTime and CurTime() >= v.EndParaTime and v:OnGround() then
v.EndParaTime = nil
v.Parachuting = false
umsg.Start("PARAIsIn",v)
umsg.Bool(v.Parachuting)
umsg.End()
v.FlarePara = 1
v:ViewPunch(Angle(-16,0,0))
v:EmitSound("npc/combine_soldier/zipline_clip2.wav")
local ParaAB = ents.Create("chute-gta1_bndn")
ParaAB:SetOwner(v)
ParaAB:SetPos(v:GetPos() + v:GetUp()*115 + v:GetForward()*10)
ParaAB:SetAngles(v:GetAngles())
ParaAB:Spawn()
end
if v:KeyDown(IN_USE) and v.FlarePara > 0.4 then
v.FlarePara = v.FlarePara - 0.005
if v.FlarePara < 0.4 then v.FlarePara = 0.4 end
end
if v:KeyDown(IN_FORWARD) then
v:SetLocalVelocity(v:GetForward()*240*v.FlarePara*1.1 - v:GetUp()*320*v.FlarePara)
elseif v:KeyDown(IN_MOVELEFT) then
v:SetLocalVelocity(v:GetRight()*-215*v.FlarePara*1.1 - v:GetUp()*320*v.FlarePara)
elseif v:KeyDown(IN_MOVERIGHT) then
v:SetLocalVelocity(v:GetRight()*215*v.FlarePara*1.1 - v:GetUp()*320*v.FlarePara)
elseif v:KeyDown(IN_BACK) then
v:SetLocalVelocity(v:GetForward()*-240*v.FlarePara*1.1 - v:GetUp()*320*v.FlarePara)
else
v:SetLocalVelocity(v:GetUp()*-320*v.FlarePara)
end
if v:KeyDown(IN_DUCK) and v:KeyDown(IN_WALK) and v.Parachuting == true then
v.Parachuting = false
umsg.Start("PARAIsIn",v)
umsg.Bool(v.Parachuting)
umsg.End()
v.FlarePara = 1
v:ViewPunch(Angle(-25,0,0))
v:EmitSound("npc/combine_soldier/zipline_clip2.wav")
local ParaAB = ents.Create("chute-gta1_bndn")
ParaAB:SetOwner(v)
ParaAB:SetPos(v:GetPos() + v:GetUp()*75 + v:GetForward()*10)
ParaAB:SetAngles(v:GetAngles())
ParaAB:Spawn()
end
if v:OnGround() and v.Parachuting == true and not v.EndParaTime then
v.EndParaTime = CurTime() + 1
umsg.Start("PARAIsIn",v)
umsg.Bool(false)
umsg.End()
v:ViewPunch(Angle(7,0,0))
end
end
end
end
hook.Add("Think","ParachuteThink",ParachuteThink)
