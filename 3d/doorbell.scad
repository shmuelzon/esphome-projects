$fn=36;

/* General */
epsilon = 0.01;
mechanical_clearence = 0.1; /* Set according to printer's accuracy */

/* Case */
case_wall_thickness = 1.6;
case_depth = 16;
case_width = 77;
case_height = 114;
case_edge_radius = 5;

module round_cube(size=[0, 0, 0], r=2)
{
  minkowski()
  {
    cube([size[0] - (2 * r), size[1] - (2 * r), size[2] - 0.01]);
    translate([r, r, 0]) cylinder(r=r, h=0.01);
  }
}

module centered_cube(size=[0, 0, 0])
{
  translate([-size[0] / 2, -size[1] / 2, 0]) cube(size);
}

module countersunk_screw(length)
{
  color("gray")
  {
    cylinder(h=3, r1=4.5 + mechanical_clearence, r2=2.25 + mechanical_clearence);
    translate([0, 0, 3]) cylinder(h=length, r=2.25 + mechanical_clearence);
  }
}

module m3_hex_screw(length)
{
  color("gray")
  {
    cylinder(h=2, r=2.2 + mechanical_clearence);
    translate([0, 0, 2]) cylinder(h=length, r=1.5 + mechanical_clearence);
  }
}

module case()
{
  difference()
  {
    round_cube([case_width, case_height, case_depth], r=case_edge_radius);
    translate([case_wall_thickness, case_wall_thickness, -case_wall_thickness]) round_cube([case_width - (case_wall_thickness * 2), case_height - (case_wall_thickness * 2), case_depth], r=case_edge_radius);
    /* Button wiring */
    translate([13, 67, case_depth - case_wall_thickness - epsilon]) round_cube([10, 5, case_wall_thickness + (2 * epsilon)]);
    translate([13, 42, case_depth - case_wall_thickness - epsilon]) round_cube([10, 5, case_wall_thickness + (2 * epsilon)]);
    translate([10.5, 37, case_depth - 0.5]) linear_extrude(height=0.5) text("Button", size=4);
    /* Live wiring */
    translate([54, 67, case_depth - case_wall_thickness - epsilon]) round_cube([10, 5, case_wall_thickness + (2 * epsilon)]);
    translate([54, 42, case_depth - case_wall_thickness - epsilon]) round_cube([10, 5, case_wall_thickness + (2 * epsilon)]);
    translate([54, 37, case_depth - 0.5]) linear_extrude(height=0.5) text("Live", size=4);
    /* Antenna wire */
    translate([27, 75, case_depth - case_wall_thickness - epsilon]) cylinder(r = 2, h = case_wall_thickness + (2 * epsilon));
  }
  /* AC/DC separator */
  translate([47, 65, 0]) cube([case_wall_thickness, 15, case_depth]);
  translate([36, 44, 0]) cube([case_wall_thickness, 20, case_depth]);
  translate([37, 44, 0]) cube([16, case_wall_thickness, case_depth]);
  /* Screw mounts */
  translate([7, case_height / 2, 0]) cylinder(r = 4, h=case_depth);
  translate([case_width - 7, case_height / 2, 0]) cylinder(r = 4, h=case_depth);
}

module hardware()
{
  /* Wall-mount screws */
  translate([7, case_height / 2, case_depth]) rotate([180, 0, 0]) countersunk_screw(length=case_depth);
  translate([case_width - 7, case_height / 2, case_depth]) rotate([180, 0, 0]) countersunk_screw(length=case_depth);
  /* Speaker mount screws */
  translate([7, 7.5, 20]) rotate([180, 0, 0]) m3_hex_screw(length=10);
  translate([70, 7.5, 20]) rotate([180, 0, 0]) m3_hex_screw(length=10);
  translate([7, 32.5, 20]) rotate([180, 0, 0]) m3_hex_screw(length=10);
  translate([70, 32.5, 20]) rotate([180, 0, 0]) m3_hex_screw(length=10);
}

module transformer()
{
  color("gray")
  {
    centered_cube([28.5, 14, 25.5]);
    centered_cube([19.2, 26.5, 23]);
  }
}

module relay()
{
  color("cyan")
  {
    centered_cube([21, 27, 41]);
  }
}

module speaker()
{
  color("black")
  translate([0, 0, 16 / 2])
  {
    translate([0, 0, 7])
    difference()
    {
      cube([69, 31, 2], center=true);
      translate([-31.5, -12.5, -1]) cylinder(h=2, r=1.5);
      translate([31.5, -12.5, -1]) cylinder(h=2, r=1.5);
      translate([-31.5, 12.5, -1]) cylinder(h=2, r=1.5);
      translate([31.5, 12.5, -1]) cylinder(h=2, r=1.5);
    }
    translate([0, 0, -1]) cube([52, 31, 14], center=true);
    translate([0, 0, -1]) cube([69, 15, 14], center=true);
  }
}

module amp()
{
  color("purple")
  {
    centered_cube([18.8, 17.4, 1.6]);
  }
}

module xiao()
{
  color("black")
  {
    centered_cube([21, 18, 1.6]);
  }
}

module antenna()
{
  color("black")
  {
    centered_cube([20, 40, 1]);
  }
}

module powerConverter()
{
  color("blue")
  {
    centered_cube([23.6, 15.3, 15.2]);
    /* DC Connector */
    translate([23.6 / 2 - 6 / 2, -15.3 / 2 - 3 / 2, 15.2 - 1.2])centered_cube([6, 3, 1.2]);
    /* AC Connector */
    translate([-23.6 / 2 + 7.5 / 2, -15.3 / 2 - 3 / 2, 15.2 - 1.2])centered_cube([7.5, 3, 1.2]);
  }
}

module electronics()
{
  translate([59, 92, 0]) transformer();
  translate([18, 92, 0]) relay();
  translate([23, 57, 0]) amp();
  translate([23, 57, 10]) xiao();
  translate([39, 59, case_depth]) antenna();
  translate([51, 55.5, 0]) rotate([0, 0, 180]) powerConverter();
  translate([(case_width / 2), 20, 2]) speaker();
}

difference()
{
  union()
  {
    case();
  }
  if (!$preview)
  {
    electronics();
    hardware();
  }
}

if ($preview)
{
  electronics();
  hardware();
}
