
AddCSLuaFile()

print("ZParachute Redux - Server File Loading...")

-- Parachute Functions 'n Shit

local zparachuteModelNum = CreateConVar( "vnt_zparachute_mdl", "models/jessev92/parachute_justcause.mdl",	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } )
local zparachuteDelay = CreateConVar( "vnt_zparachute_delay", 15,	{ FCVAR_REPLICATED, FCVAR_ARCHIVE } )

function ParachuteKey(ply, key)
	--if key == IN_JUMP and ply:IsValid() and ply:Alive() then
	if ply:IsValid() and ply:Alive() then
		if ply:GetMoveType() == MOVETYPE_NOCLIP or ply:InVehicle() or ply:OnGround() or ply.Parachuting == true or ply:GetVelocity().z > -600 then return end
		ply.EndParaTime = nil
		ply.Parachuting = true
		umsg.Start("PARAIsIn",ply)
			umsg.Bool(ply.Parachuting)
		umsg.End()
		ply.FlarePara = 1
		ply:ViewPunch(Angle(35,0,0))
		ply:EmitSound("ambient/fire/mtov_flame2.wav",100,90)		
		local ParaDec = ents.Create("zchute_redux_decor")
			ParaDec:SetOwner(ply)
			ParaDec:SetPos(ply:GetPos() + ply:GetUp()*100 + ply:GetForward()*10)
			ParaDec:SetAngles(ply:GetAngles())
			ParaDec:Spawn()
	end
end

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
				local ParaAB = ents.Create("zchute_redux_flare")
					ParaAB:SetOwner(v)
					ParaAB:SetPos(v:GetPos() + v:GetUp() + v:GetForward()*10)
					ParaAB:SetAngles(v:GetAngles())
					ParaAB:Spawn()
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
				
				local ParaAB = ents.Create("zchute_redux_land")
					ParaAB:SetOwner(v)
					ParaAB:SetPos(v:GetPos() + v:GetUp() + v:GetForward()*10)
					ParaAB:SetAngles(v:GetAngles())
					ParaAB:Spawn()
			end
			if v:KeyDown(IN_USE) and v.FlarePara > 0.4 then
				v.FlarePara = v.FlarePara - 0.005
				if v.FlarePara < 0.4 then --v.FlarePara = 0.4 end
					v.EndParaTime = nil
					v.Parachuting = false
					umsg.Start("PARAIsIn",v)
						umsg.Bool(v.Parachuting)
					umsg.End()
					v:ViewPunch(Angle(-18.5,0,0))
					v:EmitSound("npc/combine_soldier/zipline_clip2.wav")
					local ParaFlare = ents.Create("zchute_redux_flare")
						ParaFlare:SetOwner(v)
						ParaFlare:SetPos(v:GetPos() + v:GetUp() + v:GetForward()*10)
						ParaFlare:SetAngles(v:GetAngles())
						ParaFlare:Spawn()
				end
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
				v.Parachuting = false
				umsg.Start("PARAIsIn",v)
					umsg.Bool(v.Parachuting)
				umsg.End()
				v.FlarePara = 1
				v:ViewPunch(Angle(-15,0,0))
				v:EmitSound("CmbSoldier_ZipLine_Clip")
				local ParaAB = ents.Create("zchute_redux_abandon")
					ParaAB:SetOwner(v)
					ParaAB:SetPos(v:GetPos() + v:GetUp() + v:GetForward()*10)
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
			if v.EndParaTime and CurTime() >= v.EndParaTime and v:WaterLevel() > 0 then --flag
				v.EndParaTime = nil
				v.Parachuting = false
				umsg.Start("PARAIsIn",v)
					umsg.Bool(v.Parachuting)
				umsg.End()
				v.FlarePara = 1
				v:ViewPunch(Angle(-16,0,0))
				v:EmitSound()
				local ParaAB = ents.Create("zchute_redux_land")
					ParaAB:SetOwner(v)
					ParaAB:SetPos(v:GetPos() + v:GetUp() + v:GetForward()*10)
					ParaAB:SetAngles(v:GetAngles())
					ParaAB:Spawn()
			end
		end
	end
end
hook.Add("Think","ParachuteThink",ParachuteThink)

--	This only works with Zoey's CSS SWeps
--	ToDo: make a console command that lets you add weapons to it
--[[
local ZoeysCSSWeaponsHols = {
	"weapon_physgun",
	"weapon_gravitygun",
	"weapon_crowbar",
	"weapon_pistol",
	"weapon_357",
	"weapon_smg1",
	"weapon_ar2",
	"weapon_shotgun",
	"weapon_crossbow",
	"weapon_grenade",
	"weapon_rpg",
	"weapon_bugbait",
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
	"css_usp"
}

timer.Create("ParachuteHolsterCSS",0.1,0,function()
	for k,v in pairs (player.GetAll()) do
		if IsValid(v) and v:IsValid() and v:GetActiveWeapon():IsValid() and v:Alive() and v.Parachuting == true and table.HasValue(ZoeysCSSWeaponsHols,v:GetActiveWeapon():GetClass()) then
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
--]]
	
--	Tags
--	Deprecated because Garry is WONDERFUL and replaced the GOOD server browser with a shit one, GJ
--	However, the legacy browser can still use them, if your server overrides the game, so I'll leave it here.
local tags = string.Explode( ",", ( GetConVarString("sv_tags") or "" ) )
if !table.HasValue(tags, "ZParachute") then 
	table.insert(tags, "ZParachute")
	table.sort(tags)
	RunConsoleCommand("sv_tags", table.concat(tags, ","))
end

concommand.Add( "parachute", ParachuteKey )
hook.Add( "KeyPress", "ParachuteKey", ParachuteKey )
	
print("ZParachute Redux - Server File Loaded!")
