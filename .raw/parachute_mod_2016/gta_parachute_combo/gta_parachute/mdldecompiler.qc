//$origin 0 0 150 90
$staticprop
$autocenter
$modelname "jessev92/parachute_gtaiv.mdl"
$model "GTAIV" "chute.smd"
$cdmaterials "models\jessev92\gtaiv"
$hboxset "default"
$texturegroup skinfamilies
{
{ "parachute" }
{ "para_gta_proxy" }
}

// Model uses material "bm_e2_parachute.vmt"
$surfaceprop "cloth"
//$keyvalues  { prop_data { "base" "metal.Small"  } } 
$illumposition 17.859 -3.143 27.914
$sequence idle "idle" fps 1.00
$collisionmodel "chute.smd" {

	//$concave
	$mass 15.0
	$inertia 1.00
	$damping 0.00
	$rotdamping 0.00
}
