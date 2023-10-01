
$opaque

$modelname v92/bf2/vehicles/air/parachute/parachute
$model BF2 mesh

$cdmaterials models/v92/bf2/vehicles/air/parachute

$illumposition 0 0 80
$surfaceprop carpet
$contents solid
$hboxset default

$sequence idle mesh { fps 1 }

$collisionmodel	phy	{
	$mass 5
	$inertia 1
	$damping 0
	$rotdamping 0
}
