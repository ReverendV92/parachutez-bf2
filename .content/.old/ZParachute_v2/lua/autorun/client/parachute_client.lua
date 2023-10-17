
function ParachuteShake(UCMD)
	if LocalPlayer().Parachuting == true then
		UCMD:SetViewAngles((UCMD:GetViewAngles() + Angle(math.sin(RealTime()*35) * 0.01, math.sin(RealTime()*35) * 0.01, 0)))
	end
end
hook.Add("CreateMove", "ParachuteShake", ParachuteShake)

local function PARAIsIn( um )	LocalPlayer().Parachuting = um:ReadBool()	end
usermessage.Hook( "PARAIsIn", PARAIsIn )

--	Options Menu 'n Shit

list.Set( "zparachute_model", "#Just Cause", { Material = "vgui/zparachute_justcause", wheelchanger_model = "models/props_vehicles/carparts_wheel01a.mdl" , Value = "Junker" } )

function ZParachuteOptions(Panel)

	local parachute = list.Get( "zparachute_model" )
	local exists = false
	for k,v in pairs( parachute ) do
	
		exists = false
		exists = file.Exists( "materials/"..v.Material..".vmt" , "GAME" )
		
	
		if !exists then
			v.Material = "vgui/entities/noicon"
		end	
	end		
	
	ThaMaterialBox = {}
	ThaMaterialBox.Label = "ZParachute Models"
	ThaMaterialBox.MenuButton = 0
	ThaMaterialBox.Height = 100
	ThaMaterialBox.Width = 100
	ThaMaterialBox.Rows = 6
	ThaMaterialBox.Options = parachute
--print("ZPOptions")
end

function ZParachuteOptionsMenu()	spawnmenu.AddToolMenuOption( "Options", "Lucky9Two", "ZParachuteOpts", "ZParachute", "", "", ZParachuteOptions)	end
hook.Add( "PopulateToolMenu", "ZParachuteOptionsMenu", ZParachuteOptionsMenu)
