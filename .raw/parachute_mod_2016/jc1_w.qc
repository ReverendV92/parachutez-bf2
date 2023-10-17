
$mostlyopaque
$illumposition 0 0 80

$modelname v92/weapons/parachute/justcause_w

$model JustCause jc1_w

$cdmaterials models/v92/weapons/parachute

$surfaceprop carpet
$contents solid

$hboxset default

$sequence idle jc1_w { fps 1 }

$collisionmodel jc1_w {
 $mass 5.0
 $inertia 1.00
 $damping 0.00
 $rotdamping 0.00
}
