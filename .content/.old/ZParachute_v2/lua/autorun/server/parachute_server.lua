
sound.Add( {
	name 		= "CmbSoldier_ZipLine_Clip",
	channel 	= CHAN_AUTO,
	volume		= 1.0,
	level		= 50,
	pitchstart	= 90,
	pitchend	= 110,
	sound		= { "npc/combine_soldier/zipline_clip1.wav", "npc/combine_soldier/zipline_clip2.wav"}
} )
util.PrecacheSound("npc/combine_soldier/zipline_clip1.wav")
util.PrecacheSound("npc/combine_soldier/zipline_clip2.wav")

CreateConVar( "zparachute_mdl",					"models/jessev92/bf2/parachute.mdl",							{ FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY } )

 -- Parachute Functions 'n Shit

function ParachuteKey(ply, key)
	--if key == IN_JUMP and ply:IsValid() and ply:Alive() then
		if ply:GetMoveType() == MOVETYPE_NOCLIP or ply:InVehicle() or ply:OnGround() or ply.Parachuting == true or ply:GetVelocity().z > -600 then return end
		ply.EndParaTime = nil
		ply.Parachuting = true
		umsg.Start("PARAIsIn",ply)
			umsg.Bool(ply.Parachuting)
		umsg.End()
		ply.FlarePara = 1
		ply:ViewPunch(Angle(35,0,0))
		ply:EmitSound("ambient/fire/mtov_flame2.wav",100,90)		
		/*local*/ Para = ents.Create("zchute_decor_redux")
			Para:SetOwner(ply)
			Para:SetPos(ply:GetPos() + ply:GetUp()*100 + ply:GetForward()*10)
			Para:SetAngles(ply:GetAngles())
			Para:Spawn()
	--end
end
concommand.Add( "parachute", ParachuteKey )
--hook.Add( "KeyPress", "ParachuteKey", ParachuteKey )

/*
function Abandon()
	for k,v in pairs (player.GetAll()) do
		if v.Parachuting == false then
			return false
		else
			--print("abandon func")
			--Para:SetOwner( Para )
			Para:SetOwner(v)
			Para:SetRenderOrigin(Para:GetPos() + Para:GetUp()*5 + Para:GetForward()*-2)
			Para:SetAngles(v:GetAngles())
			Para:SetGravity(-0.5)
			Para.RemoveMe = CurTime() + 10
		end
	end
end
*/

function ParachuteThink()
	for k,v in pairs (player.GetAll()) do
		if v.Parachuting == true then
			if not v:Alive() then
				--print( "ded" )
				v.EndParaTime = nil
				v.Parachuting = false
				umsg.Start("PARAIsIn",v)
					umsg.Bool(v.Parachuting)
				umsg.End()
				v.FlarePara = 1
				v:ViewPunch(Angle(-18.5,0,0))
				v:EmitSound("npc/combine_soldier/zipline_clip2.wav")
				local ParaAB = ents.Create("zchute_abandon_redux")
					ParaAB:SetOwner(v)
					ParaAB:SetPos(v:GetPos() + v:GetUp() + v:GetForward()*10)
					ParaAB:SetAngles(v:GetAngles())
					ParaAB:Spawn()
				--Abandon()
			end
			if v.EndParaTime and CurTime() >= v.EndParaTime and v:OnGround() then --flag
				--print( "landed" )
				v.EndParaTime = nil
				v.Parachuting = false
				umsg.Start("PARAIsIn",v)
					umsg.Bool(v.Parachuting)
				umsg.End()
				v.FlarePara = 1
				v:ViewPunch(Angle(-16,0,0))
				v:EmitSound("CmbSoldier_ZipLine_Clip")
				local ParaAB = ents.Create("zchute_land_redux")
					ParaAB:SetOwner(v)
					ParaAB:SetPos(v:GetPos() + v:GetUp() + v:GetForward()*10)
					ParaAB:SetAngles(v:GetAngles())
					ParaAB:Spawn()
			end
			if v:KeyDown(IN_USE) and v.FlarePara > 0.4 then
				v.FlarePara = v.FlarePara - 0.005
				if v.FlarePara < 0.4 then v.FlarePara = 0.4 end
			end
			//if v:KeyDown(IN_FORWARD) then
				//v:SetLocalVelocity(v:GetForward()*240*v.FlarePara*1.1 - v:GetUp()*320*v.FlarePara)
			//elseif v:KeyDown(IN_MOVELEFT) then
				//v:SetLocalVelocity(v:GetRight()*-215*v.FlarePara*1.1 - v:GetUp()*320*v.FlarePara)
			//elseif v:KeyDown(IN_MOVERIGHT) then
				//v:SetLocalVelocity(v:GetRight()*215*v.FlarePara*1.1 - v:GetUp()*320*v.FlarePara)
			//elseif v:KeyDown(IN_BACK) then
				//v:SetLocalVelocity(v:GetForward()*-240*v.FlarePara*1.1 - v:GetUp()*320*v.FlarePara)
			if v:KeyDown(IN_FORWARD) then
				v:SetLocalVelocity(v:GetForward()*450*v.FlarePara*1.1 - v:GetUp()*320*v.FlarePara)
			elseif v:KeyDown(IN_BACK) then
				v:SetLocalVelocity(v:GetForward()*300*v.FlarePara*1.1 - v:GetUp()*320*v.FlarePara)
			else
				//v:SetLocalVelocity(v:GetUp()*-320*v.FlarePara)
				v:SetLocalVelocity(v:GetForward()*375*v.FlarePara*1.1 - v:GetUp()*320*v.FlarePara)
			end
			if v:KeyDown(IN_DUCK) and v:KeyDown(IN_WALK) and v.Parachuting == true then
				--print( "abandon" )
				v.Parachuting = false
				umsg.Start("PARAIsIn",v)
					umsg.Bool(v.Parachuting)
				umsg.End()
				v.FlarePara = 1
				v:ViewPunch(Angle(-15,0,0))
				v:EmitSound("CmbSoldier_ZipLine_Clip")
				local ParaAB = ents.Create("zchute_abandon_redux")
					ParaAB:SetOwner(v)
					ParaAB:SetPos(v:GetPos() + v:GetUp() + v:GetForward()*10)
					ParaAB:SetAngles(v:GetAngles())
					ParaAB:Spawn()
				--Abandon()
			end
			if v:OnGround() and v.Parachuting == true and not v.EndParaTime then
				v.EndParaTime = CurTime() + 1
				umsg.Start("PARAIsIn",v)
					umsg.Bool(false)
				umsg.End()
				v:ViewPunch(Angle(7,0,0))
			end
			if v.EndParaTime and CurTime() >= v.EndParaTime and v:WaterLevel() > 0 then --flag
				v.EndParaTime = nil
				v.Parachuting = false
				umsg.Start("PARAIsIn",v)
					umsg.Bool(v.Parachuting)
				umsg.End()
				v.FlarePara = 1
				v:ViewPunch(Angle(-16,0,0))
				v:EmitSound()
				local ParaAB = ents.Create("zchute_land_redux")
					ParaAB:SetOwner(v)
					ParaAB:SetPos(v:GetPos() + v:GetUp() + v:GetForward()*10)
					ParaAB:SetAngles(v:GetAngles())
					ParaAB:Spawn()
			end
		end
	end
end
hook.Add("Think","ParachuteThink",ParachuteThink)

--[[
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
if v:GetActiveWeapon().S--printDelay and CurTime() >= v:GetActiveWeapon().S--printDelay then
if v:GetActiveWeapon().IsS--printing == false and v.FlarePara > 0.75 and not v:OnGround() then
v:GetActiveWeapon():S--printing(true)
elseif v:GetActiveWeapon().IsS--printing == true and v.FlarePara <= 0.5 then
v:GetActiveWeapon():S--printing(false)
if not v:GetActiveWeapon().SniperRifle then
v:GetActiveWeapon():SetNextPrimaryFire(CurTime() + 0.3)
end
end
end
end
end
end)
]]

--	Tags
--	Deprecated because Garry is WONDERFUL and replaced the GOOD server browser with a shit one, GJ
/*
local tags = string.Explode( ",", ( GetConVarString("sv_tags") or "" ) )
if !table.HasValue(tags, "ZParachute") then 
	table.insert(tags, "ZParachute")
	table.sort(tags)
	RunConsoleCommand("sv_tags", table.concat(tags, ","))
end
*/