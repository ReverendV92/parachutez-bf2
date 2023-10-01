//$cd "F:\0-mdl\Decompiled_Props\gta_parachute"
$modelname "jessev92/parachute_gtaiv.mdl"
$model "GTAIV Parachute" "idle.smd"
$bodygroup Chute
{
	studio	chute
	blank
}
$bodygroup Harness
{
	blank
	studio	harness
}
$texturegroup	skinfamilies
{
	"parachute"
	"para_gta_proxy"
}
$cdmaterials "models\jessev92\gtaiv"
$hboxset "default"
$surfaceprop "plastic"
//$keyvalues  { prop_data { "base" "metal.Small"  } } 
$illumposition 0 0 50
$sequence idle "idle" fps 1.00
$collisionmodel "phy.smd" {

	$concave
	$mass 15.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
