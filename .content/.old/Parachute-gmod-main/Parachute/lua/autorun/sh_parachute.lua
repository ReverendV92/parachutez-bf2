
AddCSLuaFile( )

local parachute_enabled = CreateConVar( "parachute_enabled" , "1", { FCVAR_ARCHIVE , FCVAR_REPLICATED }, "Enable parachute")
local parachute_volume = CreateConVar( "parachute_volume" , "0.7", { FCVAR_ARCHIVE , FCVAR_REPLICATED }, "Set flight sound volume" , 0.2 , 1 )
local parachute_notify_volume = CreateConVar( "parachute_notify_volume" , "0.5", { FCVAR_ARCHIVE , FCVAR_REPLICATED }, "Set notify sound volume" , 0 , 1 )

sound.Add({	["name"] = "BF2_Parachute_DetachClip" ,
	["channel"] = CHAN_BODY ,
	["volume"] = 1.0 ,
	["level"] = 50 ,
	["pitch"] = { 90, 110 } ,
	["sound"] = { "npc/combine_soldier/zipline_clip1.wav" , "npc/combine_soldier/zipline_clip2.wav" }
} )

sound.Add({	["name"] = "BF2_Parachute_Deploy" ,
	["channel"] = CHAN_BODY ,
	["volume"] = 1.0 ,
	["level"] = 75 ,
	["pitch"] = { 105 , 110 } ,
	["sound"] = { "parachute/parachute_deploy.wav" }
})

sound.Add({	["name"] = "BF2_Parachute_Idle" ,
	["channel"] = CHAN_STATIC ,
	["volume"] = 1.0 ,
	["level"] = 75 ,
	["pitch"] = { 100 } ,
	["sound"] = { "parachute/parachute_ride_loop.wav" }
})

if SERVER then

	local playerGetAll, ipairs = player.GetAll, ipairs
	local entsCreate = ents.Create

	util.AddNetworkString("PARAIsIn")

	local function sendParStatus( ply, fl )
		net.Start("PARAIsIn")
			net.WriteBool( fl and false or ply.Parachuting)
		net.Send(ply)
	end

	-- Download via Workshop for speed and ease
	resource.AddWorkshop( "105699464" ) 

	-- XYZ Coordinate offset for the parachute entities
	local ActiveParachute = { 10 , 0 , 100 }
	local LandedParachute = { -100 , 50 , 10 }
	local DitchedParachute = { 10 , 0 , 0 }

	-- Parachute speed for IN_BACK, No Inputs, and IN_FORWARD, respectively
	local ParachuteSpeed = { 300 , 375 , 450 }

	-- The stuff for spawning the parachute entity
	function ParachuteKey( ply , key )
		if !ply:IsValid() then return end
		if !ply:Alive() then return end
		if !ply:HaveParachute() then return end
		local parachuteenabled = parachute_enabled:GetBool()
		local playerisspec = ply:Team() == TEAM_SPECTATOR

		if !parachuteenabled or playerisspec then return false end

		if ply.AllowToParachute and key == IN_JUMP and !ply.Parachuting then
			ply:RemoveParachute()
			ply.EndParaTime = nil
			ply.Parachuting = true

			sendParStatus( ply, fl )

			ply.FlarePara = 1
			ply:ViewPunch( Angle( 35 , 0 , 0 ) )

			local Para = entsCreate( "parachute_active" )
			Para:SetOwner( ply )
			Para:SetPos( ply:GetPos() + ply:GetForward() * ActiveParachute[1] + ply:GetRight() * ActiveParachute[2] + ply:GetUp() * ActiveParachute[3] )
			Para:SetAngles( ply:GetAngles() )
			Para:Spawn()
			Para:Activate()

			LoopingSound = CreateSound( ply , "parachute/parachute_ride_loop.wav" )
			LoopingSound:PlayEx( parachute_volume:GetFloat() , 100 )

		end
	end --ParachuteKey end

	hook.Add( "KeyPress" , "ParachuteKey" , ParachuteKey )

	local PLAYER = FindMetaTable("Player")

	function PLAYER:HaveParachute()
		return self:GetNWBool("HaveParachute", false)
	end

	function PLAYER:GiveParachute()
		if self:HaveParachute() then return false end
		self:SetNWBool("HaveParachute", true)
		return true
	end

	function PLAYER:RemoveParachute()
		self:SetNWBool("HaveParachute", false)
	end

	hook.Add( "PlayerDeath", "RemoveParachute", function( victim, inflictor, attacker )
		if !IsValid(victim) then return end
		victim:RemoveParachute()
	end )

	local LandPunch, StartPunch, landang = Angle( 7 , 0 , 0 ),  Angle( -16 , 0 , 0 ), Angle( 0 , 270 , 0 )

	local cds = {}

	local function NotifyPlayerParachute( ply )
		cds[ply] = cds[ply] or 0
		if cds[ply] > CurTime() then return end
		ply:SendLua("PlayParachuteDeploySND()")
		cds[ply] = CurTime() + 3
	end

	function ParachuteThink()
		if !parachute_enabled:GetBool() then return false end

		for k, ply in ipairs( playerGetAll() ) do

			local ply_Forward = ply:GetForward()
			local ply_Right = ply:GetRight()
			local ply_Up = ply:GetUp()
			local ply_pos, ply_ang = ply:GetPos(), ply:GetAngles()
			local Velocity = ply:GetVelocity()

			local onground = ply:OnGround()
			local speedbl = Velocity.z > 120
			local mt, wl = ply:GetMoveType(), ply:WaterLevel()

			ply.AllowToParachute = nil

			if !ply.Parachuting then 
				if onground then continue end
				if mt == MOVETYPE_NOCLIP then continue end
				if ply:InVehicle() then continue end
				if Velocity.z > -600 then continue end
				if ply:HaveParachute() then
					ply.AllowToParachute = true
					NotifyPlayerParachute(ply)
				end
				continue
			end

			if ply.EndParaTime and CurTime() >= ply.EndParaTime and onground or wl > 0 or mt == MOVETYPE_LADDER or speedbl then
				ply.EndParaTime = nil
				ply.Parachuting = false

				sendParStatus(ply)
				ply.FlarePara = 1

				ply:ViewPunch( StartPunch )

				local ParaLand = entsCreate( "parachute_abandon" )

				ParaLand:SetOwner( ply )
				ParaLand:SetPos( ply_pos + ply_Forward * LandedParachute[1] + ply_Right * LandedParachute[2] + ply_Up * LandedParachute[3] )
				ParaLand:SetAngles( ply_ang + landang )
				ParaLand:Spawn()
				ParaLand:Activate()

				LoopingSound:Stop()

			end

			if ply:KeyDown( IN_USE ) and ply.FlarePara > 0.4 then

				ply.FlarePara = ply.FlarePara - 0.005

				if ply.FlarePara < 0.4 then
					ply.FlarePara = 0.4
				end

			end


			if ply:KeyDown( IN_FORWARD ) then
				ply:SetLocalVelocity( ply_Forward * ParachuteSpeed[3] * ply.FlarePara * 1.1 - ply_Up * 320 * ply.FlarePara )
			elseif ply:KeyDown( IN_BACK ) then
				ply:SetLocalVelocity( ply_Forward * ParachuteSpeed[1] * ply.FlarePara * 1.1 - ply_Up * 320 * ply.FlarePara )
			else
				ply:SetLocalVelocity( ply_Forward * ParachuteSpeed[2] * ply.FlarePara * 1.1 - ply_Up * 320 * ply.FlarePara )
			end

			if ( ply:KeyDown( IN_DUCK ) and ply:KeyDown( IN_WALK ) and ply.Parachuting ) or not ( ply:Alive( ) or IsValid( ply ) ) then

				ply.Parachuting = false
				sendParStatus(ply)
				ply.FlarePara = 1
				ply:ViewPunch( Angle( -15 , 0 , 0 ) )

				local ParaDitch = entsCreate( "parachute_abandon" )
				ParaDitch:SetOwner( ply )
				ParaDitch:SetPos( ply_pos + ply_Forward * DitchedParachute[1] + ply_Right * DitchedParachute[2] + ply_Up * DitchedParachute[3] )
				ParaDitch:SetAngles( ply_ang )
				ParaDitch:Spawn()
				ParaDitch:Activate()

				LoopingSound:Stop()

			end

			if ( ply:OnGround() and ply.Parachuting and not ply.EndParaTime ) or speedbl then

				ply.EndParaTime = CurTime( ) + 0.25
				sendParStatus(ply, true) --Send false
				ply:ViewPunch( LandPunch )

				LoopingSound:Stop( )

			end
		end --ParachuteThink
	end
	hook.Add( "Think" , "ParachuteThink" , ParachuteThink )
end --ServerEnd

if CLIENT then

	local sndstr = "npc/attack_helicopter/aheli_crash_alert2.wav"
	function PlayParachuteDeploySND()
		local fl = parachute_notify_volume:GetFloat()
		if fl == 0 then return end
		local ply = LocalPlayer()
		ply:EmitSound(sndstr, nil, nil, fl)
		timer.Simple(2.1, function()
			if IsValid(ply) then
				ply:StopSound( sndstr )
			end
		end)
	end

	local function Parachute_Common( pnl )

		local Default = {
			["parachute_enabled"] = 1,
			["parachute_usechestatt"] = 0,
			["parachute_volume"] = 0.7 ,
			["parachute_notify_volume"] = 0.5
		}

		pnl:AddControl( "ComboBox" , { ["MenuButton"] = 1 , ["Folder"] = "parachute_common" , ["Options"] = { [ "#preset.default" ] = Default } , ["CVars"] = table.GetKeys( Default ) } )

		pnl:CheckBox( "Parachute Enable" , "parachute_enabled")

		pnl:CheckBox( "Use chest attachment instead of position" , "parachute_usechestatt")

		pnl:NumSlider( "Flight Volume" , "parachute_volume" , 0.2 , 1 , 1 )

		pnl:NumSlider( "Notify Volume" , "parachute_notify_volume" , 0 , 1 , 1 )

	end

	-- Tool Menu
	hook.Add( "PopulateToolMenu", "PopulateParachuteMenus", function( )

		spawnmenu.AddToolMenuOption( "Options" , "Player" , "Parachute" , "Parachute" , "" , "" , Parachute_Common )

	end)

	local function ParachuteShake( ply, pos, angles, fov )
		if LocalPlayer() != GetViewEntity() then return end
		local p, y = TimedSin(1, 0, 1, 0), TimedSin(1.2, 0, 2, 0)
		local view = {
			angles = angles + Angle( p, y, 0 ),
		}

		return view
	end

	local function DecrSens( orig )
		return .2
	end

	local function OnParachuteStart()
		hook.Add( "CalcView", "ParachuteShake", ParachuteShake)
		hook.Add( "AdjustMouseSensitivity", "ParachuteSens", DecrSens)
	end

	local function OnParachuteEnd()
		hook.Remove( "CalcView", "ParachuteShake")
		hook.Remove( "AdjustMouseSensitivity", "ParachuteSens")
	end	
	net.Receive("PARAIsIn", function()
		local bl = net.ReadBool()
		LocalPlayer().Parachuting = bl
		if bl then
			OnParachuteStart()
			return
		end
		OnParachuteEnd()
	end)

end