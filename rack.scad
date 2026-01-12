// 3U Mini-PC Rackmount – Split for 250mm Print Bed
// Front ears, square rack holes (M6 cage nuts)
// Mini PC sled cutouts for vertical mounting
// Two halves join with M3 screws via bottom joiner plate

$fn = 64;

// --------------------
// Print Selection
// --------------------
// Set which part to render:
// Available options: "left", "right", "joiner", "both"
//   "left"   = left half of rack (for printing)
//   "right"  = right half of rack (for printing)
//   "joiner" = bottom joiner plate that joins both halves (for printing)
//   "both"   = show assembled view (for preview, not for printing)
print_part = "both";  // OPTIONS: "left", "right", "joiner", "both"
half_spacing = 0;     // gap between halves when showing both (0 for assembled view)

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
brace_width = 25;        // increased for more strength
brace_thk = 5;
brace_vert_supports = 3;  // number of vertical supports along brace
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
join_flange_width = 20;   // width of join tabs
join_flange_height = 25;  // height of each tab
join_flange_thk = 8;      // how far tabs extend into other half (overlap)
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

// Dovetail joint dimensions for front panel connection
dovetail_width = 8;       // width at narrow end
dovetail_depth = 6;       // how deep the dovetail goes into panel
dovetail_angle = 15;      // angle of dovetail sides (degrees)
dovetail_height = 20;     // height of each dovetail
dovetail_spacing = 35;    // spacing between dovetails
dovetail_clearance = 0.3; // clearance for fit
num_dovetails = 3;        // number of dovetails along front panel height

// Calculate how many PCs fit
num_pcs_total = floor((body_width - 20) / (pc_width + sled_wall));
num_pcs_per_half = floor(num_pcs_total / 2);
num_pcs = num_pcs_per_half * 2;  // total sleds

// Calculate centered sled positions
// Center the sleds within each half, leaving gap at center for joiner
sled_offset = 15;  // offset from center to leave room for joining
half_width = body_width / 2;

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

// Dovetail profile (2D) - trapezoidal shape
module dovetail_profile(width, depth, angle, clearance=0) {
  // Width at base (wider), width at top (narrower due to angle)
  top_width = width;
  bottom_width = width + 2 * depth * tan(angle);
  
  polygon([
    [-(bottom_width/2 + clearance), 0],
    [-(top_width/2 + clearance), depth + clearance],
    [(top_width/2 + clearance), depth + clearance],
    [(bottom_width/2 + clearance), 0]
  ]);
}

// Male dovetail (protrusion) - for right half
module dovetail_male(height) {
  rotate([90, 0, 0])
    rotate([0, 90, 0])
      linear_extrude(height)
        dovetail_profile(dovetail_width, dovetail_depth, dovetail_angle);
}

// Female dovetail (cutout) - for left half
module dovetail_female(height) {
  rotate([90, 0, 0])
    rotate([0, 90, 0])
      linear_extrude(height + 0.1)
        dovetail_profile(dovetail_width, dovetail_depth, dovetail_angle, dovetail_clearance);
}

// Module for one half of the rack
// side = 1 for right half, -1 for left half
module rack_half(side) {
  sled_z_start = (rack_height - pc_height) / 2;
  
  // Calculate sled start position - centered with offset from middle
  sled_area_width = num_pcs_per_half * (pc_width + sled_wall) - sled_wall;
  sled_start = side > 0 ? sled_offset : -(sled_offset + sled_area_width);
  
  union() {
    difference(){
      // Main structure
      union(){
        // Bottom panel (half)
        translate([side > 0 ? 0 : -half_width, 0, 0])
          cube([half_width, depth, panel_thk]);

        // Front panel (half, thicker for strength)
        translate([side > 0 ? 0 : -half_width, 0, 0])
          cube([half_width, front_panel_thk, rack_height]);

        // Horizontal reinforcement ribs on back of front panel
        // Top rib (half)
        translate([side > 0 ? 0 : -half_width, front_panel_thk, rack_height - rib_width])
          cube([half_width, rib_height, rib_width]);
        // Bottom rib (half)
        translate([side > 0 ? 0 : -half_width, front_panel_thk, 0])
          cube([half_width, rib_height, rib_width]);
        
        // Vertical ribs for sled slots on this half
        for (i = [0:num_pcs_per_half]) {
          rib_x = sled_start + i * (pc_width + sled_wall) - sled_wall/2;
          translate([rib_x - rib_width/2, front_panel_thk, 0])
            cube([rib_width, rib_height, rack_height]);
        }

        // Front ear
        if (side > 0) {
          translate([rack_width/2 - ear_width, 0, 0])
            cube([ear_width, ear_thk, rack_height]);
          // Bottom triangular gusset for ear support
          translate([half_width - panel_thk, 0, 0])
            hull() {
              cube([panel_thk, ear_thk, ear_gusset_height]);
              cube([panel_thk, ear_gusset_depth, panel_thk]);
            }
          // Top triangular gusset for ear support
          translate([half_width - panel_thk, 0, rack_height - ear_gusset_height])
            hull() {
              cube([panel_thk, ear_thk, ear_gusset_height]);
              translate([0, 0, ear_gusset_height - panel_thk])
                cube([panel_thk, ear_gusset_depth, panel_thk]);
            }
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
          translate([-rack_width/2, 0, 0])
            cube([ear_width, ear_thk, rack_height]);
          // Bottom triangular gusset for ear support
          translate([-half_width, 0, 0])
            hull() {
              cube([panel_thk, ear_thk, ear_gusset_height]);
              cube([panel_thk, ear_gusset_depth, panel_thk]);
            }
          // Top triangular gusset for ear support
          translate([-half_width, 0, rack_height - ear_gusset_height])
            hull() {
              cube([panel_thk, ear_thk, ear_gusset_height]);
              translate([0, 0, ear_gusset_height - panel_thk])
                cube([panel_thk, ear_gusset_depth, panel_thk]);
            }
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
        
        // Dovetail joints on front panel edge (right half has male dovetails)
        // Positioned to be flush with front face
        if (side > 0) {
          for (i = [0:num_dovetails-1]) {
            z_pos = (rack_height / (num_dovetails + 1)) * (i + 1);
            translate([0, dovetail_depth, z_pos - dovetail_height/2])
              dovetail_male(dovetail_height);
          }
        }
        
        // Inner faceplate screw tabs - overlap tabs that extend into own side's rib structure
        // Right half has tabs extending left (negative X) for overlap
        // Left half has tabs extending right (positive X) for overlap
        // Both extend from center edge to first vertical rib on their OWN side
        
        // First vertical rib position (closest to center on each side)
        first_rib_center = sled_start - sled_wall/2;  // center of first rib
        // For right side (side > 0): first_rib_center is positive, tab goes from -join_flange_thk to first_rib_center + rib_width/2
        // For left side (side < 0): first_rib_center is negative, tab goes from first_rib_center - rib_width/2 to join_flange_thk
        
        // Calculate full tab extent
        tab_inner_edge = side > 0 ? -join_flange_thk : first_rib_center - rib_width/2;
        tab_outer_edge = side > 0 ? first_rib_center + rib_width/2 : join_flange_thk;
        tab_full_width = tab_outer_edge - tab_inner_edge;
        
        // Top screw tab - full width from overlap to first vertical rib
        translate([tab_inner_edge, front_panel_thk, rack_height - rib_width - join_flange_height])
          cube([tab_full_width, rib_height, join_flange_height + rib_width]);
        // Front panel backing for top tab
        translate([tab_inner_edge, 0, rack_height - rib_width - join_flange_height])
          cube([tab_full_width, front_panel_thk, join_flange_height + rib_width]);
        
        // Middle screw tab - full width from overlap to first vertical rib
        translate([tab_inner_edge, front_panel_thk, rack_height/2 - join_flange_height/2])
          cube([tab_full_width, rib_height, join_flange_height]);
        // Front panel backing for middle tab
        translate([tab_inner_edge, 0, rack_height/2 - join_flange_height/2])
          cube([tab_full_width, front_panel_thk, join_flange_height]);
        // Bottom screw tab - full width from overlap to first vertical rib
        translate([tab_inner_edge, front_panel_thk, 0])
          cube([tab_full_width, rib_height, rib_width + join_flange_height]);
        // Front panel backing for bottom tab
        translate([tab_inner_edge, 0, 0])
          cube([tab_full_width, front_panel_thk, rib_width + join_flange_height]);
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

      // Vent holes in bottom panel (half) - avoid joiner area
      translate([side > 0 ? joiner_width/2 : -half_width, 0, -1])
        linear_extrude(panel_thk+2)
          vent_grid(half_width - joiner_width/2, depth);

      // Vent holes in front panel (below and above sled area)
      // Below sled slots
      if (sled_z_start > vent_margin * 2) {
        translate([side > 0 ? half_width/4 : -half_width/4, front_panel_thk+1, sled_z_start/2])
          rotate([90, 0, 0])
            linear_extrude(front_panel_thk+2)
              vent_grid(half_width/2, sled_z_start);
      }
      // Above sled slots
      top_space = rack_height - sled_z_start - pc_height;
      if (top_space > vent_margin * 2) {
        translate([side > 0 ? half_width/4 : -half_width/4, front_panel_thk+1, sled_z_start + pc_height + top_space/2])
          rotate([90, 0, 0])
            linear_extrude(front_panel_thk+2)
              vent_grid(half_width/2, top_space);
      }

      // Mini PC sled cutouts for this half (centered)
      for (i = [0:num_pcs_per_half-1]) {
        slot_x = sled_start + i * (pc_width + sled_wall);
        translate([slot_x, -1, sled_z_start])
          cube([pc_width, sled_depth + 1, pc_height]);
      }

      // Screw holes for sled mounting
      for (i = [0:num_pcs_per_half-1]) {
        slot_x = sled_start + i * (pc_width + sled_wall) + pc_width/2;
        // Top screw hole
        translate([slot_x, front_panel_thk/2, sled_z_start + pc_height + 5])
          rotate([90, 0, 0])
            cylinder(h=front_panel_thk+2, d=screw_hole_dia, center=true);
        // Bottom screw hole
        translate([slot_x, front_panel_thk/2, sled_z_start - 5])
          rotate([90, 0, 0])
            cylinder(h=front_panel_thk+2, d=screw_hole_dia, center=true);
      }
      
      // Female dovetail cutouts (left half only)
      if (side < 0) {
        for (i = [0:num_dovetails-1]) {
          z_pos = (rack_height / (num_dovetails + 1)) * (i + 1);
          translate([0, dovetail_depth, z_pos - dovetail_height/2 - dovetail_clearance])
            dovetail_female(dovetail_height + 2*dovetail_clearance);
        }
      }
      
      // Optional screw holes through dovetail joints (both halves)
      for (i = [0:num_dovetails-1]) {
        z_pos = (rack_height / (num_dovetails + 1)) * (i + 1);
        // Horizontal screw hole through the dovetail joint from back
        translate([side > 0 ? -dovetail_depth - 1 : dovetail_depth + 1, dovetail_depth + 2, z_pos])
          rotate([0, 90, 0])
            cylinder(h=dovetail_depth + 4, d=screw_hole_dia);
      }
      
      // Inner faceplate screw holes - vertical holes through overlapping tabs
      // These go through both tabs when halves are assembled (in the overlap portion near center)
      screw_x = side > 0 ? -join_flange_thk/2 : join_flange_thk/2;
      
      // Top tab screw hole
      translate([screw_x, front_panel_thk + rib_height/2, rack_height - rib_width - join_flange_height/2])
        cylinder(h=join_flange_thk + 2, d=screw_hole_dia, center=true);
      // Middle tab screw hole
      translate([screw_x, front_panel_thk + rib_height/2, rack_height/2])
        cylinder(h=join_flange_thk + 2, d=screw_hole_dia, center=true);
      // Bottom tab screw hole
      translate([screw_x, front_panel_thk + rib_height/2, rib_width + join_flange_height/2])
        cylinder(h=join_flange_thk + 2, d=screw_hole_dia, center=true);
      
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

    // Diagonal brace with vertical supports
    brace_x = side > 0 ? half_width - panel_thk - brace_width : -half_width + panel_thk;
    
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
    
    // Vertical supports along the diagonal brace
    brace_run = depth - front_panel_thk - rib_height - brace_thk;  // horizontal length of brace
    brace_rise = rack_height - brace_thk;  // vertical rise of brace
    for (i = [1:brace_vert_supports]) {
      // Calculate position along the brace
      t = i / (brace_vert_supports + 1);
      y_pos = front_panel_thk + rib_height + t * brace_run;
      z_top = rack_height - brace_thk - t * brace_rise;
      
      // Vertical support from bottom panel to brace
      translate([brace_x + brace_width/2 - brace_vert_width/2, y_pos - brace_vert_width/2, 0])
        cube([brace_vert_width, brace_vert_width, z_top + brace_thk]);
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
} else {
  // Show both halves assembled with joiner
  translate([-half_spacing/2, 0, 0])
    rack_half(-1);
  translate([half_spacing/2, 0, 0])
    rack_half(1);
  
  // Show joiner in position (on top of bottom panel)
  color("blue", 0.8)
    translate([0, 0, panel_thk])
      bottom_joiner();
}
