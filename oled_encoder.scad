use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/deb.scad>
use <configuration.scad>
use <proto.scad>
use <utils.scad>

part="";

oled_width=27.3;
oled_height=27.75;
screen_width=23;
screen_height=13.5;
thickness=2.4;
thickness_slot=5;
angle=60;
a_angle=90-angle;
zup=oled_encoder_dim().z-oled_encoder_dim().y/tan(angle);
zcut=6.5;
zreal=oled_encoder_dim().z-zcut;
ycut=tan(angle)*zcut;
oe_tr=[[0,0,zup],[a_angle,0,0]];
oled_ptr=[oled_width/2+6,oled_height/2+3,-thickness];
encoder_ptr=[oled_ptr.x+30,oled_ptr.y,0];
slot_ptr=[oled_encoder_dim().x-thickness_slot-20,oled_encoder_dim().y,0];
screw_offset=m3_cap_diameter()/2+1;
screw=6;
screw_coords=[
	 [screw_offset,screw_offset,0]
	,[oled_encoder_dim().x-screw_offset,screw_offset,0]
	,[oled_encoder_dim().x-screw_offset,oled_encoder_dim().y-screw_offset,0]
	,[screw_offset,oled_encoder_dim().y-screw_offset,0]
];

function stand_tr(x,y)=[(oled_width/2-2.1-2.5/2)*x,(oled_height/2-2.1)*y-0.3,0];

module oled(op,thickness=3)
{
	screw=10;
	oled_screw_d=2.5+0.2;
	oled_stand=1.3+0.5;
	if (op==1)
	{
		translate ([-oled_width/2,-oled_height/2,0])
			cube ([oled_width,oled_height,thickness]);
		for (x=[-1,1])
			for (y=[-1,1])
				translate ([0,0,-oled_stand+0.01])
				translate (stand_tr(x,y))
					cylinder (d=oled_screw_d+0.8*2,h=oled_stand+0.02,$fn=40);
	}
	
	if (op==2)
	{
		translate ([0,1.5-0.5,0])
		translate ([-screen_width/2,-screen_height/2,0])
		{
			zz=2;
			out=3;
			translate ([0,0,-0.1])
				cube ([screen_width,screen_height,zz+0.2]);
			hull()
			{
				translate ([0,0,zz])
					cube ([screen_width,screen_height,0.01]);
				translate ([-out,-out,zz+out])
					cube ([screen_width+out*2,screen_height+out*2,0.01]);
			}
		}

		wire_width=14;
		wire_height=3;
		translate ([0,10,0])
		translate ([-wire_width/2,0,0])
		{
			translate ([0,0,-0.1])
				cube ([wire_width,wire_height,1.0]);
		}
	
		screw=10;
		for (x=[-1,1])
			for (y=[-1,1])
				translate (stand_tr(x,y))
				{
					translate ([0,0,-oled_stand])
						cylinder (d=oled_screw_d,h=screw+10,$fn=20);
					out=1.8;
					translate ([0,0,thickness-out])
						cylinder (d1=oled_screw_d,d2=oled_screw_d+out*2,h=out+0.01,$fn=20);
				}
	}
}

module encoder(op)
{
	hh=8-2;
	if (op==1)
	{
		dd=17;
		hull()
		{
			cylinder (d=dd,h=hh,$fn=80);
			translate ([-dd/2,dd/2,0])
				cube ([dd,0.1,hh]);
		}
	}
	translate ([0,0,-2])
	if (op==3)
	{
		translate ([0,0,4])
			cylinder (d=15,h=0.4,$fn=80);
	}
	if (op==2)
	{
		translate ([0,0,-0.1])
			cylinder (d=15,h=4.1,$fn=80);
		cylinder (d=7.5,h=10,$fn=80);
		
		cut=[2.5,1.01,1.1];
		rotate ([0,0,90])
		translate ([-cut.x/2,5.5,hh-cut.z+0.1])
			cube (cut);
	}
}

module base(offs=0,down=0)
{
	translate ([offs,0,0])
	rotate ([90,0,90])
	linear_extrude (oled_encoder_dim().x-offs*2)
	offset (delta=-offs)
	polygon ([
		 [0,-down]
		,[oled_encoder_dim().y,-down]
		,[oled_encoder_dim().y,zreal]
		,[oled_encoder_dim().y-ycut,zreal]
		,[0,zup]
	]);
}

module oled_encoder(report=false,wire=false)
{
	if (report)
	{
		for (i=[0:3])
		{
			report_m2p5_screw_din (8,"DIN965");
			report_m2p5_hexnut ();
		}
		for (i=[0:3])
			report_m3(screw=6);
		deb(str("0.96 oled screen"));
		deb(str("Encoder module"));
	}
	
	difference()
	{
		union()
		{
			difference()
			{
				base();
				base(offs=thickness,down=0);
			}
			
			translate (slot_ptr)
			{
				translate ([0,0,thickness])
					cube ([thickness_slot,20,zreal-thickness]);
				translate ([thickness_slot,10,thickness])
				rotate ([0,0,90])
					slot_groove(height=zreal-thickness,enabled=true,big=true);
			}
			
			for (c=screw_coords)
				intersection()
				{
					translate (c)
						cylinder (d=6,h=oled_encoder_dim().z-0.01,$fn=60);
					base();
				}
	
			translate_rotate (oe_tr)
			translate (oled_ptr)
				oled(op=1,thickness=thickness);
			
			translate_rotate (oe_tr)
			translate (encoder_ptr)
			rotate ([0,180,0])
				encoder(op=1);
		}
		
		if (report)
			report_m5_point();
		translate (slot_ptr)
		translate ([0,10,zreal/2])
		rotate ([0,90,0])
			m5n_screw_washer(thickness=thickness_slot, diff=2, washer_out=40,tnut=true);
		
		for (c=screw_coords)
			translate (c)
			translate ([0,0,-0.01])
			{
				dd=3;
				sscrew=screw+1;
				cylinder (d=dd,h=sscrew,$fn=60);
				translate ([0,0,sscrew-0.01])
					cylinder (d1=dd,d2=0,h=dd/2,$fn=60);
			}
	
		translate_rotate (oe_tr)
		translate (oled_ptr)
			oled(op=2,thickness=thickness);
		translate_rotate (oe_tr)
		translate (encoder_ptr)
		rotate ([0,180,0])
			encoder(op=2);
		
		if (wire)
		{
			wd=4;
			hull()
			for (z=[0,10])
				translate ([oled_encoder_dim().x-20-thickness_slot-wd/2,oled_encoder_dim().y-thickness-0.1,z])	
				rotate ([-90,0,0])
					cylinder (d=wd,h=thickness+0.2,$fn=40);
		}
	}
}
module oled_encoder_cut(offs)
{
	translate ([-1,-1+offs,-1+offs])
		cube ([oled_encoder_dim().x+2,oled_encoder_dim().y+1,thickness+1]);
}
module oled_encoder_top()
{
	translate_rotate(oled_encoder_tr())
	difference()
	{
		oled_encoder(report=true,wire=true);
		oled_encoder_cut(offs=0.1);
	}
}
module oled_encoder_bottom()
{
	translate_rotate(oled_encoder_tr())
	intersection()
	{
		oled_encoder();
		oled_encoder_cut(offs=0.1);
	}
}

module encoder_knob_body(d,h)
{
	r=4;
	//#cylinder (d=d,h=h,$fn=100);
	difference ()
	{
		minkowski()
		{
			cylinder (d=d-r*2,h=h-r,$fn=100);
			sphere (r=r,$fn=100);
		}
		rotate ([180,0,0])
			cylinder (d=d+1,h=r+1);
	}
}

module encoder_knob()
{
	down_knob=2.5+1;
	difference ()
	{
		dd=22;
		translate ([0,0,-down_knob])
		encoder_knob_body(d=dd,h=14+down_knob);
		rays=32;
		angle=360/rays;
		for (a=[0:rays-1])
			rotate ([0,0,a*angle])
			translate ([dd/2,0,-20])
				cylinder(d=1,h=50,$fn=40);
		
		translate ([0,0,-0.01])
		difference ()
		{
			translate ([0,0,-down_knob])
				cylinder (d=6.2,h=13+down_knob,$fn=100);
			translate ([-10,1.7,-0.01])
				cube ([20,20,20]);
		}
	}
}

//proto_front_slots();
//oled_encoder_top();
//oled_encoder_bottom();
//encoder_knob();

oled_encoder(report=true,wire=true);