L = 97.2;
H = 30;
P = 72.5;

color("green") cube([L, P, H]);
translate([12.5, 12.5, H]) cylinder(h=5, d=15);
translate([32.5, 12.5, H]) cylinder(h=5, d=15);
translate([12.5, 42.5, H]) cylinder(h=5, d=15);
translate([32.5, 42.5, H]) cylinder(h=5, d=15);
translate([67.5, 27.5, H]) cylinder(h=5, d=50);

for (i = [0:5])
{
    translate([5+15*i, 55, H]) cube([12, 6, 2.5]);
    color("red") translate([11+15*i, 55+10, H]) sphere(d=5);
}