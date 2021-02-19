use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>
include <../_utils_v2/NopSCADlib/vitamins/stepper_motors.scad>


corr=[5,0,-1.4];
fix_offs=7;
cut_mesh=[13.5,31.5];

module xt90_base()
{
	difference()
	{
		union()
		{
			difference()
			{
				union()
				{
					translate (corr)
					translate ([4,16.5,10.2])
						color ("lime") import ("third_party/XT90ConnectionPlate01.stl");
					difference()
					{
						translate ([-xt90_dim().x/2,20-xt90_dim().y,0])
							cube ([xt90_dim().x,xt90_dim().y,xt90_dim().z]);
							
						translate ([-xt90_dim().x/2,0,0])
						translate ([cut_mesh[0],-1.151,-1])
							cube ([cut_mesh[1],xt90_dim().y,xt90_dim().z+2]);
					
						translate (corr)
						translate ([-11.4,-20,4.7])
							cube ([22,80,11]);
						
					}
				}
				for (z=[-1,1])
					translate ([-xt90_dim().x/2,20-xt90_dim().y,xt90_dim().z*z])
						cube (xt90_dim());
			}
			translate ([-xt90_dim().x/2,10,0])
			rotate ([90,0,90])
				slot_groove(height=cut_mesh[0],enabled=true,big=true);
			
			offs=32;
			translate ([-xt90_dim().x/2+offs,10,0])
			rotate ([90,0,90])
				slot_groove(height=xt90_dim().x-offs,enabled=true,big=true);
		}
		for (x=[-1,1])
		{
			report_m5_point();
			translate ([(xt90_dim().x/2-fix_offs)*x,10,5])
			rotate ([0,180,0])
				m5n_screw_washer(thickness=5, diff=2, washer_out=40, tnut=true);
		}
	}
}

module xt90()
{
	report_xt90();
	translate_rotate(xt90_tr())
		xt90_base();
}

//proto_other_slots();
xt90();