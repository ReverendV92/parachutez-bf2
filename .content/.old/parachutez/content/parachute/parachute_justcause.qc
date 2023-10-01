
$mostlyopaque

$modelname JesseV92/justcause/items/parachute
$model "Just Cause" mesh

$cdmaterials models/jessev92/justcause
$cdmaterials models/jessev92/justcause/items
$cdmaterials models/jessev92/justcause/items/parachute
$cdmaterials models/jessev92/justcause/weapons
$cdmaterials models/jessev92/justcause/weapons/parachute

$hboxset default
$surfaceprop carpet

$sequence idle mesh fps	30

$collisionmodel	phy	{

	$concave
	$mass 10.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
