use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>
include <../_utils_v2/NopSCADlib/vitamins/stepper_motors.scad>

module wago_base()
{
	translate ([-32.4,-0.725,0])
		color ("lime") import ("third_party/WagoPowerBracketSplitV15_cutted.stl");
}

module wago()
{
	report_wago();
	report_wago();
	for (i=[0,1])
		report_m3_washer_hexnut(10);
	
	translate_rotate(wago_tr())
		wago_base();
}

//include <enclosure.scad>
//enclosure_floor(printable=true);
wago();
