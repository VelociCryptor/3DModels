include <bosl2/std.scad>


spoon_sphere=1;
spoon_cylinder=2;
spoon_cube=3;





e=0.01;
pi=3.1415926;
$fn=60;
wall=2;
vols=[0.625,1.25,2.5,3.5,7.5,10,15];  //ml


 prot=6;
handle1=[e,8,4];  //start cube
handle2=[4,11,4]; //end cube

spoon_l=80; // from left of cup to end of handle
slot_z=1;  //depth of slot 


 

fwd(0)
  Spoon(spoon_sphere,2.5);
 
fwd(30)
Spoon(spoon_cylinder,2.5); 

back(30)
  Spoon(spoon_cube,2.5);
    
 
// handle(spoon_l);

module Spoon(SpoonType,volume) {
  if (SpoonType==spoon_sphere) {
    head_sphere(volume)
       ;   
        
     
  }     
  else if (SpoonType==spoon_cylinder) {
    head_cylinder(volume) 
       ; 
     
  } 
  else if (SpoonType==spoon_cube) {
      head_cube(volume) 
         ;
   
  };  
    
    
    
};    


function bodyx(SpoonType) = SpoonType==spoon_sphere?
                            1:
                            2;

module head_sphere(volume,anchor,spin=0,orient=UP) {
    //volume in milliliters

    v=volume*1000*2; //must mutliply by 2 as we cut in half
    rad_i=pow((3*v)/(4*pi),1/3);
    rad_o=rad_i+wall;

    att_size=[spoon_l,2*rad_o,rad_o]; //size for further attaching things to this 

    
    
   
    
    handle_offs=spoon_l-2*rad_o;
    
    slot_size=[handle_offs-wall,handle1.y-2*wall,rad_o];
    //
    
    attachable(anchor, spin, orient, size=att_size) {
      move([-(spoon_l/2-rad_o),0,-rad_o/2])
       
     
        diff(){
            chain_hull(){
              top_half() 
                spheroid(r=rad_o);
              right(rad_o+prot)
                  cuboid(handle1,anchor=LEFT+BOTTOM); 
              right(rad_o+handle_offs) //very right of spoon
                  cuboid(handle2,anchor=RIGHT+BOTTOM,rounding=2,edges=[RIGHT+BACK,RIGHT+FRONT]);   
                
            };
            tag("remove") { 
              spheroid(r=rad_i);   
              right(rad_o) up(handle1.z-slot_z)
                  cuboid(slot_size,anchor=LEFT+BOTTOM);   
           
                
            };      
            // dis for debugging
            *tag("keep") {
                spheroid(r=rad_o+e,$color="blue")
                    position(RIGHT)
                        cuboid(handle1,anchor=LEFT+BOTTOM);
            };    
            
        }; //diff
        children();
    }; //attachable 
};


module head_cylinder(volume,anchor,spin=0,orient=UP) {
  v=volume*1000;  
   
  //v=pi*r^2*h 
  //h=r/2 example proportion
  //v=pi*r^2*(r/2)
  //v=pi*(r^3)/2
  //2*v/pi=r^3 
  h2r=0.75;  //ratio height to radius
  rad_i=pow(h2r*v/pi,1/3);
  h=rad_i/h2r;
    
  echo(pi*rad_i^2*h);  
  
  rad_o=rad_i+wall;
  
  handle_offs=spoon_l-2*rad_o;  
    
  slot_size=[handle_offs-wall,handle1.y-2*wall,h+wall];  
  
  att_size=[spoon_l,2*rad_o,h+wall];  
  attachable(anchor, spin, orient, size=att_size) {  
    move([-(spoon_l/2-rad_o),0,-(h+wall)/2])
        diff() {
           chain_hull(){
              cyl(r=rad_o,h=h+wall,anchor=BOTTOM);
              right(rad_o+prot) 
                   cuboid(handle1,anchor=LEFT+BOTTOM);
            
              right(rad_o+handle_offs ) 
                    cuboid(handle2,anchor=RIGHT+BOTTOM,rounding=2,edges=[RIGHT+BACK,RIGHT+FRONT]); 
            };     
           tag("remove") {  
             down(e)
                cyl(r=rad_i,h=h,anchor=BOTTOM); 
             right(rad_o) up(handle1.z-slot_z) 
                   cuboid(slot_size,anchor=LEFT+BOTTOM);        
           }; //remove
           
        }; //difference
    children();
    }; //attachable
};


module head_cube(volume,anchor,spin=0,orient=UP){
   v=volume*1000; //must mutliply by 2 as we cut in half
   
   props=[3,2,1]; //1*2*3=6 
    
    
    
   side_i=pow(v,1/3);
    cube_i=[side_i,side_i,side_i];
   
  // cube_i=[side_i*1/2,side_i*2/3,side_i*1/6];
   //echo(cube_i); 
   cube_o=cube_i+[2*wall,2*wall,wall]; 
    
    
    handle_offs=spoon_l-cube_o.x; 
    
    att_size=[spoon_l,cube_o.y,cube_o.z]; //size for further attaching things to this 

    slot_size=[handle_offs-wall,handle1.y-2*wall,cube_o.z];
    echo(slot_size);//
    attachable(anchor, spin, orient, size=att_size) {
     left(spoon_l/2-cube_o.x/2) 
     down(cube_o.z/2)
        diff() {
            chain_hull(){
                cuboid(cube_o,rounding=2,edges="Z",anchor=BOTTOM);
                right(cube_o.x/2+prot)
                  cuboid(handle1,anchor=LEFT+BOTTOM); 
              right(cube_o.x/2+handle_offs) //very right of spoon
                  cuboid(handle2,anchor=RIGHT+BOTTOM,rounding=2,edges=[RIGHT+BACK,RIGHT+FRONT]); 
            }; //chainhull
            
            tag("remove") {
              down(e)
                cuboid(cube_i,anchor=BOTTOM);  
               right(cube_o.x/2) up(handle1.z-slot_z)
                  cuboid(slot_size,anchor=LEFT+BOTTOM);   
                
            };    
            
             
        }; //diff   
        children();
    }; //attachable

};




