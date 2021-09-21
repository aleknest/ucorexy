use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>

h=12;
th=h-m6_cap_h();

module leg()
{
	difference()
	{
		translate ([-10,-10,-h])
			cube ([20,20,h]);
		translate([0,0,-th])
			m6n_screw_washer(thickness=th,diff=2, washer_out=20);
		report_m6_washer(10);
	}
}

//leg();

proto_front_slots();
translate ([0,0,-z_slot()/2])
{
	translate_rotate (z_slot_leftfront_tr())
		leg();
	translate_rotate (z_slot_rightfront_tr())
		leg();
	translate_rotate (z_slot_leftback_tr())
		leg();
	translate_rotate (z_slot_rightback_tr())
		leg();
}