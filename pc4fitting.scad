use <../_utils_v2/fillet.scad>
use <../_utils_v2/threads.scad>
use <../_utils_v2/m3-m8.scad>

base_diameter=12;
function fitting_base_diameter()=base_diameter;
screw_diameter_diameter = base_diameter;
base_length=2;
tube_diameter=4.2+0.2;
screw_length=12;
slot_thickness=1.5;

module pc4_cut(offs=0,fix_cyl_diff=11,fix_cyl_angles=[[10,-90+10]],base_length_add=0)
{
	translate ([0,0,-base_length])
	hull()
	{
		cylinder (d=base_diameter+offs*2,h=base_length+base_length_add+0.01,$fn=80);
		for (a=fix_cyl_angles)
			rotate ([0,0,a[0]])
			translate ([fix_cyl_diff,0,0])
				cylinder (d=6.4+offs*2,h=base_length+base_length_add+0.01,$fn=80);
	}
}

module pc4_pad(fix_cyl_diff=11,fix_cyl_angles=[[10,-90+10]])
{
	nutout=[3,8];
	translate ([0,0,-base_length-nutout[1]])
	hull()
	{
		cylinder (d=base_diameter+nutout[0]*2,h=base_length+nutout[1],$fn=80);
		for (a=fix_cyl_angles)
			rotate ([0,0,a[0]])
			translate ([fix_cyl_diff,0,0])
				cylinder (d=6.4+nutout[0]*2,h=base_length+nutout[1],$fn=80);
	}
}

module pc4_fix(fix_cyl_diff=11,fix_cyl_angles=[[0+10,-90+10]],screw_add=0,capout=0,screw_out=0)
{
	screw=6;
	for (a=fix_cyl_angles)
		rotate ([0,0,a[0]])
		translate ([fix_cyl_diff,0,0])
		rotate ([180,0,0])
		{
			rotate ([180,0,0])
				cylinder (d=m3_screw_diameter(),h=screw_out,$fn=40);
			translate ([0,0,-screw_add])
				m3_screw(h=screw+screw_add,cap_out=capout);
			rotate ([0,0,a[1]])
			translate ([0,0,screw-2])
				m3_square_nut();
		}
}

module pc4_add_thread()
{
	metric_thread (diameter=screw_diameter_diameter, pitch=1.6, length=screw_length, internal=false, n_starts=1,
						  thread_size=2.0, groove=false, square=false, rectangle=0,
						  angle=30, taper=0.2, leadin=1, leadfac=1.0);
}

module pc4_add(fix_cyl_angles=[[0+10,-90+10]],fix_cyl_diff=11,up=0)
{
	if (up>0)
	{
		fillet(r=2,steps=8)
		{
			cylinder(d=base_diameter,h=up,$fn=80);
			pc4_cut(offs=0,fix_cyl_angles=fix_cyl_angles,fix_cyl_diff=fix_cyl_diff);
		}
		translate ([0,0,up-0.01])
			pc4_add_thread();
	}
	else
	{
		pc4_cut(offs=0,fix_cyl_angles=fix_cyl_angles,fix_cyl_diff=fix_cyl_diff);
		translate ([0,0,up-0.01])
			pc4_add_thread();
	}
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

module pc4_sub(fix_cyl_angles=[[0+10,-90+10]],fix_cyl_diff=11,up=0)
{
	translate ([0,0,up-base_length])
	{
		translate ([0,0,-50])
			cylinder (d=tube_diameter,h=100,$fn=80);
		cut1=1;
		translate ([0,0,screw_length+base_length-cut1])
			cylinder (d1=tube_diameter,d2=tube_diameter+cut1,h=cut1,$fn=80);
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
	pc4_fix(fix_cyl_angles=fix_cyl_angles,fix_cyl_diff=fix_cyl_diff);
}

module pc4_nut()
{
	translate ([0,0,4])
	difference()
	{
		cylinder (d=17.33,h=8,$fn=6);
		translate ([0,0,-0.5])
		metric_thread (diameter=base_diameter, pitch=1.6, length=screw_length, internal=true, n_starts=1,
							  thread_size=2.0, groove=false, square=false, rectangle=0,
							  angle=30, taper=0.2, leadin=0, leadfac=1.0);
	}
}

module pc4_add_other(fix_cyl_angles=[[0+10,-90+10]],fix_cyl_diff=11,up=0,base_length_add=0)
{
	cylinder(d=fitting_base_diameter(),h=up,$fn=80);
	pc4_cut(offs=0,fix_cyl_angles=fix_cyl_angles,fix_cyl_diff=fix_cyl_diff,base_length_add=base_length_add);
}

module pc4_sub_other(fix_cyl_angles=[[0+10,-90+10]],fix_cyl_diff=11,screw_add=0, capout=0, screw_out=0)
{
	pc4_fix(fix_cyl_angles=fix_cyl_angles
			,fix_cyl_diff=fix_cyl_diff
			, screw_add=screw_add
			,capout=capout
			, screw_out=screw_out);
}

//pc4_cut(offs=0.2);
up=5;
difference(){pc4_add(up=up);pc4_sub(up=up);}
//pc4_pad();

//pc4_nut();






