
AddCSLuaFile( )

CreateConVar( "vnt_parachutez_sv_mode" , 0 , { FCVAR_ARCHIVE , FCVAR_REPLICATED } , "[Parachute Z] (Server) Set parachute mode; -1=Disabled, 0=All Users, 1=Admin Only, 2=Super Admin Only" , -1 , 2 )

CreateConVar( "vnt_parachutez_cl_volume" , 0.7 , { FCVAR_ARCHIVE , FCVAR_REPLICATED } , "[Parachute Z] (Client) Set flight sound volume" , 0.2 , 1 )

sound.Add({	["name"] = "VNT_ParachuteZ_DetachClip" ,
	["channel"] = CHAN_BODY ,
	["volume"] = 1.0 ,
	["level"] = 50 ,
	["pitch"] = { 90, 110 } ,
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

		-- If the mod is diabled...
		if ( GetConVarNumber("vnt_parachutez_sv_mode") == -1 ) or 

		-- If player is a spectator...
		ply:Team() == TEAM_SPECTATOR or

		-- If Admin-Only mode is active and the user is not an admin...
		( GetConVarNumber("vnt_parachutez_sv_mode") == 1 and !table.HasValue( { "superadmin" , "admin" } , ply:GetNWString( "usergroup" ) ) ) or 

		-- If Super Admin-Only mode is active and the user is not a super admin...
		( GetConVarNumber("vnt_parachutez_sv_mode") == 2 and !table.HasValue( { "superadmin" } , ply:GetNWString( "usergroup" ) ) ) then

			-- Disabled! Enjoy the broken legs!
			return false

		else

			-- If player:
				-- Is pressing IN_JUMP
				-- Is alive
				-- Isn't Noclipping, in a vehicle, on the ground, or already in a parachute
				-- Has a velocity > -600
			if ( key == IN_JUMP and ply:IsValid( ) and ply:Alive( ) ) and not ( ply:GetMoveType( ) == MOVETYPE_NOCLIP or ply:InVehicle( ) or ply:OnGround( ) or ply.Parachuting == true or ply:GetVelocity( ).z > - dg_backpack_config["velocity_required_to_activate"] ) then
				if !ply.has_parachute then return end
				ply.EndParaTime = nil
				ply.Parachuting = true
				umsg.Start( "PARAIsIn" , ply )
				umsg.Bool( ply.Parachuting )
				umsg.End( )
				ply.FlarePara = 1
				ply:ViewPunch( Angle( 35 , 0 , 0 ) )
				local Para = ents.Create( "v92_zchute_bf2_active" )
				Para:SetOwner( ply )
				Para:SetPos( ply:GetPos( ) + ply:GetForward( ) * ActiveParachute[1] + ply:GetRight( ) * ActiveParachute[2] + ply:GetUp( ) * ActiveParachute[3] )
				Para:SetAngles( ply:GetAngles( ) )
				Para:Spawn( )
				Para:Activate( )
				ply.has_parachute = false

				-- if CLIENT then

					LoopingSound = CreateSound( ply , "v92/bf2/vehicles/air/parachute/parachute_ride_loop.wav" )
					LoopingSound:PlayEx( GetConVarNumber( "vnt_parachutez_cl_volume" ) , 100 )

				-- end

			end

		end

	end
	hook.Add( "KeyPress" , "ParachuteKey" , ParachuteKey )

	function ParachuteThink( )

		-- If the mod is diabled...
		if ( GetConVarNumber("vnt_parachutez_sv_mode") == -1 ) then

			-- Disabled! Enjoy the broken legs!
			return false

		else

			-- Find players so we can scrutinize them...
			for k , v in pairs( player.GetAll( ) ) do

				-- If Admin-Only mode is active and the user is not an admin...
				if ( GetConVarNumber("vnt_parachutez_sv_mode") == 1 and !table.HasValue( { "superadmin" , "admin" } , v:GetNWString( "usergroup" ) ) ) or
				
				-- If Super Admin-Only mode is active and the user is not a super admin...
				( GetConVarNumber("vnt_parachutez_sv_mode") == 2 and !table.HasValue( { "superadmin" } , v:GetNWString( "usergroup" ) ) )

				then

					-- No parachute for you, dipshit!
					return false

				else

					-- If user is parachuting...
					if v.Parachuting == true then

						-- If the parachute is ended and the user is on the ground...
						if v.EndParaTime and CurTime( ) >= v.EndParaTime and v:OnGround() == true or 
						-- Or if the user is in water...
						v:WaterLevel() > 0 or 
						-- Or if the user is on a ladder...
						v:GetMoveType() == MOVETYPE_LADDER then

							v.EndParaTime = nil
							v.Parachuting = false
							umsg.Start( "PARAIsIn" , v )
							umsg.Bool( v.Parachuting )
							umsg.End( )
							v.FlarePara = 1
							v:ViewPunch( Angle( -16 , 0 , 0 ) )
							local ParaLand = ents.Create( "v92_zchute_bf2_land" )
							ParaLand:SetOwner( v )
							ParaLand:SetPos( v:GetPos( ) + v:GetForward( ) * LandedParachute[1] + v:GetRight( ) * LandedParachute[2] + v:GetUp( ) * LandedParachute[3] )
							ParaLand:SetAngles( v:GetAngles( ) + Angle( 0 , 270 , 0 ) )
							ParaLand:Spawn( )
							ParaLand:Activate( )

							LoopingSound:Stop( )

						end

						if v:KeyDown( IN_USE ) and v.FlarePara > 0.4 then

							v.FlarePara = v.FlarePara - 0.005

							if v.FlarePara < 0.4 then
								v.FlarePara = 0.4
							end

						end

						if v:KeyDown( IN_FORWARD ) then

							v:SetLocalVelocity( v:GetForward( ) * ParachuteSpeed[3] * v.FlarePara * 1.1 - v:GetUp( ) * 320 * v.FlarePara )

						elseif v:KeyDown( IN_BACK ) then

							v:SetLocalVelocity( v:GetForward( ) * ParachuteSpeed[1] * v.FlarePara * 1.1 - v:GetUp( ) * 320 * v.FlarePara )

						else

							v:SetLocalVelocity( v:GetForward( ) * ParachuteSpeed[2] * v.FlarePara * 1.1 - v:GetUp( ) * 320 * v.FlarePara )

						end

						if ( v:KeyDown( IN_DUCK ) and v:KeyDown( IN_WALK ) and v.Parachuting == true ) or not ( v:Alive( ) or IsValid( v ) ) then

							v.Parachuting = false
							umsg.Start( "PARAIsIn" , v )
							umsg.Bool( v.Parachuting )
							umsg.End( )
							v.FlarePara = 1
							v:ViewPunch( Angle( -15 , 0 , 0 ) )
							local ParaDitch = ents.Create( "v92_zchute_bf2_abandon" )
							ParaDitch:SetOwner( v )
							ParaDitch:SetPos( v:GetPos( ) + v:GetForward( ) * DitchedParachute[1] + v:GetRight( ) * DitchedParachute[2] + v:GetUp( ) * DitchedParachute[3] )
							ParaDitch:SetAngles( v:GetAngles( ) )
							ParaDitch:Spawn( )
							ParaDitch:Activate( )

							LoopingSound:Stop( )

						end

						if v:OnGround( ) and v.Parachuting == true and not v.EndParaTime then

							v.EndParaTime = CurTime( ) + 0.25
							umsg.Start( "PARAIsIn" , v )
							umsg.Bool( false )
							umsg.End( )
							v:ViewPunch( Angle( 7 , 0 , 0 ) )

							LoopingSound:Stop( )

						end

					end

				end

			end

		end

	end
	hook.Add( "Think" , "ParachuteThink" , ParachuteThink )

end

if CLIENT then

	local function ParachuteZ_Common( pnl )

		pnl:ControlHelp( "Parachute-Z Controls" )

		local Default = {

			["vnt_parachutez_sv_mode"] = 0 ,
			["vnt_parachutez_cl_volume"] = 0.7 ,

		}

		pnl:AddControl( "ComboBox" , { ["MenuButton"] = 1 , ["Folder"] = "parachutez_common" , ["Options"] = { [ "#preset.default" ] = Default } , ["CVars"] = table.GetKeys( Default ) } )

		pnl:NumSlider( "Parachute Mode" , "vnt_parachutez_sv_mode" , -1 , 2 , 0 )
		pnl:ControlHelp( "-1=Disabled, 0=All Users, 1=Admin Only, 2=Super Admin Only" )

		pnl:NumSlider( "Flight Volume" , "vnt_parachutez_cl_volume" , 0.2 , 1 , 1 )

	end

	-- Tool Menu
	hook.Add( "PopulateToolMenu", "PopulateParachuteZMenus", function( )

		spawnmenu.AddToolMenuOption( "Options" , "V92" , "Parachute-Z" , "Parachute-Z" , "" , "" , ParachuteZ_Common )

	end)

	function ParachuteShake( UCMD )

		if LocalPlayer( ).Parachuting == true then

			UCMD:SetViewAngles( ( UCMD:GetViewAngles( ) + Angle( math.sin( RealTime( ) * 35 ) * 0.01 , math.sin( RealTime( ) * 35 ) * 0.01 , 0 ) ) )

		end

	end

	hook.Add( "CreateMove" , "ParachuteShake" , ParachuteShake )

	local function PARAIsIn( um )

		LocalPlayer( ).Parachuting = um:ReadBool( )

	end

	usermessage.Hook( "PARAIsIn" , PARAIsIn )

end