-- Added a command to check wether or not we have a parachute

hook.Add( "PlayerSay", "DGDoWeHaveAParachute", function( ply, text )
    if ( string.lower( text ) == "/para" ) then
        if ply.has_parachute then 
            ply:ChatPrint("You have a parachute")
        else 
            ply:ChatPrint("You don't have a parachute")
        end
        return ""
    end
end )

-- Prevent keeping the parachute after dying
hook.Add("PlayerDeath", "DGRemoveParachutesOnDeath", function(ply)
    if !IsValid(ply) then return end 
    if ply.has_parachute then 
        ply.has_parachute = false
    end
end)
-- Prevent keeping the parachute after switching team
hook.Add("PlayerLoadout", "DGRemoveParachuteOnLoadout", function(ply)
    if !IsValid(ply) then return end 
    if ply.has_parachute then 
        ply.has_parachute = false
    end
end)