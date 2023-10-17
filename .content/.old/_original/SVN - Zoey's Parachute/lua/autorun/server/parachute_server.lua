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
	local Para = ents.Create("parachute_decor")
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
v:EmitSound("npc/combine_soldier/zipline_clip1.wav")
local ParaAB = ents.Create("parachute_abandon")
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
v:EmitSound("npc/combine_soldier/zipline_clip1.wav")
local ParaAB = ents.Create("parachute_abandon")
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
v:ViewPunch(Angle(-15,0,0))
v:EmitSound("npc/combine_soldier/zipline_clip1.wav")
local ParaAB = ents.Create("parachute_abandon")
ParaAB:SetOwner(v)
ParaAB:SetPos(v:GetPos() + v:GetUp()*115 + v:GetForward()*10)
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

local ZoeysCSSWeaponsHols = {
"css_ak47",
"css_aug",
"css_awp",
"css_deserteagle",
"css_elites",
"css_famas",
"css_fiveseven",
"css_g3sg1",
"css_galil",
"css_glock",
"css_m3",
"css_m4a1",
"css_m249",
"css_m1014",
"css_mac10",
"css_mp5",
"css_p90",
"css_p228",
"css_scout",
"css_sg550",
"css_sg552",
"css_tmp",
"css_ump",
"css_usp"}

timer.Create("ParachuteHolsterCSS",0.1,0,function()
for k,v in pairs (player.GetAll()) do
if ValidEntity(v) and v:IsValid() and v:GetActiveWeapon():IsValid() and v:Alive() and v.Parachuting == true and table.HasValue(ZoeysCSSWeaponsHols,v:GetActiveWeapon():GetClass()) then
if v:GetActiveWeapon().SprintDelay and CurTime() >= v:GetActiveWeapon().SprintDelay then
if v:GetActiveWeapon().IsSprinting == false and v.FlarePara > 0.75 and not v:OnGround() then
v:GetActiveWeapon():Sprinting(true)
elseif v:GetActiveWeapon().IsSprinting == true and v.FlarePara <= 0.5 then
v:GetActiveWeapon():Sprinting(false)
if not v:GetActiveWeapon().SniperRifle then
v:GetActiveWeapon():SetNextPrimaryFire(CurTime() + 0.3)
end
end
end
end
end
end)