

/* [Dimensions] */
//width of the profile slot
opening=5.6;

//thickness of the profile's wall
wallThck=1.8;

//inner width of the profile/nut
inWdth=11.9;

//thickness of the base section
baseThck=1.05;

//thickness of the cone section
coneThck=2;

//nominal screw Diameter M#
screwM=2.5;

//extra spacing for the screw nut
spacing=0.4;
nutChamfer=0.3;




/*  [Hidden] */
fudge=0.1;
ovThck= baseThck+coneThck+wallThck;

$fn=100;


//key-width "S" (DIN 934)
nutS=[
  [2  ,4],
  [2.5,5],
  [3  ,5.5],
  [4  ,7],
  [5  ,8],
  [6  ,10],
  [7  ,11],
  [8  ,13],
  [10  ,17],
  [12  ,19]];
  
ru=(lookup(screwM,nutS)*2)/sqrt(3);

// calculated dias from S
echo("outerDia",ru);

// dias from table DIN 934
nutDias=[
  [2  ,4.32],
  [2.5,5.45],
  [3  ,6.01],
  [4  ,7.66],
  [5  ,8.79],
  [6  ,11.05]];

//thickness "M"
nutThcks=[
  [2  ,1.6],
  [2.5,2],
  [3  ,2.4],
  [4  ,3.2],
  [5  ,4],
  [6  ,5]];

//calculate dia adder for spacing
diaSpcAdd=spacing/cos(30);

//lookup nut Dimensions and calculate side width "a"
nutDia=lookup(screwM,nutDias);
nutThick=lookup(screwM,nutThcks);
a=(nutDia+diaSpcAdd)/2;


translate([0,10-1.85,0])
difference(){
  nutBase();
  //screw drill
  translate([0,wallThck+fudge/2,0]) rotate([90,0,0]) cylinder(d=screwM+spacing,h=ovThck+fudge);
  //screw drill chamfer
  translate([0,wallThck+fudge,0]) rotate([90,0,0]) 
    cylinder(d2=screwM+spacing,d1=screwM+spacing+fudge+nutChamfer,h=nutChamfer+fudge);
  
  // hex nut
  translate([0,-baseThck-coneThck+nutThick]) rotate([90,0,0])
    cylinder(d=nutDia+diaSpcAdd,h=nutThick+fudge,$fn=6);
  // hex nut chamfer
  translate([0,-baseThck-coneThck+nutChamfer]) rotate([90,0,0])
    cylinder(d1=nutDia+diaSpcAdd,d2=nutDia+diaSpcAdd+nutChamfer*2+fudge,h=nutChamfer+fudge,$fn=6);
  // slot  
  translate([0,nutThick/2-fudge/2-coneThck-baseThck]) cube([a,nutThick+fudge,opening+fudge],true);
  // slot chamfer
  translate([0,-coneThck-baseThck+nutChamfer]) rotate([90,0,0]) 
    linear_extrude(nutChamfer+fudge, scale=(a+nutChamfer*2)/a) square([a,opening+fudge],true);
  
}

module nutBase(){
  translate([0,0,]) 
    rotate([-90,0,0]) cylinder(d=opening,h=wallThck);
  
  //rotation stoppers
  for (i=[-1,1]){
    translate([i*opening/4,wallThck/2,i*-opening/4]) cube([opening/2,wallThck,opening/2],true);
    translate([i*inWdth/4,-baseThck/2,i*-opening/4]) cube([inWdth/2,baseThck,opening/2],true);
    rotate([0,i*90,0]) translate([0,-baseThck,0]) rotate([0,90,0]) linear_extrude(opening/2)
      polygon([[-inWdth/2,0],[0,0],[0,-coneThck],[-inWdth/2+coneThck,-coneThck]]);
  }
  
  intersection(){
    translate([0,fudge/2,0]) rotate([90,0,0]) cylinder(d=inWdth,h=baseThck+fudge);
    translate([0,-baseThck/2,]) cube([inWdth,baseThck,opening],true);
  }
  
  intersection(){
    translate([0,-baseThck,0]) rotate([90,0,0]) cylinder(d1=inWdth,d2=inWdth-coneThck*2,h=coneThck);
    translate([0,-coneThck/2-baseThck]) cube([inWdth,coneThck,opening],true);
  }
  
}
