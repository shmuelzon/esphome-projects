$fn=36;
show_top = true;
show_bottom = true;

/* General */
epsilon = 0.01;
mechanical_clearance = 0.1; /* Set according to printer's accuracy */

/* Case */
case_wall_thickness = 1.6;
case_depth = 15;
case_width = 70;
case_height = 50;
case_edge_radius = 5;

screws_locations = [[-28.5, 17],[-28.5, -7],[29.5, -15]];


module m3_countersunk_screw(length)
{
  color("gray")
  {
    cylinder(h=2, r1=3 + mechanical_clearance, r2=1.5 + mechanical_clearance);
    translate([0, 0, 2]) cylinder(h=length, r=1.5 + mechanical_clearance);
  }
}

module m3_thread_insert(base_length=0)
{
  cylinder(r=3.5, h=base_length);
  translate([0, 0, base_length])
  difference()
  {
    cylinder(r=3.5, h=7.5);
    cylinder(r=1.8 + mechanical_clearance, h=7.5 + epsilon);
    translate([0, 0, 6.5]) cylinder(r1=1.8 + mechanical_clearance, r2=2.1 + mechanical_clearance, h=1 + epsilon);
  }
}

module round_cube(size=[0, 0, 0], r=2)
{
  translate([-size[0] / 2, -size[1] / 2, -size[2] / 2])
  minkowski()
  {
    cube([size[0] - (2 * r), size[1] - (2 * r), size[2] - 0.01]);
    translate([r, r, 0]) cylinder(r=r, h=0.01);
  }
}

module barcode_scanner()
{
  size = [21.4, 11.8, 14];
  distance_between_threads = 14.6;
  thread_diameter = 1.4;
  screw_keepout = 3;
  
  color("#303030") cube([for (i=[0:len(size)-1]) size[i] + mechanical_clearance], center=true);
  /* Screw keepout */
  #translate([-distance_between_threads / 2, size[1] / 2, 0]) rotate([270, 0, 0]) cylinder(r=thread_diameter / 2, h=screw_keepout);
  #translate([ distance_between_threads / 2, size[1] / 2, 0]) rotate([270, 0, 0]) cylinder(r=thread_diameter / 2, h=screw_keepout);
}

module usb_cable()
{
  color("green") translate([-0.3, -0.5, 0]) cube([6.5, 10, 2]);
  #translate([-20, -0.5 + (10/2) - (3.5/2), 0]) cube([20, 3.5, 2]);
  color("silver") translate([5.6-2.35, 0, 2]) cube([2.35, 9, 8.3]);

  /* keepout (for female connector */
  #translate([5.6-2.7, 0, 10.3]) cube([3, 9, 4]);
  #translate([5.6-2.7+3, 0, 10.3]) cube([2, 6, 4]);
}

module speaker()
{
  size = [24, 15, 3];
  keepout_radius = 0.75;
  number_of_keepout_circles = 3;
  number_of_keepout_branches = 8;
  keepout_max_radius = min(size[0], size[1]) / 2 - keepout_radius;

  color("#303030") round_cube([for (i=[0:len(size)-1]) size[i] + mechanical_clearance], r=(size[1] + mechanical_clearance) /2 - epsilon);
  if (true)
  {
    for (radius=[0 : keepout_max_radius / (number_of_keepout_circles - 1) : keepout_max_radius])
    {
      for (degree=[0 : 360 / number_of_keepout_branches : 360])
        #translate([radius * cos(degree), radius * sin(degree), size[2] / 2]) cylinder(r=keepout_radius, h=5);
    }
  }
  else
  {
    for (radius=[0 : number_of_keepout_circles])
    {
      for (degree=[0 : 360 / number_of_keepout_branches : 360])
        #translate([size[0] * (radius  / number_of_keepout_circles) * cos(degree) / 2, size[1] * (radius / number_of_keepout_circles) * sin(degree) / 2, size[2] / 2]) cylinder(r=keepout_radius, h=5);
    }
  }
}

module amp()
{
  size=[18.8, 17.5, 1.6];
  color("purple") round_cube([for (i=[0:len(size)-1]) size[i] + mechanical_clearance], r=1);
}

module display()
{
  size = [54.2, 25.6, 9.8]; /*54.2*/

  color("#303030") cube([for (i=[0:len(size)-1]) size[i] + mechanical_clearance], center=true);
  #translate([-2.5, 0, size[2] / 2]) cube([45, 21.5, 10], center=true);
  
}

module case_top()
{
  difference()
  {
    round_cube([case_width, case_height, case_depth], r=case_edge_radius);
    translate([0,0,-case_wall_thickness - 2]) round_cube([case_width - (case_wall_thickness * 2), case_height - (case_wall_thickness * 2), case_depth], r=case_edge_radius);
  }

  /* Barcode scanner screw mount */
  translate([3, -21, -2]) cube([24, 14, 7]);

  /* Screw stand-offs */
  for (screw = screws_locations)
    translate([screw[0], screw[1], case_wall_thickness + 3]) rotate([180, 0, 0]) m3_thread_insert(3);
}

module case_bottom()
{
  translate([0, 0, -case_depth / 2 + case_wall_thickness / 2]) round_cube([case_width - (case_wall_thickness * 2) - (mechanical_clearance * 2), case_height - (case_wall_thickness * 2) - (mechanical_clearance * 2), case_wall_thickness], r=case_edge_radius);
}

module case()
{
  union()
  {
    if (show_top)
      case_top();
    if (show_bottom)
      case_bottom();
  }
}

module electronics()
{
  translate([2.5, 8, 1.5]) display();
  translate([-15, -14, 5]) speaker();
  translate([-15, -14, 0]) amp();
  translate([15, -14, 0.5]) barcode_scanner();
  translate([-33, 0, -7.5]) usb_cable();
}

module hardware()
{
  /* Screw inserts */
  for (screw = screws_locations)
    translate([screw[0], screw[1], -case_depth + 7.5]) m3_countersunk_screw(8);

  /* Magnets */
  magnet_locations=[[20,5], [-20,5]];
  for (magnet = magnet_locations)
    color("silver") translate([magnet[0], magnet[1], -case_depth / 2 + 1.85]) cube([9.5, 20, 2.7], center=true);
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

