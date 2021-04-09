use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/_round/polyround.scad>
use <utils.scad>

filamentDiameter = 2.2;
ptfeDiameter = 4;
bottomHeight = 2;
switchLength = 13;
switchHeight = 5.8;
switchWidth = 7.5;

switch_tr=[7,-switchWidth,bottomHeight];
length=40;
width=15;
box=[switchLength+8,10.8,switchHeight];
height=switchHeight/2+bottomHeight;
filament_y=-10;
filament_z=bottomHeight+switchHeight/2;
filament_cut=[2,3];
fitting=[6-0.2,7,8];

module filament_cut()
{
	translate([switch_tr.x+box.x-0.01,filament_y,filament_z])
	rotate([0, 90, 0])
		cylinder(d1=filamentDiameter+filament_cut[0],d2=filamentDiameter,h=filament_cut[0],$fn=60);
}

module fitting_add(offs=0)
{
	translate ([length-fitting[1]-offs,filament_y,filament_z])
	rotate ([0,90,0])
	{
		cylinder (d=fitting[2]+offs*2,h=fitting[1]+offs*2,$fn=60);
		sphere (d=fitting[2]+offs*2,$fn=60);
	}
}

module filament_runout_body(op=1)
{	
	mirror([op==1?0:1,0,0])
	union()
	{
		difference() 
		{
			hh=op==1?bottomHeight+switchHeight-0.01:bottomHeight;
			union()
			{
				translate ([0,-width,0])
				{
					dim=[length,width,hh];
					//cube (dim);
					linear_extrude(dim.z)
						polygon(polyRound([
							 [0,0,2]
							,[dim.x,0,2]
							,[dim.x,dim.y,2]
							,[0,dim.y,2]
						],20));
				}
				
				ww=1.4;
				for (mm=[0:1])
				for (xx=[0:5])
					translate ([3.4+6*xx,0,0])
					translate ([0,-width/2,0])
					{
						mirror([0,mm,0])
						translate ([0,-width/2-ww,0])
						{
							dim=[3,ww,hh];
							linear_extrude(dim.z)
								polygon(polyRound([
									 [0,0,1]
									,[dim.x,0,1]
									,[dim.x,dim.y,0]
									,[0,dim.y,0]
								],20));
						}
					}
				
				if (op==1)
					fitting_add();
			}
			if (op==2)
				fitting_add(offs=0.2);
		
			//switch cutout
			translate (switch_tr)
	  			cube([switchLength, switchWidth + 10, switchHeight]);
			fillet (r=1.6,steps=16)
			{
				translate (switch_tr)
				translate([0,4.9-box.y, 0])
				{
					linear_extrude(box.z)
						polygon(polyRound([
							 [0,0,0]
							,[box.x,0,1]
							,[box.x,box.y,0]
							,[0,box.y,0]
						],20));
				}
				filament_cut();
			}
		  
			union()
			{
				translate([-0.01,filament_y,filament_z])
				rotate([0, 90, 0])
					cylinder(d1=filamentDiameter+filament_cut[1],d2=filamentDiameter,h=filament_cut[1],$fn=60);

				fillet (r=0.4,steps=4)
				{
					translate([-1,filament_y,filament_z])
					rotate([0, 90, 0])
						cylinder(d=filamentDiameter,h=length+2,$fn=60);
					filament_cut();
				}
				
				translate ([length-fitting[1],filament_y,filament_z])
				rotate ([0,90,0])
					cylinder (d=fitting[0],h=fitting[1]+0.1,$fn=60);
			}
			
			for (xx=[3.5,length-7])
			translate ([xx,-4,-0.1])
			{
				cylinder(d=m3_screw_diameter(),h=40,$fn=40);
				if (op==1)
					rotate ([0,0,90])
						m3_nut_inner();
			}
		}
		
		//switch fix
		switchfix=[1.2,0.4,1.85];
		switchfix_d = 1.6;
		for (xx=[switch_tr.x+3,switch_tr.x+switchLength-3])
			translate([xx,-switchfix.z,0])
			{
				cylinder(d=switchfix_d, h=bottomHeight+switchfix.x,$fn=40);
				translate ([0,0,bottomHeight+switchfix.x-0.01])
					cylinder(d1=switchfix_d,d2=switchfix_d-switchfix.y*2, h=switchfix.y,$fn=40);
			}			
	}
}

module filament_runout_fix()
{
	dim=[14,8];
	slotp=6.4+0.1;
	slotw=1;
	th=5;
	th_cone=11;
	d_small=[2.8,[0.3,1.0]];
	cut=[0.2,0.4,0.5];
	difference()
	{
		difference()
		{
			union()
			{
				translate ([-dim.x/2,-dim.y/2,0])
				{
					r=2;
					linear_extrude(th)
						polygon(polyRound([
							 [0,0,r]
							,[dim.x,0,r]
							,[dim.x,dim.y,r]
							,[0,dim.y,r]
						],20));
				}
				translate ([-slotp/2,-dim.y/2,th])
					intersection()
					{
						cdim=[slotp,dim.y,5];
						
						translate ([0,cdim.y,0])
						rotate ([90,0,0])
							linear_extrude(cdim.y)
								polygon(polyRound([
									 [cdim.x-cut[0],0,0]
									,[cdim.x-cut[0],cut[1],0]
									,[cdim.x,cut[1]+cut[2],0]
									,[cdim.x,cdim.z,1]
									,[0,cdim.z,1]
									,[0,cut[1]+cut[2],0]
									,[cut[0],cut[1],0]
									,[cut[0],0,0]
								],20));
						
						rotate ([90,0,90])
							linear_extrude(cdim.x)
								polygon(polyRound([
									 [0,0,0]
									,[cdim.y,0,0]
									,[cdim.y,cdim.z,1]
									,[0,cdim.z,1]
								],20));
						
						translate ([0,cdim.y,0])
						rotate ([90,0,0])
							linear_extrude(cdim.y)
								polygon(polyRound([
									 [0,0,0]
									,[cdim.x,0,0]
									,[cdim.x,cdim.z,1]
									,[0,cdim.z,1]
								],20));
					}
			}
			translate ([-slotw/2,-dim.y/2-0.01,th])
				cube ([slotw,dim.y+0.02,10]);
			translate ([0,0,-0.1])
			difference()
			{
				hh=20;
				cylinder(d=d_small[0],h=hh,$fn=60);
				for (a=[0,180])
					rotate ([0,0,a])
					translate ([d_small[0]/2-d_small[1].x,-d_small[1].y/2,0])
						cube ([d_small[1].x,d_small[1].y,hh]);
			}
		}
		translate ([0,0,-0.1])
			cylinder(d1=3.8,d2=0.1,h=th_cone,$fn=60);
	}
}

//filament_runout_body(op=1);
filament_runout_body(op=2);
//filament_runout_fix();