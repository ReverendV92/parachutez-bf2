
$opaque
$ambientboost

$modelname v92/parachutez/abandoned

$model "ParachuteZ Abandoned" parachute_abandoned

$surfaceprop carpet

$contents solid

$illumposition 0 0 10

$cdmaterials models/v92/parachutez

$texturegroup skinfamilies
{
	{ parachute_bf2_landed }
	{ parachute_bf3_landed }
	{ parachute_bf2142_landed }
	{ parachute_rnl_landed }
	{ parachute_kaos_landed }
	{ parachute_justcause_landed }
	{ parachute_gta4_landed }
	{ parachute_landed }
}

$hboxset default

$sequence idle {
	parachute_abandoned
	activity "ACT_IDLE" 1
	fps 1
}

$collisionmodel parachute_abandoned_physics
{

	$mass 50
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
