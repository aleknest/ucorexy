use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>

module enclosure_floor(printable=false)
{
	union()
	{
		difference()
		{
			translate_rotate(enclosure_tr())
				cube (enclosure_dim());
		
			for (x=[0:enclosure_holes_count().x-1])
			for (y=[0:enclosure_holes_count().y-1])
				translate_rotate(enclosure_tr())
				translate ([enclosure_holes_offset()+x*enclosure_holes_interval().x
						,enclosure_holes_offset()+y*enclosure_holes_interval().y,-0.01])
				{
					cylinder (d=m3_screw_diameter(),h=enclosure_dim().z+0.02,$fn=20);
					//rotate ([0,0,45])
					//	m3_nut(h=0.5);
				}
		}
		
		if (printable)
		{
			layer=0.3;
			d=10;
			translate_rotate(enclosure_tr())
			translate ([0,0,enclosure_dim().z-layer])
			{
				for (x=[0,enclosure_dim().x])
				for (y=[0,enclosure_dim().y])
					translate ([x,y,0])
						cylinder(d=d,h=layer,$fn=80);
			}
		}
	}
}

module enclosure_floor_fix()
{
	out=4;
	dim=[10,out+15.5,20-enclosure_offsets().z-enclosure_dim().z];
	fix=[out/*,out+enclosure_holes_interval().y*/];
	fix_m5=dim.y-6.5;
	translate_rotate(enclosure_tr())
	translate([-enclosure_offsets().x,enclosure_holes_offset()-out,enclosure_dim().z])
	{
		difference()
		{
			union()
			{
				cube (dim);
				
				translate ([0,0,dim.z-10])
				rotate([0,90,90])
					slot_groove(height=dim.y, enabled=true, big=true);
			}
			
			translate ([5,fix_m5,dim.z-10])
			rotate ([0,-90,0])
			rotate ([0,0,180])
			{
				report_m5_point();
				m5n_screw_washer(thickness=5,diff=2,washer_out=14,tnut=true,cap_only=true,washer_side_out=10);
			}
			
			screw=10;
			for (f=fix)
				translate ([enclosure_holes_offset()+enclosure_offsets().x,f,screw-enclosure_dim().z-2])
				rotate ([180,0,0])
				{
					report_m3(screw);
					report_m3_hexnut();
					m3_screw(h=screw,cap_out=20);
				}
		}
	}
}

module enclosure_spacer_raspberrypi()
{
	h=5;
	d=[4.5,3];
	difference()
	{
		cylinder(d=d[0],h=h,$fn=60);
		translate ([0,0,-1])
			cylinder(d=d[1],h=h+2,$fn=60);
	}
}

module enclosure_spacer_ramps()
{
	h=2.5;
	d=[5,3.6];
	difference()
	{
		cylinder(d=d[0],h=h,$fn=60);
		translate ([0,0,-1])
			cylinder(d=d[1],h=h+2,$fn=60);
	}
}

//proto_front_slots();
//proto_back_slots();
//proto_other_slots();

enclosure_floor(printable=true);
enclosure_floor_fix();
//enclosure_spacer_raspberrypi();
//enclosure_spacer_ramps();