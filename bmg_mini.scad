use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <pc4fitting.scad>
use <configuration.scad>

fix_cyl_angles=[[-90,0],[90,180]];
fix_cyl_diff=9;

pc4_tr=[[17,43,10],[0,90,90]];

color ("red")
translate ([-61.19,197.7,0])
	import ("third_party/bmg_mini/top.stl");
	
translate_rotate(pc4_tr)
{
	pc4_cut(offs=0.2,fix_cyl_angles=fix_cyl_angles,fix_cyl_diff=fix_cyl_diff);
	pc4_fix(fix_cyl_angles=fix_cyl_angles,fix_cyl_diff=fix_cyl_diff);
}
//pc4_pad(fix_cyl_angles=fix_cyl_angles,fix_cyl_diff=fix_cyl_diff);

//				up=5;
//				pc4_add(fix_cyl_angles=fix_cyl_angles,fix_cyl_diff=fix_cyl_diff,up=up);
//				pc4_sub(fix_cyl_angles=fix_cyl_angles,fix_cyl_diff=fix_cyl_diff,up=up);
