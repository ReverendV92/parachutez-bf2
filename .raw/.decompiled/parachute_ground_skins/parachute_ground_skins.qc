// Created by Crowbar 0.74

$modelname "jessev92/codmw2/parachute_ground_skins.mdl"

$bodygroup "MW2ParachuteGrounded"
{
	studio "mesh.smd"
}


$surfaceprop "carpet"

$contents "solid"

$illumposition 0 0 10

$cdmaterials "models\jessev92\mw2\"

$texturegroup "skinfamilies"
{
	{ "parachute"       }
	{ "parachute_bf2"   }
	{ "parachute_kaos"  }
	{ "parachute_gta"   }
	{ "parachute_proxy" }
}

$cbox 0 0 0 0 0 0

$bbox -189.715 -150.806 -0.746 184.052 165.18 16.293

$hboxset "default"

$definebone "Bone01" "" 0 -0.490137 0.248245 0 -89.999982 89.999982 0 0 0 0 0 0


$sequence "idle" {
	"parachute_ground_skins_anims\idle.smd"
	activity "ACT_IDLE" 1
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "parachute_ground_skins_physics.smd"
{
	$mass 50
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
