
$opaque

$modelname v92/parachutez/flying
$bodygroup ParachuteZ
{
	studio parachute-bf2
	studio parachute-bf3
	studio parachute-bf2142
	studio parachute-rnl
	studio parachute-kaos
	studio parachute-jc
	studio parachute-gta4
}

$cdmaterials models/v92/parachutez

$illumposition 0 0 80
$surfaceprop carpet
$contents solid
$hboxset default

$sequence idle parachute-bf2 { fps 1 }

$collisionmodel	parachute-bf2_physics	{
	$mass 5
	$inertia 1
	$damping 0
	$rotdamping 0
}
