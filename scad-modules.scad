use <MCAD/libtriangles.scad>;

module xyc_cube(w,d,h) {
	translate([0,0,h/2]) cube(size=[w,d,h], center=true);
}

module yc_cube(w,d,h) {
	translate([w/2,0,h/2]) cube(size=[w,d,h], center=true);
}

module xc_cube(w,d,h) {
	translate([0,d/2,h/2]) cube(size=[w,d,h], center=true);
}

module hole(r,h) {
	translate([0,0,-1]) cylinder(r=r,h=h+2);
}

module round_slot(r,h,t) {
	translate([-1,0,0]) {
		for(z=[0,h]) translate([0,0,z]) rotate([0,90,0]) cylinder(r=r,h=t+2);
		yc_cube(t+2,r*2,h);
	}
}

module tx(x) {
	translate([x,0,0]) children();
}

module ty(y) {
	translate([0,y,0]) children();
}

module tz(z) {
	translate([0,0,z]) children();
}

module rx(x) {
	rotate([x,0,0]) children();
}

module ry(y) {
	rotate([0,y,0]) children();
}

module rz(z) {
	rotate([0,0,z]) children();
}

module half_cyl(r,h) {
	intersection() {
		cylinder(r=r,h=h);
		translate([-r,0,0]) cube([2*r,r,h]);
	}
}

module wedge(r,h,a) {
	if(a<=180)
		intersection() {
			half_cyl(r,h);
			rotate(a-180) half_cyl(r,h);
		}
	else union() {
		half_cyl(r,h);
		rotate(180) wedge(r,h,a-180);
	}
}
	
module rect_chamfer(w,d,t) {
	extra=0.01; // Added chamfer beyond edges for clean subtraction
	t_adj=t+extra;
	w_adj=w-extra*2;
	d_adj=d-extra*2;
	
	translate([0,0,extra]) mirror([0,0,1])
		for(i=[0:1]) for(j=[0:1])
			mirror([i,0,0]) mirror([0,j,0]) quarter_rect_chamfer(w_adj,d_adj,t_adj);
}

module quarter_rect_chamfer(w,d,t) {
	translate([w/2,-d/2,0]) {
		rightprism(t,d/2,t);
		translate([0,-t,0]) cornerpyramid(t,t,t);
		rotate([0,0,-90]) translate([0,-w/2,0]) rightprism(t,w/2,t);
	}
}

c_x=[true,false,false];
c_y=[false,true,false];
c_xy=[true,true,false];
c_xz=[true,false,true];
c_yz=[false,true,true];
c_xyz=[true,true,true];
c_none=[false,false,false];

f_x=[1,0,0,1,0,0];
f_y=[0,1,0,0,1,0];
f_z=[0,0,1,0,0,1];
f_xy=[1,1,0,1,1,0];
f_xz=[1,0,1,1,0,1];
f_yz=[0,1,1,0,1,1];
f_xyz=[1,1,1,1,1,1];

f_px=[1,0,0,0,0,0];
f_py=[0,1,0,0,0,0];
f_pz=[0,0,1,0,0,0];
f_pxy=[1,1,0,0,0,0];
f_pxz=[1,0,1,0,0,0];
f_pyz=[0,1,1,0,0,0];
f_pxyz=[1,1,1,0,0,0];

f_nx=[0,0,0,1,0,0];
f_ny=[0,0,0,0,1,0];
f_nz=[0,0,0,0,0,1];
f_nxy=[0,0,0,1,1,0];
f_nxz=[0,0,0,1,0,1];
f_nyz=[0,0,0,0,1,1];
f_nxyz=[0,0,0,1,1,1];

f_h=[1,1];
f_ph=[1,0];
f_nh=[0,1];

module dc_cube(w,d,h,c=[false,false,false],f=[0,0,0,0,0,0]) {
	wp=f[0]; dp=f[1]; hp=f[2]; wn=f[3]; dn=f[4]; hn=f[5];
	
	dw=w+wp+wn;
	dd=d+dp+dn;
	dh=h+hp+hn;
	
	orig_x=c[0] ? -w/2 : 0;
	orig_y=c[1] ? -d/2 : 0;
	orig_z=c[2] ? -h/2 : 0;
	
	translate([orig_x-wn,orig_y-dn,orig_z-hn])
		cube([dw,dd,dh]);
}

module c_cube(w,d,h,c=[false,false,false]) {
	orig_x=c[0] ? -w/2 : 0;
	orig_y=c[1] ? -d/2 : 0;
	orig_z=c[2] ? -h/2 : 0;
	
	translate([orig_x,orig_y,orig_z])
		cube([w,d,h]);
}

module d_cyl(r,h,c=false,f=[0,0]) {
	hp=f[0]; hn=f[1];
	
	orig_z=c ? -h/2 : 0;
	dh=h+hp+hn;
	
	translate([0,0,orig_z-hn])
		cylinder(r=r,h=dh);
}

module box(w,d,h,t,c=[false,false,false]) {
    orig_x=c[0] ? -w/2 : 0;
	orig_y=c[1] ? -d/2 : 0;
	orig_z=c[2] ? -h/2 : 0;

	translate([orig_x,orig_y,orig_z])
        difference() {
            cube([w,d,h]);
            translate([t,t,t])
                cube([w-2*t,d-2*t,h-2*t]);
        }
}
