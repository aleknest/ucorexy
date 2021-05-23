use <../_utils_v2/_round/polyround.scad>

length=4;
fix=[1.7+0.1,0.2,0.6];

module shape()
{
	w=6.2/2-0.1;
	w2=7/2-0.1;
	h=5;
	h2=0.4;
	polygon (polyRound([
		 [0,0,0]
		,[w,0,2]
		,[w,h+h2-fix[0]-fix[2],0]
		,[w+fix[1],h+h2-fix[0]-fix[2],0.4]
		,[w+fix[1],h+h2-fix[0],0.4]
		,[w,h+h2-fix[0],0]
		,[w,h,0]
		,[w2,h,0]
		,[w2,h+h2,0]
		,[0,h+h2,0]
	],20));
}

union()
{
	linear_extrude(length)
		shape();
	mirror([1,0,0])
		linear_extrude(length)
			shape();
}