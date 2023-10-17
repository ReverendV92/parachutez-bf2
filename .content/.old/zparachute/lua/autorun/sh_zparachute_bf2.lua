
AddCSLuaFile( )

sound.Add({	["name"] = "CmbSoldier_ZipLine_Clip" ,
	["channel"] = CHAN_BODY ,
	["volume"] = 1.0 ,
	["level"] = 50 ,
	["pitch"] = { 90, 110 } ,
	["sound"] = { "npc/combine_soldier/zipline_clip1.wav" , "npc/combine_soldier/zipline_clip2.wav" }
} )

sound.Add({	["name"] = "V92_ZP_BF2_Deploy" ,
	["channel"] = CHAN_BODY ,
	["volume"] = 1.0 ,
	["level"] = 75 ,
	["pitch"] = { 105 , 110 } ,
	["sound"] = { "jessev92/bf2/vehicles/parachute_deploy.wav" }
})

sound.Add({	["name"] = "V92_ZP_BF2_Idle" ,
	["channel"] = CHAN_STATIC ,
	["volume"] = 1.0 ,
	["level"] = 75 ,
	["pitch"] = { 105 , 110 } ,
	["sound"] = { "jessev92/bf2/vehicles/parachute_ride_loop.wav" }
})

if SERVER then

	resource.AddWorkshop( "105699464" )

	function ParachuteKey( ply , key )
		if (key == IN_JUMP and ply:IsValid( ) and ply:Alive( )) and not (ply:GetMoveType( ) == MOVETYPE_NOCLIP or ply:InVehicle( ) or ply:OnGround( ) or ply.Parachuting == true or ply:GetVelocity( ).z > -600) then
			ply.EndParaTime = nil
			ply.Parachuting = true
			umsg.Start( "PARAIsIn" , ply )
			umsg.Bool( ply.Parachuting )
			umsg.End( )
			ply.FlarePara = 1
			ply:ViewPunch( Angle( 35 , 0 , 0 ) )
			local Para = ents.Create( "v92_zchute_bf2_active" )
			Para:SetOwner( ply )
			Para:SetPos( ply:GetPos( ) + ply:GetUp( ) * 100 + ply:GetForward( ) * 10 )
			Para:SetAngles( ply:GetAngles( ) )
			Para:Spawn( )
			Para:Activate( )
		end
	end

	hook.Add( "KeyPress" , "ParachuteKey" , ParachuteKey )

	function ParachuteThink( )

		for k , v in pairs( player.GetAll( ) ) do

			if v.Parachuting == true then

				if v.EndParaTime and CurTime( ) >= v.EndParaTime and v:OnGround() == true or v:WaterLevel() > 0 then
					v.EndParaTime = nil
					v.Parachuting = false
					umsg.Start( "PARAIsIn" , v )
					umsg.Bool( v.Parachuting )
					umsg.End( )
					v.FlarePara = 1
					v:ViewPunch( Angle( -16 , 0 , 0 ) )
					local ParaLand = ents.Create( "v92_zchute_bf2_land" )
					ParaLand:SetOwner( v )
					ParaLand:SetPos( v:GetPos( ) + v:GetForward( ) * -100 + v:GetRight( ) * 50 )
					ParaLand:SetAngles( v:GetAngles( ) + Angle( 0 , 270 , 0 ) )
					ParaLand:Spawn( )
					ParaLand:Activate( )

				end

				if v:KeyDown( IN_USE ) and v.FlarePara > 0.4 then
					v.FlarePara = v.FlarePara - 0.005

					if v.FlarePara < 0.4 then
						v.FlarePara = 0.4
					end
				end

				if v:KeyDown( IN_FORWARD ) then
					v:SetLocalVelocity( v:GetForward( ) * 450 * v.FlarePara * 1.1 - v:GetUp( ) * 320 * v.FlarePara )
				elseif v:KeyDown( IN_BACK ) then
					v:SetLocalVelocity( v:GetForward( ) * 300 * v.FlarePara * 1.1 - v:GetUp( ) * 320 * v.FlarePara )
				else
					v:SetLocalVelocity( v:GetForward( ) * 375 * v.FlarePara * 1.1 - v:GetUp( ) * 320 * v.FlarePara )
				end

				if ( v:KeyDown( IN_DUCK ) and v:KeyDown( IN_WALK ) and v.Parachuting == true ) or not ( v:Alive( ) or IsValid( v ) ) then
					v.Parachuting = false
					umsg.Start( "PARAIsIn" , v )
					umsg.Bool( v.Parachuting )
					umsg.End( )
					v.FlarePara = 1
					v:ViewPunch( Angle( -15 , 0 , 0 ) )
					local ParaAB = ents.Create( "v92_zchute_bf2_abandon" )
					ParaAB:SetOwner( v )
					ParaAB:SetPos( v:GetPos( ) + v:GetUp( ) + v:GetForward( ) * 10 )
					ParaAB:SetAngles( v:GetAngles( ) )
					ParaAB:Spawn( )
					ParaAB:Activate( )
				end

				if v:OnGround( ) and v.Parachuting == true and not v.EndParaTime then
					v.EndParaTime = CurTime( ) + 0.25
					umsg.Start( "PARAIsIn" , v )
					umsg.Bool( false )
					umsg.End( )
					v:ViewPunch( Angle( 7 , 0 , 0 ) )
				end

			end

		end

	end

	hook.Add( "Think" , "ParachuteThink" , ParachuteThink )

end

if CLIENT then

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