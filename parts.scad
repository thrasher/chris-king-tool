// all dimensions in millimeters
// see: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#$fa,_$fs_and_$fn
$fs = 2; // minimum size of a circle fragment, default=2, min=0.01
$fa = 15; // a circle has fragments = 360 divided by this number, default=12, min=0.01
$fn = $preview ? 24 : 80; // number of fragments in a circle, when non-zero $fs and $fa are ignored, default=0

MIN_SPACING = 21.2; // 21.2 diameter as measured between pin cuts on hub
ADJUSTER_DIA = 27.84; // 27.84 diameter of frunt hub adjuster as measured
PIN_DIA = 3.15; // 3.15 as measured size of pin on front hub
PIN_HEIGHT = 4;
BODY_DEPTH = 10;
TOOL_THICKNESS = 4;
PIN_RADIUS = (MIN_SPACING + PIN_DIA) / 2;

module pin(h = 4) {
	hull() {
		// pin location
		translate([PIN_RADIUS, 0, 0])
		cylinder(d = PIN_DIA, h = h);
		// tool body
		TB_DIA = (ADJUSTER_DIA + PIN_DIA) / 2;
		translate([TB_DIA, 0, 0])
		cylinder(d = PIN_DIA, h = h);
	}
}
module pins(h = 4) {
	pin(h); // center
	mirror([1,1,0]) pin(h); // bottom
	mirror([1,-1,0]) pin(h); // top
}

module front_socket() {
	pin(10); // center
	mirror([1,1,0]) pin(10); // bottom
	mirror([1,-1,0]) pin(10); // top
	mirror([1,0,0])pin(10); // center

	// cut out space where the pins go
	difference() {
		color("purple") linear_extrude(10) circle(r = 18/cos(180/6), $fn=6);
		cylinder(d = ADJUSTER_DIA, h = TOOL_THICKNESS*6, center = true);
		// cylinder(d = MIN_SPACING, h = 15);
	}
}

module front_wrench() {
	difference() {
		// main handle
		hull() {
			pins();
			// cylinder(d = BODY_DEPTH * 2 + ADJUSTER_DIA, h = TOOL_THICKNESS);
			translate([150, 0, 0])
			cylinder(d = ADJUSTER_DIA/2, h = TOOL_THICKNESS);
		}

		// cut out space where the pins go
		cylinder(d = ADJUSTER_DIA, h = TOOL_THICKNESS*3, center = true);

		// logo to know what the tool is for
		logo();

		// hole for hanging tool
		translate([150, 0, 0])
		cylinder(d = ADJUSTER_DIA/4, h = TOOL_THICKNESS * 3, center = true);

		// cut small version of tool w/just the head for test print
		// translate([75 + 18, 0, 0])
		// cube(150, center = true);
	}


	// add the pins back in
	pins();

	module logo() {
		translate( [ADJUSTER_DIA/2+10, -7.5, TOOL_THICKNESS])
		linear_extrude(height = 1, center = true, convexity = 10, twist = 0, slices = 20, scale = 1.0)
		scale(1.5)
		import("ck-primary-white-w_800x.svg", center = false, dpi = 100);
	}
}

PART = "all";
if (PART == "front_wrench" || PART == "all") {
	echo(str("render ", PART));
	front_wrench();
}
if (PART == "front_socket" || PART == "all") {
	echo(str("render ", PART));
	translate([0, 40, 0])
	front_socket();
}
