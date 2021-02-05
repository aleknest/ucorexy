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
	union()
	{
		translate ([-32.4,-0.725,0])
			color ("lime") import ("third_party/WagoPowerBracketSplitV15_cutted.stl");
		w=6;
		h=34;
		
		x=14.3;
		d=12;
		hh=4;
		for (m=[0,1])
		mirror([m,0,0])
		translate ([x,h/2,0])
		{
			difference()
			{
				hull()
				{
					translate ([0,-d/2,0])
						cube ([0.1,d,hh]);
					translate ([d/2,0,0])
						cylinder (d=d,h=hh,$fn=60);
				}
				translate ([d/2,0,hh])
				rotate ([0,180,0])
				{
					screw=10;
					report_m3_washer_hexnut(screw);
					m3_screw(screw);
					m3_washer(out=60);
				}
			}
		}
	}
}

module wago()
{
	report_wago();
	report_wago();
	translate_rotate(wago_tr())
		wago_base();
}

include <enclosure.scad>
enclosure_floor(printable=true);
wago();
