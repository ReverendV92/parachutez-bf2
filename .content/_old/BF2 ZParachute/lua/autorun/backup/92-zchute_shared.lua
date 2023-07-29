
--[[

/*
Get the Fuck Out of this Code

ZParachute @ Zoey
BF2 Redux @ Jesse V92
Model @ Nirrti
*/

AddCSLuaFile("client/92-zchute_cl.lua")

include("server/92-zchute_sv.lua")

MsgN("\n\n- ZParachute by Zoey\n- BF2 Parachute Prop by Nirrti\n- BF2 Project by Jesse V92\n\n")

local ply = LocalPlayer();

if not ValidEntity( ply ) then
	return
end

-- thanks to Nirrti for porting the BF2 parachute the right way
/*
models\Nirrti\BFP4F\Items\parachute.mdl
models\Nirrti\BFP4F\Items\parachute.phy
models\Nirrti\BFP4F\Items\parachute.vvd
models\Nirrti\BFP4F\Items\parachute.sw.vtx
-- leave these out because no one runs with -dx8 or -dx9 anymore unless theyre a fag
--models\Nirrti\BFP4F\Items\parachute.dx80.vtx
--models\Nirrti\BFP4F\Items\parachute.dx90.vtx
*/


-- NO DOWNLOAD FOR YOU!

]]
