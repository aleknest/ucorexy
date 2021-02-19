use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>

module slot_cover_side(h,up,down,offs)
{
	offs_=3.5;
	dd=0.3;
	linear_extrude(h)
	offset(delta=offs)
		polygon ([
			  [0,-up]
			, [offs_+0.2,-up]
			, [offs_+0.2,0.84]
			, [offs_-0.36,1.63]
			, [offs_-0.2,2.385]
			, [offs_-0.55,3+down]
			, [offs_-1.33,3+down]
			, [offs_-1.33,0.9]
			, [0,0.9]
		]);
}

module slot_cover(h,up=0,down=0)
{
	slot_cover_side(h,up,down,offs=0.0);
	mirror([1,0,0])
		slot_cover_side(h,up,down,offs=0.0);
}

module slot_cover_cut(h,up=0,down=0,offs=0.0)
{
	hull()
	{
		slot_cover_side(h,up,down,offs=offs);
		mirror([1,0,0])
			slot_cover_side(h,up,down,offs=offs);
	}
}

module mgn9_y_stopper()
{
	slot_cover(h=mgn9_y_stopper_h(),up=10,down=2);
}

//mgn9_y_stopper();

//slot_cover(h=150,down=1);//1 pcs
//slot_cover(h=155,down=1);//8pcs outer
//slot_cover(h=230,down=1);
//slot_cover(h=180,down=1);
slot_cover_cut(h=180,down=1,offs=1);

/*
proto_y_left();
translate_rotate(mgn9_y_stopper_tr())
	mgn9_y_stopper();
*/