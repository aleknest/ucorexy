use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/_round/polyround.scad>
use <utils.scad>

plate_up=2;
thickness=[2,1,2];
plate_fixin=1;
plate_z=16;
plate = [32+0.6,16+0.8,plate_z+plate_fixin];
box=[plate.x+thickness.x*2,plate.y+thickness.y*2];
screw=[box.x/2-1,0,-0.01];
thermocouple_z_border=7;
thermocouple_cut=[thickness.z+plate_fixin+thermocouple_z_border,16.3,plate_z-thermocouple_z_border];
spi_z_border=2;
spi_cut=[thickness.z+plate_fixin+spi_z_border,15,100-spi_z_border];


module max6675_cube(dim,r=2)
{
	translate ([0,-dim.y/2,0])
	{
		linear_extrude(dim.z)
			polygon(polyRound([
				 [0,0,r]
				,[dim.x,0,r]
				,[dim.x,dim.y,r]
				,[0,dim.y,r]
			],20));
	}
}

module max6675_base(dim)
{
	union()
	{
		max6675_cube(dim);
		
		ww=1.4;
		for (mm=[0:1])
		for (xx=[0:4])
			translate ([4.2+6*xx,0,0])
			{
				mirror([0,mm,0])
				translate ([0,-box.y/2-ww,0])
				{
					dimr=[3,ww,dim.z];
					linear_extrude(dimr.z)
						polygon(polyRound([
							 [0,0,1]
							,[dimr.x,0,1]
							,[dimr.x,dimr.y,0]
							,[0,dimr.y,0]
						],20));
				}
			}
	}
}

module max6675_body(op=1)
{	
	hh=op==1?plate.z+thickness.z-0.01:thickness.z;
	dim=[box.x,box.y,hh];
	dimi=[box.x-thickness.x*2,box.y-thickness.y*2,hh];
	dimf_offset=0.4;
	dimf=[box.x-thickness.x*2-dimf_offset*2,box.y-thickness.y*2-dimf_offset*2,thickness.z+plate_fixin];
	
	mirror([op==1?0:1,0,0])
	difference() 
	{
		union()
		{
			difference() 
			{
				max6675_base(dim);
				translate ([thickness.x,-dimi.y/2,thickness.z])
					cube (dimi);
			}
			if (op==1)
			{
				ww=22;
				translate([screw.x,screw.y,0])
				{
					translate ([-ww/2,-box.y/2,0])
						cube ([ww,box.y,thickness.z+plate_up]);
				}
			}
			if (op==2)
			{
				bd=14;
				bh=thickness.z+3;
				translate([screw.x,screw.y,0])
					cylinder (d=7.6,h=thickness.z+plate.z-3,$fn=100);
				translate ([thickness.x+dimf_offset,-dimf.y/2,0])
					cube (dimf);
			}
		}
		if (op==1)
		{
			translate(screw)
			{
				m3_screw(h=100);
				m3_nut();
			}
			
			for (item=[[plate.x+thickness.x,thermocouple_cut],[0,spi_cut]])
			{
				cut=item[1];
				translate ([item[0],0,0])
				translate ([-0.1,-cut[1]/2,cut[0]])
					cube ([thickness.x+0.2,cut[1],cut[2]]);
			}
		}
		if (op==2)
		{
			translate(screw)
			translate ([0,0,m3_cap_h()])
			{
				m3_screw(h=100);
			}
		}
	}
}

max6675_body(op=1);
//max6675_body(op=2);

