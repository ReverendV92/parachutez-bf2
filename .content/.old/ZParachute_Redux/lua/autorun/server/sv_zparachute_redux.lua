
AddCSLuaFile()

-------------------------------------------------------
-------------------------------------------------------
--	ZParachute by Zoey
--	Overhaul by V92 with permission from Z
--	Profile Link:	http://steamcommunity.com/id/JesseVanover/
--	Workshop Link:	http://steamcommunity.com/sharedfiles/filedetails/?id=484061347
-------------------------------------------------------
-------------------------------------------------------

if GetConVarNumber( "VNT_Debug_Prints" ) != 0 then	print("[V92] server/sv_ZParachuteRedux.lua Loading...") end

-- Parachute Functions 'n Shit
function ParachuteKey(_P, _K)

	--if ConVarExists( "VNT_ZParachute_jumpdeploy" ) and GetConVarNumber( "VNT_ZParachute_jumpdeploy" ) != 0 then	
		--print("[V92] ZParachute - Press Jump to Deploy!")
		if _K == IN_SPEED and _P:IsValid() and _P:Alive() then
			if _P:GetMoveType() == MOVETYPE_NOCLIP or _P:InVehicle() or _P:OnGround() or _P.Parachuting == true or _P:GetVelocity().z > -600 then return end
			if GetConVarNumber("VNT_ZParachute_AllowWeapons") != 1 then
				_P:Give( "eq_zparachute" )
				_P:SelectWeapon( "eq_zparachute" )
			end
			_P.EndParaTime = nil
			_P.Parachuting = true
			umsg.Start("PARAIsIn",_P)
				umsg.Bool(_P.Parachuting)
			umsg.End()
			_P.FlarePara = 1
			_P:ViewPunch(Angle(35,0,0))
			_P:EmitSound("V92_ZPWep_Deploy") 	
			local ParaDec = ents.Create("zchute_redux_decor")
				ParaDec:SetOwner(_P)
				ParaDec:SetPos(_P:GetPos() + _P:GetUp()*100 + _P:GetForward()*10)
				ParaDec:SetAngles(_P:GetAngles())
				ParaDec:Spawn()
		end
	--end
end
hook.Add( "KeyPress", "ParachuteKey", ParachuteKey )
--concommand.Add( "parachute", ParachuteKey )
--end
--[[
hook.Add( "KeyPress", "ParachuteKey", ParachuteKey )
if ConVarExists( "VNT_ZParachute_jumpdeploy" ) and GetConVarNumber( "VNT_ZParachute_jumpdeploy" ) == 0 then	
	function ParachuteKey(_P, _K)
		if _P:IsValid() and _P:Alive() then
			if _P:GetMoveType() == MOVETYPE_NOCLIP or _P:InVehicle() or _P:OnGround() or _P.Parachuting == true or _P:GetVelocity().z > -600 then return end
			_P:Give( "eq_zparachute" )
			_P:SelectWeapon( "eq_zparachute" )
			_P.EndParaTime = nil
			_P.Parachuting = true
			umsg.Start("PARAIsIn",_P)
				umsg.Bool(_P.Parachuting)
			umsg.End()
			_P.FlarePara = 1
			_P:ViewPunch(Angle(35,0,0))
			_P:EmitSound("V92_ZPWep_Deploy") 	
			local ParaDec = ents.Create("zchute_redux_decor")
				ParaDec:SetOwner(_P)
				ParaDec:SetPos(_P:GetPos() + _P:GetUp()*100 + _P:GetForward()*10)
				ParaDec:SetAngles(_P:GetAngles())
				ParaDec:Spawn()
		end
		if GetConVarNumber( "VNT_Debug_Prints" ) >= 1 then	print( "ZP - Deployed" ) end
	end
end
concommand.Add( "parachute", ParachuteKey )
--]]
function ParachuteThink()
	for k,_P in pairs (player.GetAll()) do
		if _P.Parachuting == true then
			if not _P:Alive() then
				if GetConVarNumber( "VNT_Debug_Prints" ) >= 1 then	print( "ZP - User Died" ) end
				_P.EndParaTime = nil
				_P.Parachuting = false
				umsg.Start("PARAIsIn",_P)
					umsg.Bool(_P.Parachuting)
				umsg.End()
				_P.FlarePara = 1
				_P:ViewPunch(Angle(-18.5,0,0))
				_P:EmitSound("CmbSoldier_ZipLine_Clip")
				if GetConVarNumber("VNT_ZParachute_AllowWeapons") != 1 then
					_P:StripWeapon( "eq_zparachute" )
				end
				local ParaAB = ents.Create("zchute_redux_flare")
					ParaAB:SetOwner(_P)
					ParaAB:SetPos(_P:GetPos() + _P:GetUp() + _P:GetForward()*10)
					ParaAB:SetAngles(_P:GetAngles())
					ParaAB:Spawn()
			end
			if _P.EndParaTime and CurTime() >= _P.EndParaTime and _P:OnGround() then
				if GetConVarNumber( "VNT_Debug_Prints" ) >= 1 then	print( "ZP - User Landed Safely" ) end
				_P.EndParaTime = nil
				_P.Parachuting = false
				umsg.Start("PARAIsIn",_P)
					umsg.Bool(_P.Parachuting)
				umsg.End()
				_P.FlarePara = 1
				_P:ViewPunch(Angle(-16,0,0))
				_P:EmitSound("CmbSoldier_ZipLine_Clip")
				if GetConVarNumber("VNT_ZParachute_AllowWeapons") != 1 then
					_P:StripWeapon( "eq_zparachute" )
				end
				local ParaAB = ents.Create("zchute_redux_land")
					ParaAB:SetOwner(_P)
					ParaAB:SetPos(_P:GetPos() + _P:GetUp() + _P:GetForward()*10)
					ParaAB:SetAngles(_P:GetAngles())
					ParaAB:Spawn()
			--elseif _P.EndParaTime and CurTime() >= _P.EndParaTime and _P:OnGround() and _P.FlarePara < 0.4 then
				--if GetConVarNumber( "VNT_Debug_Prints" ) >= 1 then	print( "ZP - User Performed Flared Landing" ) end				
			end
			if _P:KeyDown(IN_USE) and _P.FlarePara > 0.4 then
				if GetConVarNumber( "VNT_Debug_Prints" ) >= 1 then	print( "ZP - User Flaring Chute" ) end
				_P.FlarePara = _P.FlarePara - 0.005
				if _P.FlarePara < 0.4 then --_P.FlarePara = 0.4 end
					if GetConVarNumber( "VNT_Debug_Prints" ) >= 1 then	print( "ZP - User Over-Flared Chute and Collapsed It" ) end
					_P.EndParaTime = nil
					_P.Parachuting = false
					umsg.Start("PARAIsIn",_P)
						umsg.Bool(_P.Parachuting)
					umsg.End()
					_P:ViewPunch(Angle(-18.5,0,0))
					_P:EmitSound("CmbSoldier_ZipLine_Clip")
					if GetConVarNumber("VNT_ZParachute_AllowWeapons") != 1 then
						_P:StripWeapon( "eq_zparachute" )
					end
					local ParaFlare = ents.Create("zchute_redux_flare")
						ParaFlare:SetOwner(_P)
						ParaFlare:SetPos(_P:GetPos() + _P:GetUp() + _P:GetForward()*10)
						ParaFlare:SetAngles(_P:GetAngles())
						ParaFlare:Spawn()
				end
			elseif not _P:KeyDown(IN_USE) and _P.FlarePara < 1 then
				_P.FlarePara = _P.FlarePara + 0.005
			end
			-- Originals By Zoey; kept for reference
			/*
			if _P:KeyDown(IN_FORWARD) then
				_P:SetLocalVelocity(_P:GetForward()*240*v.FlarePara*1.1 - _P:GetUp()*320*v.FlarePara)
			elseif _P:KeyDown(IN_MOVELEFT) then
				_P:SetLocalVelocity(_P:GetRight()*-215*v.FlarePara*1.1 - _P:GetUp()*320*v.FlarePara)
			elseif _P:KeyDown(IN_MOVERIGHT) then
				_P:SetLocalVelocity(_P:GetRight()*215*v.FlarePara*1.1 - _P:GetUp()*320*v.FlarePara)
			elseif _P:KeyDown(IN_BACK) then
				_P:SetLocalVelocity(_P:GetForward()*-240*v.FlarePara*1.1 - _P:GetUp()*320*v.FlarePara)
			end
			*/
		
			--	These control the custom parachute behaviors
			--
			if GetConVarNumber( "VNT_ZParachute_behaviour" ) <= 0 then
				if GetConVarString( "VNT_ZParachute_mdl" ) == "models/jessev92/bf2/parachute.mdl" then					
					if _P:KeyDown(IN_FORWARD) then
						_P:SetLocalVelocity(	_P:GetForward() * 350 * _P.FlarePara * 1.1 - _P:GetUp()*320*_P.FlarePara	)
					elseif _P:KeyDown(IN_BACK) then
						_P:SetLocalVelocity(_P:GetForward()*125*_P.FlarePara*1.1 - _P:GetUp()*175*_P.FlarePara)
					else
						_P:SetLocalVelocity(_P:GetForward()*250*_P.FlarePara*1.1 - _P:GetUp()*300*_P.FlarePara)
					end
				elseif GetConVarString( "VNT_ZParachute_mdl" ) == "models/jessev92/bf2142/parachute.mdl" then					
					if _P:KeyDown(IN_FORWARD) then
						_P:SetLocalVelocity(	_P:GetForward() * 1 * _P.FlarePara * 1.1 - _P:GetUp()*320*_P.FlarePara	)
					elseif _P:KeyDown(IN_BACK) then
						_P:SetLocalVelocity(_P:GetForward()*1*_P.FlarePara*1.1 - _P:GetUp()*200*_P.FlarePara)
					else
						_P:SetLocalVelocity(_P:GetForward()*1*_P.FlarePara*1.1 - _P:GetUp()*275*_P.FlarePara)
					end
				elseif GetConVarString( "VNT_ZParachute_mdl" ) == "models/jessev92/resliber/items/parachute.mdl" then					
					if _P:KeyDown(IN_FORWARD) then
						_P:SetLocalVelocity(	_P:GetForward() * 150 * _P.FlarePara * 1.1 - _P:GetUp()*320*_P.FlarePara	)
					elseif _P:KeyDown(IN_BACK) then
						_P:SetLocalVelocity(_P:GetForward()*50*_P.FlarePara*1.1 - _P:GetUp()*200*_P.FlarePara)
					else
						_P:SetLocalVelocity(_P:GetForward()*100*_P.FlarePara*1.1 - _P:GetUp()*275*_P.FlarePara)
					end
				elseif GetConVarString( "VNT_ZParachute_mdl" ) == "models/jessev92/frontlines/parachute.mdl" then					
					if _P:KeyDown(IN_FORWARD) then
						_P:SetLocalVelocity(	_P:GetForward() * 400 * _P.FlarePara * 1.1 - _P:GetUp() * 320 * _P.FlarePara	)
					elseif _P:KeyDown(IN_BACK) then
						_P:SetLocalVelocity(_P:GetForward()*75*_P.FlarePara*1.1 - _P:GetUp()*175*_P.FlarePara)
					else
						_P:SetLocalVelocity(_P:GetForward()*300*_P.FlarePara*1.1 - _P:GetUp()*275*_P.FlarePara)
					end
				elseif GetConVarString( "VNT_ZParachute_mdl" ) == "models/jessev92/justcause/parachute.mdl" then					
					if _P:KeyDown(IN_FORWARD) then
						_P:SetLocalVelocity(	_P:GetForward() * 500 * _P.FlarePara * 1.1 - _P:GetUp() * 320 * _P.FlarePara	)
					elseif _P:KeyDown(IN_BACK) then
						_P:SetLocalVelocity(_P:GetForward()*350*_P.FlarePara*1.1 - _P:GetUp()*256*_P.FlarePara)
					else
						_P:SetLocalVelocity(_P:GetForward()*425*_P.FlarePara*1.1 - _P:GetUp()*300*_P.FlarePara)
					end
				elseif GetConVarString( "VNT_ZParachute_mdl" ) == "models/jessev92/gtaiv/parachute.mdl" then					
					if _P:KeyDown(IN_FORWARD) then
						_P:SetLocalVelocity(	_P:GetForward() * 500 * _P.FlarePara * 1.1 - _P:GetUp() * 320 * _P.FlarePara	)
					elseif _P:KeyDown(IN_BACK) then
						_P:SetLocalVelocity(_P:GetForward()*150*_P.FlarePara*1.1 - _P:GetUp()*50*_P.FlarePara)
					else
						_P:SetLocalVelocity(_P:GetForward()*300*_P.FlarePara*1.1 - _P:GetUp()*250*_P.FlarePara)
					end
				else
					if _P:KeyDown(IN_FORWARD) then
						_P:SetLocalVelocity(	_P:GetForward() * 450 * _P.FlarePara * 1.1 - _P:GetUp() * 320 * _P.FlarePara	)
					elseif _P:KeyDown(IN_BACK) then
						_P:SetLocalVelocity(_P:GetForward()*300*_P.FlarePara*1.1 - _P:GetUp()*320*_P.FlarePara)
					else
						_P:SetLocalVelocity(_P:GetForward()*375*_P.FlarePara*1.1 - _P:GetUp()*320*_P.FlarePara)
					end
				end
			elseif GetConVarNumber( "VNT_ZParachute_behaviour" ) == 1 then
				if _P:KeyDown(IN_FORWARD) then
					_P:SetLocalVelocity(	_P:GetForward() * GetConVarNumber("VNT_ZParachute_speed_f") *	_P.FlarePara	*	1.1 -	_P:GetUp() *	GetConVarNumber("VNT_ZParachute_speed_f_down") *	_P.FlarePara	)
				elseif _P:KeyDown(IN_BACK) then
					_P:SetLocalVelocity(_P:GetForward() *	GetConVarNumber("VNT_ZParachute_speed_b") *	_P.FlarePara	*	1.1	-	_P:GetUp() *	GetConVarNumber("VNT_ZParachute_speed_b_down") *	_P.FlarePara)
				else
					_P:SetLocalVelocity(_P:GetForward()*	GetConVarNumber("VNT_ZParachute_speed_i")*_P.FlarePara*1.1 - _P:GetUp()*	GetConVarNumber("VNT_ZParachute_speed_i_down") *_P.FlarePara)
				end
			else
				if _P:KeyDown(IN_FORWARD) then
					_P:SetLocalVelocity(	_P:GetForward() * 450 * _P.FlarePara * 1.1 - _P:GetUp() * 320 * _P.FlarePara	)
				elseif _P:KeyDown(IN_BACK) then
					_P:SetLocalVelocity(_P:GetForward()*300*_P.FlarePara*1.1 - _P:GetUp()*320*_P.FlarePara)
				else
					_P:SetLocalVelocity(_P:GetForward()*375*_P.FlarePara*1.1 - _P:GetUp()*320*_P.FlarePara)
				end
			end
			
			if _P:KeyDown(IN_DUCK) and _P:KeyDown(IN_WALK) and _P.Parachuting == true then
				_P.Parachuting = false
				umsg.Start("PARAIsIn",_P)
					umsg.Bool(_P.Parachuting)
				umsg.End()
				_P.FlarePara = 1
				_P:ViewPunch(Angle(-15,0,0))
				_P:EmitSound("CmbSoldier_ZipLine_Clip")
				if GetConVarNumber("VNT_ZParachute_AllowWeapons") != 1 then
					_P:StripWeapon( "eq_zparachute" )
				end
				local ParaAB = ents.Create("zchute_redux_abandon")
					ParaAB:SetOwner(_P)
					ParaAB:SetPos(_P:GetPos() + _P:GetUp() + _P:GetForward()*10)
					ParaAB:SetAngles(_P:GetAngles())
					ParaAB:Spawn()
			end
			if _P:OnGround() and _P.Parachuting == true and not _P.EndParaTime then
				_P.EndParaTime = CurTime() + 1
				umsg.Start("PARAIsIn",_P)
					umsg.Bool(false)
				umsg.End()
				_P:ViewPunch(Angle(7,0,0))
				if GetConVarNumber("VNT_ZParachute_AllowWeapons") != 1 then
					_P:StripWeapon( "eq_zparachute" )
				end
			end
			if _P.EndParaTime and CurTime() >= _P.EndParaTime or _P:WaterLevel() > 0 then --flag
				_P.EndParaTime = nil
				_P.Parachuting = false
				umsg.Start("PARAIsIn",_P)
					umsg.Bool(_P.Parachuting)
				umsg.End()
				_P.FlarePara = 1
				_P:ViewPunch(Angle(-16,0,0))
				_P:EmitSound("CmbSoldier_ZipLine_Clip")
				if GetConVarNumber("VNT_ZParachute_AllowWeapons") != 1 then
					_P:StripWeapon( "eq_zparachute" )
				end
				local ParaLand = ents.Create("zchute_redux_land")
					ParaLand:SetOwner(_P)
					ParaLand:SetPos(_P:GetPos() + _P:GetUp() + _P:GetForward()*10)
					ParaLand:SetAngles(_P:GetAngles())
					ParaLand:Spawn()
			end
		end
	end
end
hook.Add("Think","ParachuteThink",ParachuteThink)

--	This only works with Zoey's CSS SWeps
--	ToDo: make a console command that lets you add weapons to it
/*
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
*/
	
--	Tags
--	Deprecated because Garry is WONDERFUL and replaced the GOOD server browser with a shit one, GJ
--	However, the legacy browser can still use them, if your server overrides the game, so I'll leave it here.
local tags = string.Explode( ",", ( GetConVarString("sv_tags") or "" ) )
if !table.HasValue(tags, "ZParachute") then 
	table.insert(tags, "ZParachute")
	table.sort(tags)
	RunConsoleCommand("sv_tags", table.concat(tags, ","))
end

if GetConVarNumber( "VNT_Debug_Prints" ) != 0 then	print("[V92] server/sv_ZParachuteRedux.lua Loaded!") end
