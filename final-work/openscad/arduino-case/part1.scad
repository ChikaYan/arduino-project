$fn=50;

xCase=90;
yCase=65;
zCase=9;
xArd=78;
yArd=57;
zArd=7;
difference(){
    translate([-6,0,0]){
        cube([xCase,yCase,zCase]);
    }
    //create space for Arduino main body
    translate([-0.1,(yCase-yArd)/2,-0.1]){
        cube([xArd+0.1,yArd,zArd+0.1]);
    }
    translate([35,2,-0.1]){
        cube([3,2.1,zArd+0.1]);
    }
    translate([-3,7,-0.1]){
        cube([3,39,zArd+0.1]);
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
    cylinder(zArd+0.5,1,1);
    }
    translate([73,yCase-8,0]){
    cylinder(zArd+0.5,1,1);
    }
}

//add cylinders and blocks to fit holes in Arduino
translate([40,2+yArd,0]){
    cube([3,2,zArd]);
}
translate([50,yCase-7,0]){
    cylinder(zArd,1,1);
}
translate([50,7,0]){
    cylinder(zArd,1,1);
}
translate([3,10,0]){
    cylinder(zArd,1,1);
}
translate([3,38,0]){
    cylinder(zArd,1,1);
}




