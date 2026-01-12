// 3U Mini-PC Rackmount – Honeycomb All Sides (except front)
// Front ears, square rack holes (M6 cage nuts)
// Mini PC sled cutouts for vertical mounting
// OpenSCAD: F6 → Export STL

$fn = 64;

// --------------------
// Dimensions (mm)
// --------------------
rack_height = 133.35;    // 3U (3 × 44.45mm)
rack_width  = 482.6;     // 19"
body_width  = 450;
depth       = 300;

ear_width   = 15.875;    // standard rack ear width (0.625")
ear_thk     = 5;

panel_thk  = 3;
front_panel_thk = 8;  // thicker front panel for strength

// Front panel reinforcement ribs
rib_width = 5;
rib_height = 15;  // how far ribs extend back from front panel

// Rack holes (M6 cage nut square holes)
hole_size        = 9.5;   // square hole for M6 cage nuts
hole_edge_offset = 9.525; // center from edge (3/8")

// 3U rack hole pattern - 3 holes per U, spacing: 15.875, 15.875, 12.7mm
// Starting from bottom of panel, offset by half the gap (0.397mm)
hole_z = [
  // 1U (bottom)
  6.35,      // first hole
  22.225,    // +15.875
  38.1,      // +15.875
  // 2U (middle)  
  50.8,      // +12.7
  66.675,    // +15.875
  82.55,     // +15.875
  // 3U (top)
  95.25,     // +12.7
  111.125,   // +15.875
  127.0      // +15.875
];

// Vent hole pattern (simple grid for strength and easy printing)
vent_hole_size = 8;      // square hole size
vent_spacing = 12;       // center-to-center spacing
vent_margin = 10;        // margin from edges

// Mini PC dimensions
pc_width  = 41;
pc_height = 117;
pc_depth  = 117;
sled_depth = 150;  // extra room for tray
sled_wall = 3;     // wall between sled slots
screw_hole_dia = 3.5;  // M3 screw holes
screw_boss_dia = 8;    // boss around screw holes

// Diagonal brace dimensions
brace_width = 15;
brace_thk = 4;

// Calculate how many PCs fit
num_pcs = floor((body_width - 20) / (pc_width + sled_wall));  // leave 10mm margin each side
sled_total_width = num_pcs * (pc_width + sled_wall) - sled_wall;
sled_start_x = -sled_total_width / 2;

// --------------------
// Modules
// --------------------
module vent_grid(w, h){
  // Simple grid of square holes - strong and easy to print
  cols = floor((w - 2*vent_margin) / vent_spacing);
  rows = floor((h - 2*vent_margin) / vent_spacing);
  start_x = (w - (cols-1)*vent_spacing) / 2;
  start_y = (h - (rows-1)*vent_spacing) / 2;
  
  for (row = [0:rows-1])
    for (col = [0:cols-1])
      translate([start_x + col*vent_spacing, start_y + row*vent_spacing])
        square(vent_hole_size, center=true);
}

// --------------------
// Model
// --------------------
union() {

difference(){

  // Main structure
  union(){
    // Bottom panel
    translate([-body_width/2, 0, 0])
      cube([body_width, depth, panel_thk]);

    // Front panel (thicker for strength)
    translate([-body_width/2, 0, 0])
      cube([body_width, front_panel_thk, rack_height]);

    // Horizontal reinforcement ribs on back of front panel
    // Top rib
    translate([-body_width/2, front_panel_thk, rack_height - rib_width])
      cube([body_width, rib_height, rib_width]);
    // Bottom rib
    translate([-body_width/2, front_panel_thk, 0])
      cube([body_width, rib_height, rib_width]);
    // Vertical ribs between sled slots
    for (i = [0:num_pcs]) {
      translate([sled_start_x + i * (pc_width + sled_wall) - sled_wall/2 - rib_width/2, front_panel_thk, 0])
        cube([rib_width, rib_height, rack_height]);
    }

    // Front ears
    translate([-rack_width/2, 0, 0])
      cube([ear_width, ear_thk, rack_height]);

    translate([rack_width/2-ear_width, 0, 0])
      cube([ear_width, ear_thk, rack_height]);
  }

  // Square rack holes
  for (z = hole_z){
    translate([-rack_width/2 + hole_edge_offset, ear_thk/2, z])
      cube([hole_size, ear_thk+1, hole_size], center=true);

    translate([ rack_width/2 - hole_edge_offset, ear_thk/2, z])
      cube([hole_size, ear_thk+1, hole_size], center=true);
  }

  // Vent holes in bottom panel
  translate([-body_width/2, 0, -1])
    linear_extrude(panel_thk+2)
      vent_grid(body_width, depth);

  // Vent holes in front panel (below and above sled area)
  sled_z_start = (rack_height - pc_height) / 2;
  // Below sled slots
  if (sled_z_start > vent_margin * 2) {
    translate([0, front_panel_thk+1, sled_z_start/2])
      rotate([90, 0, 0])
        linear_extrude(front_panel_thk+2)
          vent_grid(body_width, sled_z_start);
  }
  // Above sled slots
  top_space = rack_height - sled_z_start - pc_height;
  if (top_space > vent_margin * 2) {
    translate([0, front_panel_thk+1, sled_z_start + pc_height + top_space/2])
      rotate([90, 0, 0])
        linear_extrude(front_panel_thk+2)
          vent_grid(body_width, top_space);
  }

  // Mini PC sled cutouts - slots for each PC
  // Each slot is pc_width wide, pc_height tall, runs through the depth
  sled_z_start = (rack_height - pc_height) / 2;  // center vertically
  for (i = [0:num_pcs-1]) {
    translate([sled_start_x + i * (pc_width + sled_wall), -1, sled_z_start])
      cube([pc_width, sled_depth + 1, pc_height]);
  }

  // Screw holes in front panel for sled mounting (2 per slot - top and bottom)
  for (i = [0:num_pcs-1]) {
    // Top screw hole (above sled slot)
    translate([sled_start_x + i * (pc_width + sled_wall) + pc_width/2, front_panel_thk/2, sled_z_start + pc_height + 5])
      rotate([90, 0, 0])
        cylinder(h=front_panel_thk+2, d=screw_hole_dia, center=true);
    // Bottom screw hole (below sled slot)
    translate([sled_start_x + i * (pc_width + sled_wall) + pc_width/2, front_panel_thk/2, sled_z_start - 5])
      rotate([90, 0, 0])
        cylinder(h=front_panel_thk+2, d=screw_hole_dia, center=true);
  }
}

// Diagonal braces from top front to back bottom (left and right sides)
// Left brace
translate([-body_width/2 + panel_thk, 0, 0])
  hull() {
    // Top front - joins to back of top of front panel
    translate([0, front_panel_thk + rib_height, rack_height - brace_thk])
      cube([brace_width, brace_thk, brace_thk]);
    // Bottom back
    translate([0, depth - brace_thk, 0])
      cube([brace_width, brace_thk, brace_thk]);
  }

// Right brace
translate([body_width/2 - panel_thk - brace_width, 0, 0])
  hull() {
    // Top front - joins to back of top of front panel
    translate([0, front_panel_thk + rib_height, rack_height - brace_thk])
      cube([brace_width, brace_thk, brace_thk]);
    // Bottom back
    translate([0, depth - brace_thk, 0])
      cube([brace_width, brace_thk, brace_thk]);
  }

} // end main union
