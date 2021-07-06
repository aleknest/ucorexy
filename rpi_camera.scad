use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <utils.scad>

body_offs=[0.1,0.1,0.1];
width = 25.1 + body_offs.x*2;
length = 23.8 + body_offs.y*2;
height=1;
height_add=[0.4,0.8];
lens=[6.1,[9.4,9.4,7+0.1]];
lens_cable=2.2;
box=[width+4,length+11+10,11];
box_tr=[0,0.01,-4-2];
plate=[box.x+24.5+20,5,20];

screws=[
	 [21.05/2,9.3]
	,[-21.05/2,9.3]
	,[21.05/2,21.9]
	,[-21.05/2,21.9]
];


jack=[22+0.5,8,2.7];

module wcube(dim)
{
	translate ([-dim.x/2,0,0])
		cube (dim);
}
module cwcube(dim)
{
	translate ([-dim.x/2,0,0])
	{
		translate ([0,dim.y,0])
		rotate ([90,0,0])
		linear_extrude(dim.y)
		polygon(polyRound([
			 [0,0,4]
			,[dim.x,0,4]
			,[dim.x,dim.z,4]
			,[0,dim.z,4]
		],1));
	}
}

module rpi_camera_cut()
{
	difference()
	{
		wcube([width,length,height]);
		for (screw=screws)
			translate ([screw.x,screw.y,box_tr.z-0.01])
			{
				cylinder (d=1.9,h=20,$fn=80);
			}
	}
	
	translate ([0,0,-jack.z])
		wcube([jack.x,jack.y,jack.z+0.01]);
	
	difference()
	{
		union()
		{
			translate ([0,0,-height_add[1]])
				wcube([width,length,height_add[1]+0.1]);
			translate ([0,0,height-0.1])
				wcube([width,length,height_add[0]+0.1]);
		}
	
		for (screw=screws)
			translate ([screw.x,screw.y,-10])
				cylinder (d=4.6,h=20,$fn=80);
	}

	translate ([0,lens[0],height-0.1])
		wcube(lens[1]);
	
	translate ([0,lens[0],height-0.1])
		wcube([lens[1].x,length-lens[0],lens_cable+0.1]);
}

module rpi_camera_body(report=false)
{
	fscrews=[
		 [1*(box.x/2+m3_screw_diameter()),10,0]
		,[-1*(box.x/2+m3_screw_diameter()),10,0]
	];
	difference()
	{
		union()
		{
			difference()
			{
				union()
				{
					fillet (r=2,steps=8)
					{
						translate (box_tr)
							wcube(box);
						translate ([0,box.y,0])
						translate (box_tr)
							cwcube(plate);
					}
					translate (box_tr)
					fillet (r=2,steps=8)
					{
						wcube(box);
						hull()
						for (f=fscrews)
							translate (f)
								cylinder(d=12,h=box.z,$fn=80);
					}
				}
				rpi_camera_cut();
			}
			translate ([-plate.x/2,box.y+plate.y,10])
			translate (box_tr)
			rotate ([0,90,0])
				slot_groove(height=plate.x,enabled=true,big=true);
		}
		
		screw=8;
		translate (box_tr)
		for (f=fscrews)
			translate ([0,0,-0.1])
			translate (f)
			{
				if (report)
				{
					report_m3_washer(screw);
					report_m3_hexnut();
				}
				cylinder(d=m3_screw_diameter(),h=screw+0.1,$fn=80);
				translate ([0,0,screw])
					cylinder(d=m3_washer_diameter(),h=10,$fn=80);
				m3_nut();
			}

		for (x=[-1,1])
		{
			if (report)
				report_m5_point();
			
			translate ([(plate.x/2-7)*x,box.y,10])
			translate (box_tr)
			rotate ([-90,0,0])
				m5n_screw_washer(thickness=5, diff=2, washer_out=6,tnut=true);
		}
	}
}

module rpi_camera_part_cut(offs=0)
{
	translate ([box_tr.x,box_tr.y-0.01-offs,height/2+offs])
		wcube([box.x+20,length+2+0.01,box.z]);
}

module rpi_camera_bottom()
{
	difference()
	{
		rpi_camera_body(report=true);
		rpi_camera_part_cut();
	}
}

module rpi_camera_top()
{
	intersection()
	{
		rpi_camera_body();
		rpi_camera_part_cut(offs=0.1);
	}
}

module rpi_cable_fix()
{
	thickness=1;
	wire=[16+3+2,14,1];
	
	screw_add=6;
	box_width=[wire.x+screw_add+thickness,wire.y,wire.z+thickness*2];
	
	difference()
	{
		translate ([-screw_add,0,0])
		intersection()
		{
			linear_extrude(box_width.z)
			polygon(polyRound([
				 [0,0,box_width.y/2]
				,[box_width.x,0,0]
				,[box_width.x,box_width.y,0]
				,[0,box_width.y,box_width.y/2]
			],40));
			
			
			dim=box_width;
			
			translate ([0,0,dim.z])
			rotate ([-90,0,0])
			linear_extrude(dim.y)
			polygon(polyRound([
				 [0,0,0]
				,[dim.x,0,dim.z/2]
				,[dim.x,dim.z,dim.z/2]
				,[0,dim.z,0]
			],20));
		}
	
		translate ([-100,-1,thickness])
		{
			dim=vec_add(wire,[100,2,0]);
			
			translate ([0,0,dim.z])
			rotate ([-90,0,0])
			linear_extrude(dim.y)
			polygon(polyRound([
				 [0,0,0]
				,[dim.x,0,dim.z/2]
				,[dim.x,dim.z,dim.z/2]
				,[0,dim.z,0]
			],20));
		}
		
		translate ([-screw_add+3.2,box_width.y/2,-50])
			cylinder (d=3.4,h=100,$fn=40);
	}
}

rpi_camera_bottom();
rpi_camera_top();
//rpi_camera_cut();

//rpi_cable_fix();