/*
 Simple knob for rotary encoder.

 Author: tsw 
*/

//Disable $fn and $fa
$fn=0;
$fa=0.01;

// fine 
$fs=0.5;

// settings for the knob
// height of the knob
height = 13;
// width
width = 46;
// chamfer amount for the top larger value => more chamfer
chamfer = 0.1;
// tolerance for the shaft, larger => looser fit
shaft_tolerance = 0; //.15;

// Ridges around the body?
ridge = 0;
// how many ridges
ridges = 73;
// rim at the bottom? (nice with ridges)
rim = 0;
// knurling with the excellent knurledfinish library by aubenc (included at the bottom of this file)
knurling = 1;

hole = 1;

d_shaft = 0;

/*
* create a ridge around the body for better grip
*/
module ridge(ridges, outerRadius, innerRadius) {
  if(ridge) {
    // calculate width for bottom of the ridge
    ridge_width = outerRadius / ridges * 3;    
    for(i=[1:ridges]) {
      rotate((i)*(360/ridges),0)
        translate([0, innerRadius, 0])  
          linear_extrude(height = height-2)
            polygon(points=[[-ridge_width/2,0],[0,outerRadius-innerRadius],[ridge_width/2,0]], paths=[[0,1,2]]);
    }  
  }
}

/*
* Rim "lip" at the bottom of the body, works nicely with the ridges
*/
module knobrim() {
  if(rim) {
    cylinder(h = h/10, r1 = r+1, r2 = r+1, center = false);
  }
}

/*
* hole for the finger
*/
module finger_hole(r) {
  translate([0, width/3.5, height+3])
    sphere(r=r);
}

/*
* hole for the shaft
*/
module shaft_hole(r) {
  difference() {
    // the main shaft, give a bit of slack into it also
    cylinder(h = h, r = r + shaft_tolerance, center = false);
    // the slot, and move it to the correct place
    if (d_shaft){
      translate([0, -30/2-r/1.7, 0])
        cube(30,30,30, center=true);
    }
  }
}

/*
* main body of the knob
*/
module mainbody(h, r, center) {
    union() {
      if(knurling) {
        knurl(k_cyl_hg	= h,	k_cyl_od	= r*2); 
      } else {
        cylinder(h = h, r1 = r, r2 = r, center = false);
      }
      // rim at the bottom
      knobrim(h=h, r=r);
    }
}

/*
* assebmle the knob
*/
module knob(h, r) {
    // main body of the knob

  difference() {
    union() {
      mainbody(h=h, r=r, center=false);
      ridge(ridges=ridges, outerRadius=r+1, innerRadius=r);
    }
    if (hole)
      finger_hole(r=7);
    translate([0,0,-3.5]) {
      shaft_hole(h=h+2, r=6/2);
    }
  }

}

/*
* helper for the chamfer 
*/
module chamfer(h, r, chamfer) {
    rotate_extrude($fn=200) translate([r-5-chamfer,h-6-chamfer,0]) polygon( points=[[0,10],[10,10], [10,0]] );
}

/*
* knob with chamfering
*/
module knob_chamfered(h, r, chamfer) {
  difference() {
    knob(h=height, r=width/2);
    chamfer(h, r, chamfer);
    // chamfer
  }  
}

// do it
knob_chamfered(h=height, r=width/2, chamfer=chamfer);

translate([0, 0, -4])
  difference(){
      cylinder(h=4, d=44);
      cylinder(h=4, d=6+2*shaft_tolerance);

  }



/*
 * knurledFinishLib_v2.scad
 * 
 * Written by aubenc @ Thingiverse
 *
 * This script is licensed under the Public Domain license.
 *
 * http://www.thingiverse.com/thing:31122
 *
 * Derived from knurledFinishLib.scad (also Public Domain license) available at
 *
 * http://www.thingiverse.com/thing:9095
 *
 * Usage:
 *
 *	 Drop this script somewhere where OpenSCAD can find it (your current project's
 *	 working directory/folder or your OpenSCAD libraries directory/folder).
 *
 *	 Add the line:
 *
 *		use <knurledFinishLib_v2.scad>
 *
 *	 in your OpenSCAD script and call either...
 *
 *    knurled_cyl( Knurled cylinder height,
 *                 Knurled cylinder outer diameter,
 *                 Knurl polyhedron width,
 *                 Knurl polyhedron height,
 *                 Knurl polyhedron depth,
 *                 Cylinder ends smoothed height,
 *                 Knurled surface smoothing amount );
 *
 *  ...or...
 *
 *    knurl();
 *
 *	If you use knurled_cyl() module, you need to specify the values for all and
 *
 *  Call the module ' help(); ' for a little bit more of detail
 *  and/or take a look to the PDF available at http://www.thingiverse.com/thing:9095
 *  for a in depth descrition of the knurl properties.
 */


module knurl(	k_cyl_hg	= 12,
					k_cyl_od	= 25,
					knurl_wd =  3,
					knurl_hg =  4,
					knurl_dp =  1.5,
					e_smooth =  2,
					s_smooth =  0)
{
    knurled_cyl(k_cyl_hg, k_cyl_od, 
                knurl_wd, knurl_hg, knurl_dp, 
                e_smooth, s_smooth);
}

module knurled_cyl(chg, cod, cwd, csh, cdp, fsh, smt)
{
    cord=(cod+cdp+cdp*smt/100)/2;
    cird=cord-cdp;
    cfn=round(2*cird*PI/cwd);
    clf=360/cfn;
    crn=ceil(chg/csh);

    echo("knurled cylinder max diameter: ", 2*cord);
    echo("knurled cylinder min diameter: ", 2*cird);

	 if( fsh < 0 )
    {
        union()
        {
            shape(fsh, cird+cdp*smt/100, cord, cfn*4, chg);

            translate([0,0,-(crn*csh-chg)/2])
              knurled_finish(cord, cird, clf, csh, cfn, crn);
        }
    }
    else if ( fsh == 0 )
    {
        intersection()
        {
            cylinder(h=chg, r=cord-cdp*smt/100, $fn=2*cfn, center=false);

            translate([0,0,-(crn*csh-chg)/2])
              knurled_finish(cord, cird, clf, csh, cfn, crn);
        }
    }
    else
    {
        intersection()
        {
            shape(fsh, cird, cord-cdp*smt/100, cfn*4, chg);

            translate([0,0,-(crn*csh-chg)/2])
              knurled_finish(cord, cird, clf, csh, cfn, crn);
        }
    }
}

module shape(hsh, ird, ord, fn4, hg)
{
	x0= 0;	x1 = hsh > 0 ? ird : ord;		x2 = hsh > 0 ? ord : ird;
	y0=-0.1;	y1=0;	y2=abs(hsh);	y3=hg-abs(hsh);	y4=hg;	y5=hg+0.1;

	if ( hsh >= 0 )
	{
		rotate_extrude(convexity=10, $fn=fn4)
		polygon(points=[	[x0,y1],[x1,y1],[x2,y2],[x2,y3],[x1,y4],[x0,y4]	],
					paths=[	[0,1,2,3,4,5]	]);
	}
	else
	{
		rotate_extrude(convexity=10, $fn=fn4)
		polygon(points=[	[x0,y0],[x1,y0],[x1,y1],[x2,y2],
								[x2,y3],[x1,y4],[x1,y5],[x0,y5]	],
					paths=[	[0,1,2,3,4,5,6,7]	]);
	}
}

module knurled_finish(ord, ird, lf, sh, fn, rn)
{
    for(j=[0:rn-1])
    assign(h0=sh*j, h1=sh*(j+1/2), h2=sh*(j+1))
    {
        for(i=[0:fn-1])
        assign(lf0=lf*i, lf1=lf*(i+1/2), lf2=lf*(i+1))
        {
            polyhedron(
                points=[
                     [ 0,0,h0],
                     [ ord*cos(lf0), ord*sin(lf0), h0],
                     [ ird*cos(lf1), ird*sin(lf1), h0],
                     [ ord*cos(lf2), ord*sin(lf2), h0],

                     [ ird*cos(lf0), ird*sin(lf0), h1],
                     [ ord*cos(lf1), ord*sin(lf1), h1],
                     [ ird*cos(lf2), ird*sin(lf2), h1],

                     [ 0,0,h2],
                     [ ord*cos(lf0), ord*sin(lf0), h2],
                     [ ird*cos(lf1), ird*sin(lf1), h2],
                     [ ord*cos(lf2), ord*sin(lf2), h2]
                    ],
                triangles=[
                     [0,1,2],[2,3,0],
                     [1,0,4],[4,0,7],[7,8,4],
                     [8,7,9],[10,9,7],
                     [10,7,6],[6,7,0],[3,6,0],
                     [2,1,4],[3,2,6],[10,6,9],[8,9,4],
                     [4,5,2],[2,5,6],[6,5,9],[9,5,4]
                    ],
                convexity=5);
         }
    }
}

module knurl_help()
{
	echo();
	echo("    Knurled Surface Library  v2  ");
   echo("");
	echo("      Modules:    ");
	echo("");
	echo("        knurled_cyl(parameters... );    -    Requires a value for each an every expected parameter (see bellow)    ");
	echo("");
	echo("        knurl();    -    Call to the previous module with a set of default parameters,    ");
	echo("                                  values may be changed by adding 'parameter_name=value'        i.e.     knurl(s_smooth=40);    ");
	echo("");
	echo("      Parameters, all of them in mm but the last one.    ");
	echo("");
	echo("        k_cyl_hg       -   [ 12   ]  ,,  Height for the knurled cylinder    ");
	echo("        k_cyl_od      -   [ 25   ]  ,,  Cylinder's Outer Diameter before applying the knurled surfacefinishing.    ");
	echo("        knurl_wd     -   [   3   ]  ,,  Knurl's Width.    ");
	echo("        knurl_hg      -   [   4   ]  ,,  Knurl's Height.    ");
	echo("        knurl_dp     -   [  1.5 ]  ,,  Knurl's Depth.    ");
	echo("        e_smooth   -    [  2   ]  ,,  Bevel's Height at the bottom and the top of the cylinder    ");
	echo("        s_smooth   -    [  0   ]  ,,  Knurl's Surface Smoothing :  File donwn the top of the knurl this value, i.e. 40 will snooth it a 40%.    ");
	echo("");
}

