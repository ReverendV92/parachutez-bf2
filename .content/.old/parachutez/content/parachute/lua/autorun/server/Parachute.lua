for _, sFile in pairs( file.Find( "../models/parachute" ) ) do
	resource.AddFile( "models/parachute/" .. sFile )
end
resource.AddFile( "materials/models/parachute/chute.vmt" )
resource.AddFile( "materials/models/parachute/chute.vtf" )

local MaxSpeed = 200 // Maximum speed to drop at. Set to 500 or less if you don't want fall damage.
local SlowDown = 10 // Speed to slow descent at.

local function SetupMove( pPlayer, mMoveData )
	
	local eGround = pPlayer:GetGroundEntity()
	if ( tostring( eGround ) != "[NULL Entity]" ) then
		if ( pPlayer.Parachute != nil && pPlayer.Parachute:IsValid() ) then
			pPlayer.Parachute:Remove()
		end
		pPlayer.Parachute = nil
	end
	
	if ( pPlayer.Parachute != nil ) then
		
		local vVelocity = mMoveData:GetVelocity()
		
		if ( ( vVelocity.z * -1 ) > MaxSpeed ) then
			mMoveData:SetVelocity( vVelocity + Vector( 0, 0, SlowDown ) )
		end
		
	end
	
end
hook.Add( "SetupMove", "Parachute.SetupMove", SetupMove )

local function Toggle( pPlayer )
	
	if ( pPlayer.Parachute == nil ) then
		
		local ePara = ents.Create( "prop_physics" )
			ePara:SetPos( pPlayer:GetPos() + Vector( 0, 0, 100 ) )
			ePara:SetModel( Model( "models/parachute/chute.mdl" ) )
			ePara:SetMoveType( MOVETYPE_NOCLIP )
			// ePara:SetMaterial( "models/debug/debugwhite" )
		ePara:Spawn()
		
		constraint.Weld(
			ePara,
			pPlayer,
			0,
			0,
			0
		)
		
		pPlayer.Parachute = ePara
		
	else
		
		if ( pPlayer.Parachute:IsValid() ) then
			pPlayer.Parachute:Remove()
		end
		pPlayer.Parachute = nil
		
	end
	
end
concommand.Add( "parachute", Toggle )

local function PlayerSay( pPlayer, sText )
	
	if ( string.Left( sText, 10 ) == "/parachute" ) then
		Toggle( pPlayer )
	end
	
end
hook.Add( "PlayerSay", "Parachute.PlayerSay", PlayerSay )
