use <../_utils_v2/fillet.scad>
use <../_utils_v2/threads.scad>

base_diameter=12;
function fitting_base_diameter()=base_diameter;
screw_diameter_diameter = base_diameter;
base_length=2;
tube_diameter=4.5;
screw_length=12;
slot_thickness=1.5;

middle_to_nut_height=2;
screw_height=7;
middle_height=11+10+middle_to_nut_height;
nut_height=4;
fix_height=screw_height+nut_height+middle_height;

module e3d_fitting_nut()
{
	translate ([0,0,fix_height])
	difference()
	{
		dd=17.33;//-2.6;
		hh=8;
		cylinder (d=dd,h=hh,$fn=6);
		translate ([0,0,-0.5])
		metric_thread (diameter=base_diameter, pitch=1.6, length=screw_length, internal=true, n_starts=1,
							  thread_size=2.0, groove=false, square=false, rectangle=0,
							  angle=30, taper=0.2, leadin=0, leadfac=1.0);
	}
}
module pc4_add()
{
	metric_thread (diameter=screw_diameter_diameter, pitch=1.6, length=screw_length, internal=false, n_starts=1,
						  thread_size=2.0, groove=false, square=false, rectangle=0,
						  angle=30, taper=0.2, leadin=1, leadfac=1.0);
}

module pc4_sub_slot()
{
	for (a=[60,180,300])
	rotate ([0,0,a])
	translate ([0,0,base_length])
	{
		cut=0.5;
		cut_offs=0.18;
		linear_extrude(40)
		polygon([
			 [-slot_thickness/2-cut/2,0]
			,[-slot_thickness/2-cut/2,tube_diameter/2-cut+cut_offs]
			,[-slot_thickness/2,tube_diameter/2+cut_offs]
			,[-slot_thickness/2,20]
			,[slot_thickness/2,20]
			,[slot_thickness/2,tube_diameter/2+cut_offs]
			,[slot_thickness/2+cut/2,tube_diameter/2-cut+cut_offs]
			,[slot_thickness/2+cut/2,0]
		]);
	}
}

module pc4_sub_filament()
{
	cut1=1;
	translate ([0,0,-base_length])
	translate ([0,0,-50])
	{
		cylinder (d=tube_diameter,h=100,$fn=80);
	}
	translate ([0,0,screw_length-cut1+0.01])
		cylinder (d1=tube_diameter,d2=tube_diameter+cut1,h=cut1,$fn=80);
}
module pc4_sub()
{
	translate ([0,0,-base_length])
	{
		pc4_sub_slot();
		cut2=0.6;
		intersection()
		{
			translate ([0,0,base_length-cut2])
				cylinder (d1=tube_diameter,d2=tube_diameter+cut2,h=cut2+0.01,$fn=80);
			translate ([0,0,-10])
				pc4_sub_slot();
		}
	}
}

module e3d_fitting()
{
	difference()
	{
		union()
		{
			translate ([0,0,screw_height])
			rotate ([0,180,0])
				metric_thread (diameter=10, pitch=1, length=screw_height, leadin=1);

			translate ([0,0,screw_height+middle_height])
				cylinder (d=14,h=nut_height,$fn=6);
			
			fillet (r=0.5,steps=4)
			{
				translate ([0,0,screw_height])
					cylinder (d=11,h=middle_height,$fn=60);
	
				translate ([0,0,screw_height+middle_height])
				hull()
				{
					cylinder (d=14,h=0.01,$fn=6);
					translate ([0,0,-middle_to_nut_height])
						cylinder (d=11,h=0.1,$fn=60);
				}
			}

			translate ([0,0,fix_height])
			difference()
			{
				pc4_add();
				pc4_sub();
				pc4_sub_filament();
			}
		}
		per=[screw_height,20];
		translate ([0,0,-1])
		{
			cylinder (d=tube_diameter,h=per[0],$fn=50);
			translate ([0,0,per[0]+0.2])
				cylinder (d=3.2,h=per[0]+per[1],$fn=50);
			translate ([0,0,per[0]+per[1]])
				cylinder (d=tube_diameter,h=50,$fn=50);
		}
	}
}

e3d_fitting();
//e3d_fitting_nut();

//ptfe 51