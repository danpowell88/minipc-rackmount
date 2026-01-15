// 3U Mini-PC Rackmount – Split for 250mm Print Bed
// Front ears, square rack holes (M6 cage nuts)
// Mini PC sled cutouts for vertical mounting
// Two halves join with M3 screws via bottom joiner plate

$fn = 64;

// --------------------
// Print Selection
// --------------------
// Set which part to render:
// Main print options:
//   "left"   = left half of rack (for printing)
//   "right"  = right half of rack (for printing)
//   "joiner" = bottom joiner plate that joins both halves (for printing)
//   "both"   = show assembled view (for preview, not for printing)
// Test print options:
//   "front_face"     = front panel only (for testing fit)
//   "no_face"        = all parts except front panel
//   "no_bottom"      = all parts except bottom panel
//   "no_bracing"     = all parts except diagonal braces
//   "join_test"      = both joining pieces together (for test fitting)
//   "join_test_left" = left joining piece only (for printing)
//   "join_test_right"= right joining piece only (for printing)
print_part = "both";  // OPTIONS: "left", "right", "joiner", "both", "front_face", "no_face", "no_bottom", "no_bracing", "join_test", "join_test_left", "join_test_right"
half_spacing = 0;     // gap between halves when showing both (0 for assembled view)

// Test print flags (used internally based on print_part)
test_front_only = (print_part == "front_face");
test_no_face = (print_part == "no_face");
test_no_bottom = (print_part == "no_bottom");
test_no_bracing = (print_part == "no_bracing");
test_join_only = (print_part == "join_test" || print_part == "join_test_left" || print_part == "join_test_right");

// Join test dimensions
join_test_width = 100;  // width of join test piece from center (includes more faceplate)
join_test_height = 0;   // 0 = full height, or set specific value
join_test_depth = 40;   // depth of join test piece

// --------------------
// Dimensions (mm)
// --------------------
rack_height = 133.35;    // 3U (3 × 44.45mm)
rack_width  = 482.6;     // 19"
body_width  = 450;
depth       = 245;       // reduced to fit 250mm print bed

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
vent_hole_size = 12;     // square hole size (larger = less material)
vent_spacing = 14;       // center-to-center spacing (2mm walls between holes)
vent_margin = 4;         // margin from edges (reduced to fit more holes)

// Mini PC dimensions
pc_width  = 41;
pc_height = 117;
pc_depth  = 117;
sled_depth = 150;  // extra room for tray
sled_wall = 3;     // wall between sled slots
screw_hole_dia = 3.5;  // M3 screw holes
screw_boss_dia = 8;    // boss around screw holes

// Keystone jack dimensions (rear-insert/flush-front)
keystone_front_width = 14.5;        // Front opening width
keystone_front_height = 16.0;       // Front opening height
keystone_panel_thk = 2.0;           // Panel thickness for flush stop
keystone_rear_width = 18.3;         // Rear cavity width (+ tolerance)
keystone_rear_height = 20.3;        // Rear cavity height (+ tolerance)
keystone_relief_height = 2.5;       // Retention tab relief height
keystone_relief_depth = 1.5;        // Retention tab relief depth
keystone_depth_total = 32;          // Total depth for keystone body and cables
keystone_corner_radius = 0.5;       // Corner radius for front opening
keystone_chamfer = 0.5;             // Rear edge chamfer for easy insertion
keystone_spacing = 18;              // Center-to-center spacing between keystones
keystones_per_slot = 3;             // Number of keystones per sled slot

// Diagonal brace dimensions
brace_width = 15;        // reduced to avoid overlapping slots
brace_thk = 5;
brace_vert_supports = 2;  // reduced number of vertical supports
brace_vert_width = 4;     // width of vertical supports

// Rack ear gusset dimensions (triangular support)
ear_gusset_depth = 25;    // how far back the gusset extends
ear_gusset_height = 40;   // height of gusset at front

// Ear-to-panel reinforcement (vertical bars connecting ear to front panel)
ear_reinf_thk = 5;        // thickness of vertical reinforcement bars
ear_reinf_num = 3;        // number of vertical reinforcement bars (top, middle, bottom)

// Middle rack holes to keep solid (for structural support)
// 2U middle holes are at indices 3, 4, 5 in hole_z array
middle_holes_start = 3;
middle_holes_end = 5;

// Join flange dimensions
// Join is now a simple butt joint with bolt holes
join_screw_spacing = 15;  // vertical spacing between screws on flange

// Bottom joiner plate dimensions
joiner_length = 100;      // how far along depth the joiner extends
joiner_width = 60;        // total width spanning both halves
joiner_thk = 4;           // thickness of joiner plate
joiner_screw_inset = 10;  // distance from edge to screw holes

// Back crossbar dimensions (integrated into joiner)
crossbar_width = 30;
crossbar_height = brace_thk;
crossbar_depth = 20;

// Join bolt holes - simple M4 bolt holes to connect the two halves
join_bolt_dia = 4.5;             // M4 bolt clearance hole
join_bolt_count = 5;             // number of bolts along the join (evenly spaced vertically)
join_edge_width = 15;            // width of thickened edge at join (how far it extends in X)
join_edge_depth = rib_height;    // depth matches rib_height for flush inside face
join_bolt_head_dia = 8;          // M4 bolt head diameter (hex socket cap)
join_bolt_head_depth = 4;        // depth of recess for bolt head
join_nut_dia = 9;                // M4 nut diameter (across flats ~7mm, across corners ~8mm, +tolerance)
join_nut_depth = 4;              // depth of recess for nut

// Calculate centered sled positions
// Center the sleds within each half, leaving gap at center for joiner
sled_offset = 15;  // offset from center to leave room for joining
half_width = body_width / 2;

// Calculate how many PCs fit - adjust for keystone jacks
// Keystones alternate sides: |K|PC||PC|K| - more efficient packing
keystone_column_width = keystone_rear_width + 4;  // keystone + small margin

// Available width per half: from join area to inner edge of ear reinforcement
// half_width = 225, sled_offset = 15 (join area)
// Reduce margin near ears to maximize slots
available_width_per_half = half_width - sled_offset - 5;  // 225 - 15 - 5 = 205mm

// Each PC+keystone pair needs: pc_width + keystone_column_width + sled_wall
slot_pitch = pc_width + keystone_column_width + sled_wall;  // 41 + 22 + 3 = 66mm
num_pcs_per_half = floor(available_width_per_half / slot_pitch);  // 205 / 66 = 3 slots
num_pcs = num_pcs_per_half * 2;  // total sleds

// Slots start from the join area and go outward toward ears
// This keeps the center clean for the join

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

// Keystone jack slot (rear-insert with flush front)
// Oriented vertically: width in X, height in Z, depth in Y
// Origin at front face center of keystone
module keystone_jack_slot() {
  // Front opening (flush face) - cuts completely through front panel
  // Width (X) x Height (Z), extruded through Y (front to back)
  translate([0, front_panel_thk + 1, 0])
    rotate([90, 0, 0])
      linear_extrude(front_panel_thk + 2)  // Full thickness + extra to ensure complete cut
        offset(r=keystone_corner_radius)
          square([keystone_front_width - 2*keystone_corner_radius, 
                  keystone_front_height - 2*keystone_corner_radius], center=true);
  
  // Rear cavity (stepped opening) - for keystone body and tabs
  // Extends from back of front panel further into the rack
  translate([0, front_panel_thk + keystone_depth_total, 0])
    rotate([90, 0, 0])
      linear_extrude(keystone_depth_total)
        square([keystone_rear_width, keystone_rear_height], center=true);
  
  // Top retention tab relief (above rear cavity)
  translate([0, front_panel_thk + keystone_depth_total, keystone_rear_height/2 + keystone_relief_height])
    rotate([90, 0, 0])
      linear_extrude(keystone_depth_total)
        square([keystone_rear_width, keystone_relief_height * 2], center=true);
  
  // Bottom retention tab relief (below rear cavity)
  translate([0, front_panel_thk + keystone_depth_total, -keystone_rear_height/2 - keystone_relief_height])
    rotate([90, 0, 0])
      linear_extrude(keystone_depth_total)
        square([keystone_rear_width, keystone_relief_height * 2], center=true);
}

// Join bolt holes module - creates holes for M4 bolts along the join
// Holes go horizontally (X direction) through the thickened join edge
// Includes recesses for bolt head on one side and nut on the other
module join_bolt_holes(side) {
  // Bolt holes are evenly spaced vertically
  bolt_spacing = (rack_height - 20) / (join_bolt_count - 1);
  // Position bolts toward the back of the join edge (centered in join_edge_depth)
  bolt_y = front_panel_thk + join_edge_depth / 2;
  
  for (i = [0 : join_bolt_count - 1]) {
    bolt_z = 10 + i * bolt_spacing;
    // Main bolt hole - horizontal in X direction
    translate([0, bolt_y, bolt_z])
      rotate([0, 90, 0])
        cylinder(h=join_edge_width * 2 + 2, d=join_bolt_dia, center=true, $fn=20);
    
    // Recess on outer side for bolt head or nut
    // Right half (side > 0): recess on +X side (bolt head), cuts inward from outer face
    // Left half (side < 0): recess on -X side (nut), cuts inward from outer face
    recess_depth = side > 0 ? join_bolt_head_depth : join_nut_depth;
    recess_dia = side > 0 ? join_bolt_head_dia : join_nut_dia;
    
    // Position at outer edge, cylinder extends inward
    // Right half: outer face at +join_edge_width, recess goes toward -X
    // Left half: outer face at -join_edge_width, recess goes toward +X
    if (side > 0) {
      translate([join_edge_width + 1, bolt_y, bolt_z])
        rotate([0, -90, 0])
          cylinder(h=recess_depth + 1, d=recess_dia, $fn=6);
    } else {
      translate([-join_edge_width - 1, bolt_y, bolt_z])
        rotate([0, 90, 0])
          cylinder(h=recess_depth + 1, d=recess_dia, $fn=6);
    }
  }
}

// Module for one half of the rack
// side = 1 for right half, -1 for left half
// Supports test print modes via global flags
module rack_half(side) {
  sled_z_start = (rack_height - pc_height) / 2;
  
  // Sled positions: start from join area, go outward toward ears
  // Right half: slots go from sled_offset outward (positive X)
  // Left half: slots go from -sled_offset outward (negative X)
  sled_start = side > 0 ? sled_offset : -sled_offset - slot_pitch;
  
  // For join test, clip to just the center area
  if (test_join_only) {
    // Use full height if join_test_height is 0, otherwise use specified height centered
    actual_join_height = (join_test_height == 0) ? rack_height : join_test_height;
    join_z_start = (join_test_height == 0) ? 0 : (rack_height/2 - join_test_height/2);
    
    intersection() {
      rack_half_full(side);
      // Clip box around join area - full height of front panel
      // Right half (side > 0): geometry is 0 to +half_width, clip from 0 to join_test_width
      // Left half (side < 0): geometry is -half_width to 0, clip from -join_test_width to 0
      if (side > 0) {
        translate([0, 0, join_z_start])
          cube([join_test_width, join_test_depth, actual_join_height]);
      } else {
        translate([-join_test_width, 0, join_z_start])
          cube([join_test_width, join_test_depth, actual_join_height]);
      }
    }
  } else {
    rack_half_full(side);
  }
}

// Full rack half implementation
module rack_half_full(side) {
  sled_z_start = (rack_height - pc_height) / 2;
  sled_start = side > 0 ? sled_offset : -sled_offset - slot_pitch;
  
  union() {
    difference(){
      // Main structure
      union(){
        // Bottom panel (half) - skip if test_no_bottom or test_front_only
        if (!test_no_bottom && !test_front_only) {
          translate([side > 0 ? 0 : -half_width, 0, 0])
            cube([half_width, depth, panel_thk]);
        }

        // Front panel (half, thicker for strength) - skip if test_no_face
        if (!test_no_face) {
          translate([side > 0 ? 0 : -half_width, 0, 0])
            cube([half_width, front_panel_thk, rack_height]);
        }

        // Horizontal reinforcement ribs on back of front panel - skip if front_only test
        if (!test_front_only) {
          // Only in areas outside the slot region (toward ears)
          // Calculate slot region extent
          slot_region_start = side > 0 ? sled_offset : -half_width;
          slot_region_end = side > 0 ? half_width : -sled_offset;
          last_slot_end = side > 0 
            ? sled_offset + num_pcs_per_half * slot_pitch 
            : -sled_offset - num_pcs_per_half * slot_pitch;
          
          // Top rib - only outside slot area (between last slot and ear)
          if (side > 0) {
            translate([last_slot_end, front_panel_thk, rack_height - rib_width])
              cube([half_width - last_slot_end, rib_height, rib_width]);
          } else {
            translate([-half_width, front_panel_thk, rack_height - rib_width])
              cube([-last_slot_end - half_width, rib_height, rib_width]);
          }
          // Bottom rib - only outside slot area (between last slot and ear)
          if (side > 0) {
            translate([last_slot_end, front_panel_thk, 0])
              cube([half_width - last_slot_end, rib_height, rib_width]);
          } else {
            translate([-half_width, front_panel_thk, 0])
              cube([-last_slot_end - half_width, rib_height, rib_width]);
          }
          
          // Vertical ribs for sled slots on this half
          // Ribs between slots and at edges
          for (i = [0:num_pcs_per_half]) {
            rib_x = side > 0 
              ? sled_offset + i * slot_pitch - sled_wall/2
              : -sled_offset - i * slot_pitch + sled_wall/2;
            translate([rib_x - rib_width/2, front_panel_thk, 0])
              cube([rib_width, rib_height, rack_height]);
          }
        }

        // Front ear - skip if test_front_only
        if (!test_front_only) {
        if (side > 0) {
          // Main ear - extended inward to meet faceplate
          translate([half_width, 0, 0])
            cube([rack_width/2 - half_width, ear_thk, rack_height]);
          
          // Fill gap at top - solid block connecting ear to faceplate
          translate([half_width - ear_width, 0, rack_height - panel_thk])
            cube([ear_width, front_panel_thk, panel_thk]);
          // Fill gap at bottom - solid block connecting ear to faceplate
          translate([half_width - ear_width, 0, 0])
            cube([ear_width, front_panel_thk, panel_thk]);
          
          // Deep reinforcement ribs connecting middle solid ear section to rib structure
          // These extend back (in Y) from the ear through the front panel to the ribs behind
          // The middle section (2U) has no holes and provides the main structural anchor
          
          middle_z_start = hole_z[middle_holes_start] - hole_size/2 - 3;
          middle_z_end = hole_z[middle_holes_end] + hole_size/2 + 3;
          middle_section_height = middle_z_end - middle_z_start;
          
          // Solid block extending from outer ear edge through front panel and into rib area
          // This creates a thick structural connection from mounting area to main body
          // Full width from rack edge to front panel, full depth to rib area
          translate([half_width - ear_width, 0, middle_z_start])
            cube([rack_width/2 - half_width + ear_width, front_panel_thk + rib_height, middle_section_height]);
          
          // Additional vertical rib extending from middle section down to bottom (ear_width wide)
          translate([half_width - ear_width, front_panel_thk, 0])
            cube([ear_width, rib_height, middle_z_start]);
          // And from middle section up to top (ear_width wide)
          translate([half_width - ear_width, front_panel_thk, middle_z_end])
            cube([ear_width, rib_height, rack_height - middle_z_end]);
        } else {
          // Main ear - extended inward to meet faceplate
          translate([-rack_width/2, 0, 0])
            cube([rack_width/2 - half_width, ear_thk, rack_height]);
          
          // Fill gap at top - solid block connecting ear to faceplate
          translate([-half_width, 0, rack_height - panel_thk])
            cube([ear_width, front_panel_thk, panel_thk]);
          // Fill gap at bottom - solid block connecting ear to faceplate
          translate([-half_width, 0, 0])
            cube([ear_width, front_panel_thk, panel_thk]);
          
          // Deep reinforcement ribs connecting middle solid ear section to rib structure
          middle_z_start = hole_z[middle_holes_start] - hole_size/2 - 3;
          middle_z_end = hole_z[middle_holes_end] + hole_size/2 + 3;
          middle_section_height = middle_z_end - middle_z_start;
          
          // Solid block extending from outer ear edge through front panel and into rib area
          // Full width from rack edge to front panel, full depth to rib area
          translate([-rack_width/2, 0, middle_z_start])
            cube([rack_width/2 - half_width + ear_width, front_panel_thk + rib_height, middle_section_height]);
          
          // Additional vertical rib extending from middle section down to bottom (ear_width wide)
          translate([-half_width, front_panel_thk, 0])
            cube([ear_width, rib_height, middle_z_start]);
          // And from middle section up to top (ear_width wide)
          translate([-half_width, front_panel_thk, middle_z_end])
            cube([ear_width, rib_height, rack_height - middle_z_end]);
        }
        }  // end if (!test_front_only) for ears
        
        // Thickened join edge - full depth section for bolt holes
        // Right half: edge at X=0 extending toward +X
        // Left half: edge at X=0 extending toward -X  
        // Starts at Y=0 (front surface) and goes back join_edge_depth
        join_edge_x = side > 0 ? 0 : -join_edge_width;
        translate([join_edge_x, 0, 0])
          cube([join_edge_width, front_panel_thk + join_edge_depth, rack_height]);
      }

      // Square rack holes (only on this side's ear)
      // Skip middle holes (indices 3-5) to keep solid for structural support
      for (i = [0:len(hole_z)-1]) {
        if (i < middle_holes_start || i > middle_holes_end) {
          z = hole_z[i];
          if (side > 0) {
            translate([rack_width/2 - hole_edge_offset, ear_thk/2, z])
              cube([hole_size, ear_thk+1, hole_size], center=true);
          } else {
            translate([-rack_width/2 + hole_edge_offset, ear_thk/2, z])
              cube([hole_size, ear_thk+1, hole_size], center=true);
          }
        }
      }

      // Vent holes in bottom panel (half) - avoid joiner area and diagonal brace
      // Right side: from joiner_width/2 to brace start
      // Left side: from brace end to -joiner_width/2
      if (side > 0) {
        // Right half: vent from joiner edge to brace
        vent_x_start = joiner_width/2;
        vent_x_end = half_width - panel_thk - brace_width;
        translate([vent_x_start, 0, -1])
          linear_extrude(panel_thk+2)
            vent_grid(vent_x_end - vent_x_start, depth);
      } else {
        // Left half: vent from brace end to joiner edge
        vent_x_start = -half_width + panel_thk + brace_width;
        vent_x_end = -joiner_width/2;
        translate([vent_x_start, 0, -1])
          linear_extrude(panel_thk+2)
            vent_grid(vent_x_end - vent_x_start, depth);
      }

      // Vent holes in front panel (below and above sled area)
      // Below sled slots
      if (sled_z_start > vent_margin * 2 + vent_hole_size) {
        if (side > 0) {
          translate([0, front_panel_thk+1, 0])
            rotate([90, 0, 0])
              linear_extrude(front_panel_thk+2)
                vent_grid(half_width/2, sled_z_start);
        } else {
          translate([-half_width/2, front_panel_thk+1, 0])
            rotate([90, 0, 0])
              linear_extrude(front_panel_thk+2)
                vent_grid(half_width/2, sled_z_start);
        }
      }
      // Above sled slots
      top_space = rack_height - sled_z_start - pc_height;
      if (top_space > vent_margin * 2 + vent_hole_size) {
        if (side > 0) {
          translate([0, front_panel_thk+1, sled_z_start + pc_height])
            rotate([90, 0, 0])
              linear_extrude(front_panel_thk+2)
                vent_grid(half_width/2, top_space);
        } else {
          translate([-half_width/2, front_panel_thk+1, sled_z_start + pc_height])
            rotate([90, 0, 0])
              linear_extrude(front_panel_thk+2)
                vent_grid(half_width/2, top_space);
        }
      }

      // Mini PC sled cutouts for this half
      // Right half: keystones on left of PC (toward center), slots go outward
      // Left half: keystones on right of PC (toward center), slots go outward
      for (i = [0:num_pcs_per_half-1]) {
        // Calculate slot position - going outward from join area
        slot_base = side > 0 
          ? sled_offset + i * slot_pitch
          : -sled_offset - (i + 1) * slot_pitch;
        
        // PC position within slot: keystone first (toward center), then PC
        pc_x = side > 0 
          ? slot_base + keystone_column_width  // keystones on left, PC on right
          : slot_base;  // PC on left, keystones on right
        
        translate([pc_x, -1, sled_z_start])
          cube([pc_width, sled_depth + 1, pc_height]);
      }
      
      // Keystone jack cutouts - 3 per slot, stacked vertically
      // Keystones are between the join area and the PC slot
      for (i = [0:num_pcs_per_half-1]) {
        slot_base = side > 0 
          ? sled_offset + i * slot_pitch
          : -sled_offset - (i + 1) * slot_pitch;
        
        // Keystone column position: between join and PC
        keystone_center_x = side > 0 
          ? slot_base + keystone_column_width/2  // left of PC
          : slot_base + pc_width + keystone_column_width/2;  // right of PC
        
        keystone_z_center = sled_z_start + pc_height/2;
        
        // 3 keystones stacked vertically, centered on slot height
        keystone_v_spacing = keystone_front_height + 4;
        keystone_start_z = keystone_z_center - (keystones_per_slot - 1) * keystone_v_spacing / 2;
        
        for (j = [0:keystones_per_slot-1]) {
          keystone_z = keystone_start_z + j * keystone_v_spacing;
          translate([keystone_center_x, 0, keystone_z])
            keystone_jack_slot();
        }
      }

      // Screw holes for sled mounting
      for (i = [0:num_pcs_per_half-1]) {
        slot_base = side > 0 
          ? sled_offset + i * slot_pitch
          : -sled_offset - (i + 1) * slot_pitch;
        
        pc_x = side > 0 
          ? slot_base + keystone_column_width + pc_width/2
          : slot_base + pc_width/2;
        
        // Top screw hole
        translate([pc_x, front_panel_thk/2, sled_z_start + pc_height + 5])
          rotate([90, 0, 0])
            cylinder(h=front_panel_thk+2, d=screw_hole_dia, center=true);
        // Bottom screw hole
        translate([pc_x, front_panel_thk/2, sled_z_start - 5])
          rotate([90, 0, 0])
            cylinder(h=front_panel_thk+2, d=screw_hole_dia, center=true);
      }
      
      // Join bolt holes - horizontal through both halves
      join_bolt_holes(side);
      
      // Joiner plate screw holes in bottom panel - evenly distributed along full depth
      // Joiner starts after front panel and ribs
      joiner_start = front_panel_thk + rib_height;
      joiner_depth = depth - joiner_start;
      num_joiner_screws = floor((joiner_depth - 2*joiner_screw_inset) / 50) + 1;  // approx every 50mm
      screw_spacing = (joiner_depth - 2*joiner_screw_inset) / (num_joiner_screws - 1);
      for (i = [0:num_joiner_screws-1]) {
        translate([side > 0 ? joiner_width/4 : -joiner_width/4, joiner_start + joiner_screw_inset + i * screw_spacing, -1])
          cylinder(h=panel_thk+2, d=screw_hole_dia);
      }
    }

    // Diagonal brace with diagonal supports (print-friendly when front face down)
    // Skip if test_no_bracing or test_front_only
    if (!test_no_bracing && !test_front_only) {
      // Position at outer edge of panel, past all slots
      brace_x = side > 0 ? half_width - brace_width : -half_width;
      
      // Main diagonal brace
      translate([brace_x, 0, 0])
        hull() {
          // Top front - joins to back of top of front panel
          translate([0, front_panel_thk + rib_height, rack_height - brace_thk])
            cube([brace_width, brace_thk, brace_thk]);
          // Bottom back
          translate([0, depth - brace_thk, 0])
            cube([brace_width, brace_thk, brace_thk]);
        }
      
      // Diagonal supports along the main brace - same angle as main brace
      // These go from bottom panel diagonally up following the exact brace angle
      brace_run = depth - front_panel_thk - rib_height - brace_thk;  // horizontal length of brace
      brace_rise = rack_height - brace_thk;  // vertical rise of brace
      brace_angle_ratio = brace_rise / brace_run;  // rise per unit run
      
      for (i = [1:brace_vert_supports]) {
        // Calculate position along the brace where support meets it
        t = i / (brace_vert_supports + 1);
        y_top = front_panel_thk + rib_height + t * brace_run;
        z_top = rack_height - brace_thk - t * brace_rise;
        
        // Calculate bottom position - same angle as main brace
        // Support goes from (y_bottom, 0) to (y_top, z_top) at same angle
        // Clamp to not go in front of front panel + ribs
        y_bottom_calc = y_top - z_top / brace_angle_ratio;
        y_bottom = max(y_bottom_calc, front_panel_thk + rib_height);
        
        // Diagonal support from bottom panel to brace (same angle as main brace)
        translate([brace_x, 0, 0])
          hull() {
            // Bottom point
            translate([0, y_bottom, 0])
              cube([brace_width, brace_vert_width, brace_thk]);
            // Top point (at the main brace)
            translate([0, y_top, z_top])
              cube([brace_width, brace_vert_width, brace_thk]);
          }
      }
    }
  }
}

// Bottom joiner plate (printed separately, joins both halves along the bottom)
// Front panel joining is handled by dovetails and screws on the rack halves
// Joiner starts after front panel ribs - front panel has its own support ribs
module bottom_joiner() {
  // Calculate number of screw holes along depth (starting after front panel and ribs)
  joiner_start = front_panel_thk + rib_height;  // start after front panel and ribs
  joiner_depth = depth - joiner_start;  // remaining depth
  num_joiner_screws = floor((joiner_depth - 2*joiner_screw_inset) / 50) + 1;  // approx every 50mm
  screw_spacing = (joiner_depth - 2*joiner_screw_inset) / (num_joiner_screws - 1);
  
  difference() {
    union() {
      // Main joiner plate running from behind front panel ribs to back
      translate([-joiner_width/2, joiner_start, 0])
        cube([joiner_width, joiner_depth, joiner_thk]);
    }
    
    // Screw holes for left half - evenly distributed along full depth
    for (i = [0:num_joiner_screws-1]) {
      translate([-joiner_width/4, joiner_start + joiner_screw_inset + i * screw_spacing, -1])
        cylinder(h=joiner_thk+3, d=screw_hole_dia);
    }
    
    // Screw holes for right half - evenly distributed along full depth
    for (i = [0:num_joiner_screws-1]) {
      translate([joiner_width/4, joiner_start + joiner_screw_inset + i * screw_spacing, -1])
        cylinder(h=joiner_thk+3, d=screw_hole_dia);
    }
  }
}

// --------------------
// Render based on print_part setting
// --------------------
if (print_part == "left") {
  rack_half(-1);
} else if (print_part == "right") {
  rack_half(1);
} else if (print_part == "joiner") {
  // Rotate joiner flat for printing
  rotate([0, 0, 0])
    bottom_joiner();
} else if (print_part == "front_face") {
  // Front face only - both halves, just front panel
  translate([-half_spacing/2, 0, 0])
    rack_half(-1);
  translate([half_spacing/2, 0, 0])
    rack_half(1);
} else if (print_part == "no_face") {
  // All without front face
  translate([-half_spacing/2, 0, 0])
    rack_half(-1);
  translate([half_spacing/2, 0, 0])
    rack_half(1);
  color("blue", 0.8)
    translate([0, 0, panel_thk])
      bottom_joiner();
} else if (print_part == "no_bottom") {
  // All without bottom panel
  translate([-half_spacing/2, 0, 0])
    rack_half(-1);
  translate([half_spacing/2, 0, 0])
    rack_half(1);
} else if (print_part == "no_bracing") {
  // All without diagonal braces
  translate([-half_spacing/2, 0, 0])
    rack_half(-1);
  translate([half_spacing/2, 0, 0])
    rack_half(1);
  color("blue", 0.8)
    translate([0, 0, panel_thk])
      bottom_joiner();
} else if (print_part == "join_test") {
  // Both join pieces together for test fitting
  translate([-half_spacing/2, 0, 0])
    rack_half(-1);
  translate([half_spacing/2, 0, 0])
    rack_half(1);
} else if (print_part == "join_test_left") {
  // Left join piece only for printing
  rack_half(-1);
} else if (print_part == "join_test_right") {
  // Right join piece only for printing
  rack_half(1);
} else {
  // Show both halves assembled with joiner ("both" or default)
  translate([-half_spacing/2, 0, 0])
    rack_half(-1);
  translate([half_spacing/2, 0, 0])
    rack_half(1);
  
  // Show joiner in position (on top of bottom panel)
  color("blue", 0.8)
    translate([0, 0, panel_thk])
      bottom_joiner();
}
