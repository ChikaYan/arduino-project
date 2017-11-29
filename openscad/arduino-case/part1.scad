$fn=50;

X_CASE=90;
Y_CASE=65;
Z_CASE=9;
X_ARD=78;
Y_ARD=57;
Z_ARD=7;

module ArdCylinder(){
    //cylinders that fit into holes in Arduino board
    cylinder(Z_ARD,1,1);
}

module CylinderHole(){
    //used to create holes for cylinders on part2 to fit in
    cylinder(Z_ARD+0.5,1,1);
}

difference(){
    translate([-6,0,0]){
        cube([X_CASE,Y_CASE,Z_CASE]);
    }
    //create space for Arduino main body
    translate([-0.1,(Y_CASE-Y_ARD)/2,-0.1]){
        cube([X_ARD+0.1,Y_ARD,Z_ARD+0.1]);
    }
    translate([35,2,-0.1]){
        cube([3,2.1,Z_ARD+0.1]);
    }
    translate([-3,7,-0.1]){
        cube([3,39,Z_ARD+0.1]);
    }
    //create space for part2
    translate([73,2,-0.1]){
    cube([3,2.1,2.4]);
    }
    translate([73,60.9,-0.1]){
    cube([3,2.1,2.4]);
    }
    translate([77.9,16,-0.1]){
    cube([2.1,3,2.4]);
    }
    translate([77.9,45,-0.1]){
    cube([2.1,3,2.4]);
    }
    translate([73,8,0]){
    CylinderHole();
    }
    translate([73,Y_CASE-8,0]){
    CylinderHole();
    }
}

//add cylinders and blocks to fit holes in Arduino
translate([40,2+Y_ARD,0]){
    cube([3,2,Z_ARD]);
}
translate([50,Y_CASE-7,0]){
    ArdCylinder();
}
translate([50,7,0]){
    ArdCylinder();
}
translate([3,10,0]){
    ArdCylinder();
}
translate([3,38,0]){
    ArdCylinder();
}




