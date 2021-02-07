use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>

module slot_cover_side(h,up,down)
{
	offs=3.5;
	dd=0.3;
	linear_extrude(h)
	polygon ([
		  [0,-up]
		, [offs+0.2,-up]
		, [offs+0.2,0.84]
		, [offs-0.36,1.63]
		, [offs-0.2,2.385]
		, [offs-0.55,3+down]
		, [offs-1.33,3+down]
		, [offs-1.33,0.9]
		, [0,0.9]
	]);
}

module slot_cover(h,up=0)
{
	down=2;
	slot_cover_side(h,up,down);
	mirror([1,0,0])
		slot_cover_side(h,up,down);
}

module mgn9_y_stopper()
{
	slot_cover(h=7.5,up=10);
}

mgn9_y_stopper();
//slot_cover(h=7);