module board( size, label = false ) {
    // size[0] is always with the grain.
    // size[1] is against the grain.
    // size[2] is the board thickness.
    
    cube( size = size );
    
    // Output the size of the board for easy cut lists.
    echo( str( size[2], " ", label, ": ", size[0], "x", size[1]));
}

width_of_can = 11;
height_of_can = 20;
depth_of_can = 15.5;
number_of_cans = 2;
bead_board_inset = 1/2;
bead_board_thickness = 1/8;
lid_overhang_front = 1.5;  // Overhang for the lid front
lid_overhang_sides = .75; // Overhang for the lid sides
lid_overhang_back = .75; // Overhang for the back of the lid.

toe_clearance = 2; // Space between the bottom board and the floor.
stock_thickness = 3/4;
cabinet_door_clearance = 1/8;

horizontal_can_clearance = 1;
vertical_can_clearance = 3;
depth_can_clearance = 1; // Space behind cans.

each_can_cabinet_door_width = width_of_can + horizontal_can_clearance + horizontal_can_clearance;

each_can_cabinet_door_height =
    stock_thickness // The base of the tilting door.
    + sqrt( ( height_of_can * height_of_can ) + ( depth_of_can * depth_of_can ) ) // The longest diagonal across the can.
    + vertical_can_clearance // Extra space for clearance and garbage at the top.
    ;

face_frame_width = 1.5;
depth_of_box = depth_of_can + depth_can_clearance;

width_of_horizontal_base =
    (number_of_cans * ( each_can_cabinet_door_width + cabinet_door_clearance + cabinet_door_clearance ) ) // Space for doors and clearance.
    + ((number_of_cans + 1 ) * face_frame_width) // Space for the surrounding face frames
    - stock_thickness - stock_thickness // Minus the width of the end boards.
    ;

translate([0, depth_of_box+stock_thickness, 0]) rotate([-40 * $t, 0, 0]) translate([0, -depth_of_box-stock_thickness, 0]) union() {
    color( "white" ) {
    translate([0, depth_of_box + stock_thickness, 0])
    for (can_number=[0:number_of_cans-1]){
        // Cabinet doors.
        translate([
            ( can_number * ( each_can_cabinet_door_width + cabinet_door_clearance + face_frame_width + cabinet_door_clearance ) ),
            0,
            0
         ])
            rotate([90, 0, 0])
            union() {
                    // Base that holds the can.
        translate([width_of_can + ((each_can_cabinet_door_width - width_of_can) / 2), stock_thickness, stock_thickness]) 
            rotate([0, -90, 90])
            board( [ depth_of_can, width_of_can, stock_thickness], "can base" );
           
                // Base sides
                translate([((each_can_cabinet_door_width - width_of_can) / 2), 0, stock_thickness]) rotate([0, -90, 0]) board( [ depth_of_can, depth_of_box - depth_can_clearance, stock_thickness ], "can sides (combined)" );
            
                // Bottom board.
                translate([face_frame_width, 0, 0])
                    board([ each_can_cabinet_door_width - (face_frame_width * 2), face_frame_width, stock_thickness], "door face frame" );
            
                // Top Board.
                translate([face_frame_width, each_can_cabinet_door_height - face_frame_width, 0])
                    board([ each_can_cabinet_door_width - (face_frame_width * 2), face_frame_width, stock_thickness], "door face frame" );
            
                // Left board.
                translate([face_frame_width, 0, 0] )
                    rotate( [0, 0, 90 ] )
                    board( [ each_can_cabinet_door_height, face_frame_width, stock_thickness ], "door face frame" );
            
                // Right board.
                translate([each_can_cabinet_door_width, 0, 0] )
                    rotate( [0, 0, 90 ] )
                    board( [ each_can_cabinet_door_height, face_frame_width, stock_thickness ], "door face frame" );
            
                // Inset.
                color( "white" ) translate([each_can_cabinet_door_width - face_frame_width + bead_board_inset, face_frame_width - bead_board_inset, ( (stock_thickness - bead_board_thickness ) / 2) ])
                    rotate([0, 0, 90])
                    board([ each_can_cabinet_door_height + ( bead_board_inset * 2 ) - face_frame_width - face_frame_width, each_can_cabinet_door_width + ( bead_board_inset * 2 ) - face_frame_width - face_frame_width, bead_board_thickness], "beadboard" );
    }
}}
    // Mock up the cans.
    color( "orange") for (can_number=[0:number_of_cans-1]) {
        translate([
            ((each_can_cabinet_door_width - width_of_can) / 2)
    
        + (can_number * (each_can_cabinet_door_width + cabinet_door_clearance + cabinet_door_clearance + face_frame_width ) )
    
        ,
            0, stock_thickness
        ])
            cube([width_of_can, depth_of_can, height_of_can]);
    }

}{

// Bottom support board.
color( "white" ) translate([
    -cabinet_door_clearance + stock_thickness - face_frame_width,
    0,
    -stock_thickness - cabinet_door_clearance
    ])
    board( [ width_of_horizontal_base, depth_of_box, stock_thickness ], "box frame (bottom)" );

// Near side.
color( "white" ) translate( [ stock_thickness - cabinet_door_clearance - face_frame_width + width_of_horizontal_base + stock_thickness, 0, -toe_clearance - stock_thickness - cabinet_door_clearance ] )
rotate( [ 0, -90, 0 ] )
    board( [
        toe_clearance + stock_thickness + cabinet_door_clearance + each_can_cabinet_door_height + cabinet_door_clearance + face_frame_width,
        depth_of_box,
        stock_thickness
    ], "box frame" );

// Far side
color( "white" ) translate( [ -cabinet_door_clearance + stock_thickness - face_frame_width, 0, -toe_clearance - stock_thickness - cabinet_door_clearance ] )
rotate( [ 0, -90, 0 ] )
    board( [
        toe_clearance + stock_thickness + cabinet_door_clearance + each_can_cabinet_door_height + cabinet_door_clearance + face_frame_width,
        depth_of_box,
        stock_thickness
    ], "box frame" );

// Top
color( "tan" ) translate([
    -(face_frame_width - stock_thickness) - stock_thickness - lid_overhang_sides - cabinet_door_clearance,
    -lid_overhang_back,
    -stock_thickness - cabinet_door_clearance + cabinet_door_clearance + each_can_cabinet_door_height + cabinet_door_clearance + stock_thickness + face_frame_width
    ])
    board( [ width_of_horizontal_base + stock_thickness + stock_thickness + lid_overhang_sides + lid_overhang_sides, depth_of_box + lid_overhang_front + lid_overhang_back + stock_thickness, stock_thickness ], "box frame top" );
    
// Vertical dividers.
color( "white" ) for (can_number = [0:number_of_cans-2]) {
    translate([
        stock_thickness
        + each_can_cabinet_door_width
        - (stock_thickness/2)
        + ((face_frame_width + cabinet_door_clearance + cabinet_door_clearance)/2)
        // Everything above is to place the first one after the first door.
        // The rest is to shift every next divider over the equivalent number of full door widths.
        + ( 
            can_number *
            (
                each_can_cabinet_door_width
                + cabinet_door_clearance
                + cabinet_door_clearance
                + face_frame_width
            )
        )
        ,
        0,
        -cabinet_door_clearance])
    rotate([0, -90, 0])
        board( [ each_can_cabinet_door_height + cabinet_door_clearance + cabinet_door_clearance + face_frame_width, depth_of_box, stock_thickness ], "box frame (interior vertical)" );
}

// Face frame

// Near stile
color( "white" ) translate([-cabinet_door_clearance - face_frame_width, depth_of_box, -cabinet_door_clearance - stock_thickness - toe_clearance]) 
rotate([0, -90, -90])
    board([toe_clearance + stock_thickness + cabinet_door_clearance + each_can_cabinet_door_height + cabinet_door_clearance + face_frame_width, face_frame_width, stock_thickness], "face frame");

// Far stile
color( "white" ) translate([-cabinet_door_clearance - face_frame_width - ( face_frame_width - stock_thickness) + width_of_horizontal_base + stock_thickness, depth_of_box, -cabinet_door_clearance - stock_thickness - toe_clearance]) 
rotate([0, -90, -90])
    board([toe_clearance + stock_thickness + cabinet_door_clearance + each_can_cabinet_door_height + cabinet_door_clearance + face_frame_width, face_frame_width, stock_thickness], "face frame");

// Bottom rail
color( "white" ) translate([-cabinet_door_clearance, depth_of_box, -cabinet_door_clearance - face_frame_width])
    translate([0, stock_thickness, 0]) rotate([90, 0, 0]) board([width_of_horizontal_base - ((face_frame_width - stock_thickness) * 2), face_frame_width, stock_thickness], "face frame");

// Top rail
color( "white" ) translate([-cabinet_door_clearance, depth_of_box, -cabinet_door_clearance - face_frame_width + each_can_cabinet_door_height + cabinet_door_clearance + cabinet_door_clearance + face_frame_width])
    translate([0, stock_thickness, 0]) rotate([90, 0, 0]) board([width_of_horizontal_base - ((face_frame_width - stock_thickness) * 2), face_frame_width, stock_thickness], "face frame");

// Vertical stiles.
color( "white" ) for (can_number = [0:number_of_cans-2]) {
    translate([
        stock_thickness
        + each_can_cabinet_door_width
        - (stock_thickness/2)
        + ((face_frame_width + cabinet_door_clearance + cabinet_door_clearance)/2)
        - stock_thickness
        - ( ( face_frame_width - stock_thickness ) / 2 )
        // Everything above is to place the first one after the first door.
        // The rest is to shift every next divider over the equivalent number of full door widths.
        + ( 
            can_number *
            (
                each_can_cabinet_door_width
                + cabinet_door_clearance
                + cabinet_door_clearance
                + face_frame_width
            )
        )
        ,
        depth_of_box,
        -cabinet_door_clearance])
    rotate([0, -90, -90])
        board( [ each_can_cabinet_door_height + cabinet_door_clearance + cabinet_door_clearance, face_frame_width, stock_thickness ], "face frame (interior vertical)" );
}
}