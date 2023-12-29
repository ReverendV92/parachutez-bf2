
AddCSLuaFile( )

local pzCVmode = CreateConVar( "vnt_parachutez_sv_mode" , 0 , { FCVAR_ARCHIVE , FCVAR_REPLICATED } , "[Parachute Z] (Server) Set parachute mode;\n-1=Disabled\n0=All Users\n1=Admin Only\n2=Super Admin Only\n3=Requires Entity Pickup" , -1 , 3 )
local pzCVsensitivity = CreateConVar( "vnt_parachutez_sv_sensitivity" , 0.2 , { FCVAR_ARCHIVE , FCVAR_REPLICATED } , "[Parachute Z] (Server) Set parachute look sensitivity. Default: 0.2" , 0.2 , 1 )
local pzCVvelocity = CreateConVar( "vnt_parachutez_sv_velocitylimit" , 500 , { FCVAR_ARCHIVE , FCVAR_REPLICATED } , "[Parachute Z] (Server) Set velocity needed to open parachute. Default: 500" , 50 , 1000 )
local pzCVenable = CreateConVar( "vnt_parachutez_cl_enable" , 1 , { FCVAR_ARCHIVE , FCVAR_USERINFO } , "[Parachute Z] (Client) Client-side toggle for the parachute." , 0 , 1 )
local pzCVstyle = CreateConVar( "vnt_parachutez_cl_style" , 0 , { FCVAR_ARCHIVE , FCVAR_USERINFO } , "[Parachute Z] (Client) Set client parachute model" , 0 , 6 )
local pzCVmovevolume = CreateConVar( "vnt_parachutez_cl_volume" , 0.7 , { FCVAR_ARCHIVE , FCVAR_USERINFO } , "[Parachute Z] (Client) Set flight sound volume" , 0.2 , 1 )
local pzCVnotifyvolume = CreateConVar( "vnt_parachutez_cl_notify_volume" , 0.5 , { FCVAR_ARCHIVE , FCVAR_USERINFO } , "[Parachute Z] (Client) Set parachute notification sound volume.\nSet to 0 to disable." , 0 , 1 )

sound.Add({	["name"] = "VNT_ParachuteZ_DetachClip" ,
	["channel"] = CHAN_BODY ,
	["volume"] = 1.0 ,
	["level"] = 75 ,
	["pitch"] = { 90 , 110 } ,
	["sound"] = { "npc/combine_soldier/zipline_clip1.wav" , "npc/combine_soldier/zipline_clip2.wav" }
} )

sound.Add({	["name"] = "VNT_ParachuteZ_BF2_Deploy" ,
	["channel"] = CHAN_BODY ,
	["volume"] = 1.0 ,
	["level"] = 75 ,
	["pitch"] = { 105 , 110 } ,
	["sound"] = { "v92/bf2/vehicles/air/parachute/parachute_deploy.wav" }
})

sound.Add({	["name"] = "VNT_ParachuteZ_BF2_Idle" ,
	["channel"] = CHAN_STATIC ,
	["volume"] = 1.0 ,
	["level"] = 75 ,
	["pitch"] = { 100 } ,
	["sound"] = { "v92/bf2/vehicles/air/parachute/parachute_ride_loop.wav" }
})

if SERVER then

	local playerGetAll, ipairs = player.GetAll, ipairs
	local entsCreate = ents.Create

	--------------------------------------------------
	-- Test code stolen from TFA base
	--------------------------------------------------

	util.AddNetworkString("PZ_SetServerCommand")

	local function QueueConVarChange(convarname, convarvalue)
		if not convarname or not convarvalue then return end

		timer.Create("pz_cvarchange_" .. convarname, 0.1, 1, function()
			if not string.find(convarname, "vnt_parachutez_") or not GetConVar(convarname) then return end -- affect only ParachuteZ convars

			RunConsoleCommand(convarname, convarvalue)
		end)
	end

	local function ChangeServerOption(_length, _player)
		local _cvarname = net.ReadString()
		local _value = net.ReadString()

		if IsSinglePlayer then return end
		if not IsValid(_player) or not _player:IsAdmin() then return end

		QueueConVarChange(_cvarname, _value)
	end

	net.Receive("PZ_SetServerCommand", ChangeServerOption)

	------------------------------

	util.AddNetworkString("PZ_Active")

	local function sendParStatus( ply, fl )
		net.Start("PZ_Active")
			net.WriteBool( fl and false or ply.Parachuting)
		net.Send(ply)
	end

	-- Download via Workshop for speed and ease
	resource.AddWorkshop( "105699464" ) 

	-- XYZ Coordinate offset for the parachute entities
	local ActiveParachute = { 10 , 0 , 100 , 0 }
	local LandedParachute = { -100 , 50 , 10 , Angle( 0 , 270 , 0 ) }
	local DitchedParachute = { -100 , 50 , 10 , Angle( 0 , 270 , 0 ) }

	-- Parachute speed for IN_BACK, No Inputs, and IN_FORWARD, respectively
	local ParachuteSpeed = { 300 , 375 , 450 }

	-- The stuff for spawning the parachute entity
	function ParachuteKey( ply , key )

		-- If the mod is diabled or player is a spectator, don't run.
		-- if ( GetConVarNumber("vnt_parachutez_sv_mode") == -1 ) or ply:Team() == TEAM_SPECTATOR then return false end
		if ( pzCVmode:GetInt() == -1 ) or ply:Team() == TEAM_SPECTATOR then return false end

		-- If player is already parachuting, don't run.
		if ply.Parachuting then return end

		-- If Admin-Only mode is active and the user is not an admin, don't run.
		-- if ( GetConVarNumber("vnt_parachutez_sv_mode") == 1 and !table.HasValue( { "superadmin" , "admin" } , ply:GetNWString( "usergroup" ) ) ) then return end
		if ( pzCVmode:GetInt() == 1 and !table.HasValue( { "superadmin" , "admin" } , ply:GetNWString( "usergroup" ) ) ) then return end

		-- If Super Admin-Only mode is active and the user is not a super admin, don't run.
		-- if ( GetConVarNumber("vnt_parachutez_sv_mode") == 2 and !table.HasValue( { "superadmin" } , ply:GetNWString( "usergroup" ) ) ) then return end
		if ( pzCVmode:GetInt() == 2 and !table.HasValue( { "superadmin" } , ply:GetNWString( "usergroup" ) ) ) then return end

		-- If player is allowed to parachute and they're activating their parachute key...
		if ply.AllowToParachute and key == IN_JUMP then

			-- Remove their parachute entity
			ply:RemoveParachute()

			ply.EndParaTime = nil

			-- Flag them as parachuting
			ply.Parachuting = true
			sendParStatus( ply, fl )

			-- Set the default flare value
			ply.FlarePara = 1

			-- Visual feedback
			ply:ViewPunch( Angle( 35 , 0 , 0 ) )

			-- Create the parachute entity
			local Para = entsCreate( "v92_zchute_active" )
			Para:SetOwner( ply )
			Para:SetPos( ply:GetPos() + ply:GetForward() * ActiveParachute[1] + ply:GetRight() * ActiveParachute[2] + ply:GetUp() * ActiveParachute[3] )
			Para:SetAngles( ply:GetAngles() )
			Para:Spawn()
			Para:Activate()

			-- Create the sound
			LoopingSound = CreateSound( ply , "v92/bf2/vehicles/air/parachute/parachute_ride_loop.wav" )
			-- LoopingSound:PlayEx( GetConVarNumber( "vnt_parachutez_cl_volume" ) , 100 )
			LoopingSound:PlayEx( pzCVmovevolume:GetFloat() , 100 )

		end

	end
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

	hook.Add( "PlayerDeath" , "RemoveParachuteZ" , function( victim, inflictor, attacker )
		if !IsValid( victim ) then return end
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

	function ParachuteThink( )

		-- If the mod is diabled, don't run.
		if ( pzCVmode:GetInt() == -1 ) then return false end
		if ( pzCVenable:GetInt() == 0 ) then return false end

		-- Find players so we can scrutinize them...
		for k , ply in ipairs( playerGetAll( ) ) do

			local ply_Forward = ply:GetForward()
			local ply_Right = ply:GetRight()
			local ply_Up = ply:GetUp()
			local ply_pos, ply_ang = ply:GetPos(), ply:GetAngles()
			local Velocity = ply:GetVelocity()

			local onground = ply:OnGround()
			local speedbl = Velocity.z > 120
			local mt, wl = ply:GetMoveType(), ply:WaterLevel()

			-- Reset the allow to parachute check
			ply.AllowToParachute = nil

			-- If user is parachuting...
			if !ply.Parachuting then 
				if onground then continue end
				if mt == MOVETYPE_NOCLIP then continue end
				if ply:InVehicle() then continue end
				-- if Velocity.z > ( GetConVarNumber("vnt_parachutez_sv_velocitylimit") * -1 ) then continue end
				if Velocity.z > ( pzCVvelocity:GetInt() * -1 ) then continue end
				-- if !ply:HaveParachute() and GetConVarNumber("vnt_parachutez_sv_mode") == 3 then continue end
				if !ply:HaveParachute() and pzCVmode:GetInt() == 3 then continue end
				
				ply.AllowToParachute = true
				NotifyPlayerParachute(ply)

				continue
			end

			-- If the player enters a non-parachute situtation...
			if ply.EndParaTime and CurTime() >= ply.EndParaTime and onground or wl > 0 or mt == MOVETYPE_LADDER or speedbl then

				ply.EndParaTime = nil
				ply.Parachuting = false

				sendParStatus(ply)
				ply.FlarePara = 1

				ply:ViewPunch( StartPunch )

				local ParaLand = entsCreate( "v92_zchute_abandon" )

				ParaLand:SetOwner( ply )
				ParaLand:SetPos( ply_pos + ply_Forward * LandedParachute[1] + ply_Right * LandedParachute[2] + ply_Up * LandedParachute[3] )
				ParaLand:SetAngles( ply_ang + LandedParachute[4]  )
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

				local ParaDitch = entsCreate( "v92_zchute_abandon" )
				ParaDitch:SetOwner( ply )
				ParaDitch:SetPos( ply_pos + ply_Forward * DitchedParachute[1] + ply_Right * DitchedParachute[2] + ply_Up * DitchedParachute[3] )
				ParaDitch:SetAngles( ply_ang + LandedParachute[4]  )
				ParaDitch:Spawn()
				ParaDitch:Activate()

				LoopingSound:Stop()

			end

			if ( ply:OnGround() and ply.Parachuting and not ply.EndParaTime ) or speedbl then

				ply.EndParaTime = CurTime( ) + 0.25
				sendParStatus(ply, true)
				ply:ViewPunch( LandPunch )

				LoopingSound:Stop( )

			end
		end

	end
	hook.Add( "Think" , "ParachuteThink" , ParachuteThink )

end

if CLIENT then

	--------------------------------------------------
	-- Test code stolen from TFA base
	--------------------------------------------------

	function CheckBoxNet(_parent, label, convar, ...)
		local gconvar = assert(GetConVar(convar), "Unknown ConVar: " .. convar .. "!")
		local newpanel

		if IsSinglePlayer then
			newpanel = _parent:CheckBox(label, convar, ...)
		else
			newpanel = _parent:CheckBox(label, nil, ...)
		end

		if not IsSinglePlayer then
			if not IsValid(newpanel.Button) then return newpanel end

			newpanel.Button.Think = function(_self)
				local bool = gconvar:GetBool()

				if _self:GetChecked() ~= bool then
					_self:SetChecked(bool)
				end
			end

			newpanel.OnChange = function(_self, _bVal)
				if not LocalPlayer():IsAdmin() then return end
				if _bVal == gconvar:GetBool() then return end

				net.Start("PZ_SetServerCommand")
				net.WriteString(convar)
				net.WriteString(_bVal and "1" or "0")
				net.SendToServer()
			end
		end

		return newpanel

	end

	function NumSliderNet(_parent, label, convar, min, max, type1, ...)
		local gconvar = assert(GetConVar(convar), "Unknown ConVar: " .. convar .. "!")
		local newpanel

		if IsSinglePlayer then
			--newpanel = _parent:NumSlider(label, convar, min, max, type1, ...)
			newpanel = _parent:AddControl( "slider" , { ["Label"] = label , ["Command"] = convar , ["Min"] = min , ["Max"] = max , ["Type"] = type1 } )
		else
			--newpanel = _parent:NumSlider(label, nil, min, max, type1, ...)
			newpanel = _parent:AddControl( "slider" , { ["Label"] = label , ["Command"] = nil , ["Min"] = min , ["Max"] = max , ["Type"] = type1 } )
		end
	
		local decimals = 2
		local sf = "%." .. decimals .. "f"
	
		if not IsSinglePlayer then
			local ignore = false
	
			newpanel.Think = function(_self)
				if _self._wait_for_update and _self._wait_for_update > RealTime() then return end
				local float = gconvar:GetFloat()
	
				if _self:GetValue() ~= float then
					ignore = true
					_self:SetValue(float)
					ignore = false
				end
			end
	
			newpanel.OnValueChanged = function(_self, _newval)
				if ignore then return end
	
				if not LocalPlayer():IsAdmin() then return end
				_self._wait_for_update = RealTime() + 1
	
				timer.Create("pz_vgui_" .. convar, 0.5, 1, function()
					if not LocalPlayer():IsAdmin() then return end
	
					net.Start("PZ_SetServerCommand")
					net.WriteString(convar)
					net.WriteString(string.format(sf, _newval))
					net.SendToServer()
				end)
			end
		end

		return newpanel
	end

	function AddCVarNet(_parent, label, convar, ...)
		local gconvar = assert(GetConVar(convar), "Unknown ConVar: " .. convar .. "!")
		local newpanel

		if IsSinglePlayer then
			newpanel = _parent:AddCVar( label, convar, ... )
		else
			newpanel = _parent:AddCVar( label, nil, ... )
		end

		if not IsSinglePlayer then
			-- print(newpanel.Think)
			-- PrintTable( debug.getmetatable(newpanel.Panel) )
			if not IsValid(newpanel) then return newpanel end

			newpanel.Panel.Think = function(_self)
				local bool = gconvar:GetBool()

				if _self:GetChecked() ~= bool then
					_self:SetChecked(bool)
				end
			end

			newpanel.OnChecked = function(_self, _bVal)
				if not LocalPlayer():IsAdmin() then return end
				if _bVal == gconvar:GetBool() then return end

				net.Start("PZ_SetServerCommand")
				net.WriteString(convar)
				net.WriteString(_bVal and "1" or "0")
				net.SendToServer()
			end
		end

		return newpanel

	end

	--------------------------------------------------

	local sndstr = "player/suit_sprint.wav"
	function PlayParachuteDeploySND()
		-- local fl = GetConVarNumber("vnt_parachutez_cl_notify_volume")
		local fl = pzCVnotifyvolume:GetFloat()
		if fl == 0 then return end
		local ply = LocalPlayer()
		ply:EmitSound(sndstr, nil, nil, fl)
		-- timer.Simple(2.1, function()
			-- if IsValid(ply) then
				-- ply:StopSound( sndstr )
			-- end
		-- end)
	end

	-- Tool Menu
	local function ParachuteZ_Common( Panel )

		Panel:ControlHelp( "Parachute-Z Controls" )

		local Default = {

			["vnt_parachutez_sv_mode"] = 0 ,
			["vnt_parachutez_sv_sensitivity"] = 0.2 ,
			["vnt_parachutez_sv_velocitylimit"] = 500 ,
			["vnt_parachutez_cl_enable"] = 1 ,
			["vnt_parachutez_cl_style"] = 0 ,
			["vnt_parachutez_cl_volume"] = 0.7 ,
			["vnt_parachutez_cl_notify_volume"] = 0.5 ,

		}

		Panel:AddControl( "ComboBox" , { ["MenuButton"] = 1 , ["Folder"] = "parachutez_common" , ["Options"] = { [ "#preset.default" ] = Default } , ["CVars"] = table.GetKeys( Default ) } )

		CheckBoxNet(Panel, "Enable Parachute" , "vnt_parachutez_cl_enable" )
		Panel:ControlHelp( "Client-side parachute toggle. Disable if using other add-ons." )
		NumSliderNet(Panel, "Parachute Mode", "vnt_parachutez_sv_mode", "-1", "3", "int")
		Panel:ControlHelp( "-1=Disabled\n0=All Users\n1=Admin Only\n2=Super Admin Only\n3=Require entity pickup" )
		NumSliderNet(Panel, "Parachute Style", "vnt_parachutez_cl_style", "0", "6", "int")
		Panel:ControlHelp( "Parachute Model\n0: Battlefield 2\n1: Battlefield 3/4\n2: Battlefield 2142\n3: Resistance & Liberation\n4: Frontlines: FoW\n5: Just Cause\n6: GTA 4" )

		NumSliderNet(Panel, "View Sensitivity", "vnt_parachutez_sv_sensitivity", "0.2", "1", "float")
		Panel:ControlHelp( "Mouselook sensitivity while parachuting. Default: 0.2" )
		NumSliderNet(Panel, "Velocity Barrier", "vnt_parachutez_sv_velocitylimit", "50", "1000", "int")
		Panel:ControlHelp( "Velocity needed to allow parachuting. Default: 500" )

		NumSliderNet(Panel, "Flight Volume", "vnt_parachutez_cl_volume", "0.2", "1", "float")
		NumSliderNet(Panel, "Notification Volume", "vnt_parachutez_cl_notify_volume", "0", "1", "float")

		-- Panel:KeyBinder( "Activate Parachute" , "vnt_parachutez_activate" )

	end

	hook.Add( "PopulateToolMenu", "PopulateParachuteZMenus", function( )
		spawnmenu.AddToolMenuOption( "Options" , "V92" , "Parachute-Z" , "Parachute-Z" , "" , "" , ParachuteZ_Common )
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
		-- return GetConVarNumber("vnt_parachutez_sv_sensitivity")
		return pzCVsensitivity:GetFloat()
	end

	local function OnParachuteStart()
		hook.Add( "CalcView", "ParachuteShake", ParachuteShake)
		hook.Add( "AdjustMouseSensitivity", "ParachuteSens", DecrSens)
	end

	local function OnParachuteEnd()
		hook.Remove( "CalcView", "ParachuteShake")
		hook.Remove( "AdjustMouseSensitivity", "ParachuteSens")
	end	
	net.Receive("PZ_Active", function()
		local bl = net.ReadBool()
		LocalPlayer().Parachuting = bl
		if bl then
			OnParachuteStart()
			return
		end
		OnParachuteEnd()
	end)

end
