resolution = 60;

knob_top_height = 10;
knob_base_height = 10;
knob_top_diameter = 2 * 25.4;
knob_base_diameter = 17;
knurl_radius = 3;
knurls = 20;
hole = 6.4; // 6.35mm + locational clearance
cut = 6.1; // 5.85mm +- 0.15mm + localtional clearance
m4_thickness = 2.9;
m4_width = 6.9;
m4_hole = 4.5;
roundover = 4;

angle = 360/knurls;
radius = knob_base_diameter/2;
wall = (knob_base_diameter - hole)/2;

echo( "angle = ", angle );
echo( "radius = ", radius );
echo( "wall = ", wall );

module shaft( diameter, height, cut_width, resolution ) {
    difference() {
        cylinder( d=diameter, height, center=true, $fn=resolution );
        translate([ -diameter/2+cut_width, -diameter/2+0.5, -height/2-0.5 ]) {
            cube([ diameter-cut_width+1, diameter+1, height+1 ]);
        }
    }
}

// knob base
difference() {
    // main body
    union() {
        cylinder( d=knob_base_diameter, h=knob_base_height, center=true, $fn=resolution );
        translate([ 0, 0, knob_base_height/2 + knob_top_height/2 ]) {
            minkowski() {
                cylinder( d=knob_top_diameter, h=knob_top_height-roundover*2, center=true, $fn=resolution );
                rotate([ 90, 0, 0 ]) {
                    sphere( d=roundover*2, center=true );
                }
            }
        }
    }
    translate([ 0, 0, knob_base_height/2 ]) {
        shaft( hole, knob_base_height+knob_top_height+1, cut, resolution );
    }
    
    // grub nut hole
    translate([ hole/2 + wall*5/12, 0, 0 ]) {
        cube([ m4_thickness, m4_width, knob_base_height+1 ], center=true );
    }
    
    // grub screw hole
    translate([ hole/2 + wall/2, 0, 0 ]) {
        rotate([ 0, 90, 0 ]) {
            cylinder( d=m4_hole, h=wall+2, $fn=resolution, center=true );
        }
    }
    
    // knurling
    translate([ 0, 0, knob_base_height/2 + knob_top_height/2 ]) {
        for (angle = [0 : angle : 360]) {
            rotate([0,0,angle]) {
                translate([ knob_top_diameter/2+roundover, 0, 0 ]) {
                    cylinder( h=knob_top_height+1, r=knurl_radius, center=true, $fn=resolution );
                }
            }
        }
    }
}