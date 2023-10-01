
$scale 4
$staticprop
//$autocenter
$opaque
$origin 0 0 80 180
$illumposition	0 0 80
$modelname		jessev92/bf2/parachute
$model	BF2		ref
$cdmaterials	models/jessev92/bf2
$cdmaterials	models/jessev92/bf2/items
$cdmaterials	models/jessev92/bf2/weapons
$surfaceprop	carpet
$contents		solid
$hboxset		default
$sequence	idle	idle	{	fps	30	loop	}
$sequence	deploy	deploy	{	fps 30	}
$sequence	collapse	collapse	{	fps 30	}
$collisionmodel	phy	{
	$mass 5.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
