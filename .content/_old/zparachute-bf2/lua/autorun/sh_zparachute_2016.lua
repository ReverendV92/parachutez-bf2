
AddCSLuaFile()

-------------------------------------------------------
-------------------------------------------------------
--	ZParachute by Zoey
--	Overhaul by V92 with permission from Z
--	Profile Link:	http://steamcommunity.com/id/JesseVanover/
--	Workshop Link:	http://steamcommunity.com/sharedfiles/filedetails/?id=484061347
-------------------------------------------------------
-------------------------------------------------------

if !ConVarExists("VNT_Debug_Prints") then				CreateClientConVar( "VNT_Debug_Prints", '1', true, false )	end
if GetConVarNumber( "VNT_Debug_Prints" ) != 0 then	print("[V92] sh_ZParachuteRedux.lua Loading...")	end

local	function ParachuteKey(_P, _K)
	if _K == IN_JUMP and _P:IsValid() and _P:Alive() then
		if _P:GetMoveType() == MOVETYPE_NOCLIP or _P:InVehicle() or _P:OnGround() or _P.Parachuting == true or _P:GetVelocity().z > -600 then return end
		if CLIENT then
			_P:SelectWeapon( "eq_vpara_bf2" )
			_P:ViewPunch(Angle(35,0,0))
		end
		if SERVER then
			_P:SetNWBool( "vntVParachuting", true )
			_P:EmitSound( "jessev92/bf3/foley/parachute/deploy_1.wav", 100, math.random( 90, 110 ) )
		end
		print("deployed")
	end
end

local	function vntVParachuteThinkBF2()
	for k,_P in pairs (player.GetAll()) do
		if 	(	_P:GetNWBool( "vntVParachuting", false ) ==  true and _P:HasWeapon("eq_vpara_bf2")	and	( _P:Alive()	and _P:IsValid()) )	then
			if CLIENT then
			
			end
			if SERVER then
				_P.FlarePara = 1
				_P:SetNWBool( "vntVParachuting", true )
				if _P:KeyDown(IN_FORWARD) then
					_P:SetLocalVelocity(	_P:GetForward() * 450 * _P.FlarePara * 1.1 - _P:GetUp() * 320 * _P.FlarePara	)
				elseif _P:KeyDown(IN_BACK) then
					_P:SetLocalVelocity(_P:GetForward()*300*_P.FlarePara*1.1 - _P:GetUp()*320*_P.FlarePara)
				else
					_P:SetLocalVelocity(_P:GetForward()*375*_P.FlarePara*1.1 - _P:GetUp()*320*_P.FlarePara)
				end
			end
		end
	end
end
