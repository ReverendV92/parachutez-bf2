// Created by Crowbar 0.19.0.0

$modelname "parachute.mdl"

$staticprop

$bodygroup "Body"
{
	studio "parachute_reference.smd"
}


$cdmaterials "models\parachute\"

// Model uses material "Untitled-1.vmt"
// Model uses material "parachute.vmt"

$surfaceprop "plastic"

$contents "solid"

// Only set this if you know what it does, and need it for special circumstances, such as with gibs.
// $illumposition 0.223 -0.887 2.116

// $bbox -52.791 -99.791 -69.38 54.565 100.236 73.611

// $cbox is probably not used anymore
// $cbox 0 0 0 0 0 0

// The hitbox info below was automatically generated when compiled because no hitbox info was provided.
// $hboxset "default"
// $hbox 0 "static_prop" -52.540699 -99.5411 -69.129799 54.314602 99.985901 73.361




$sequence "Idle" "parachute_anims\Idle.smd" {
	fps 30
	"ACT_IDLE" 1
}

