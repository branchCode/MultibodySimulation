import peasy.*;

//int PATHL = 100;     // initial len of trajectory
int MAXL = 200;      // max len of traj.
int MAXN = 500;

// range of star mass
float minSM =1000; 
float maxSM = 1001;
// range of planets mass
float minPM = 0.01;
float maxPM = 0.1;

float maxV = 0.1;  //max initial velocity 
float G = 10000.0;    
float r = -2.0;    // the index of distance
float dt = 1.0 / 100000;
float e = 0.1;

boolean run = true;

ArrayList<Body> bs = new ArrayList<Body>();
PeasyCam cam;
int maxindex = 0;
int index = 0;
int count = 0;
int cnt = 0;

void setup(){
  //fullScreen(P3D);
  size(1300,700,P3D);
  for(int i = 0; i < MAXN; ++i){
    bs.add(new Body(random(minSM,maxSM),
                    random(width), 
                    random(height), 
                    random(height)));
  }
  cam = new PeasyCam(this,width/2,height/2,0,1000);
}

void draw(){
  background(0);
  lights();
  maxindex = 0;
  for(int i = 0; i < bs.size(); ++i){
    Body b = bs.get(i);
    if(b.mass > bs.get(maxindex).mass){
      maxindex = i;
    }
    if(b.exist){
      if(run)
        b.update();
      b.show();
    }
  }
  
  //show info.
  count = 0;
  for(int i = 0; i < bs.size(); ++i){
    Body b = bs.get(i);
    if(!b.exist)
      continue;
    if(count == cnt)
      index = i;
    String t = "m: " + b.mass + "\n|v|: " + b.vel.mag();
    fill(b.col);
    textSize(10);
    text(t,b.pos.x+b.radius,b.pos.y+b.radius,b.pos.z+b.radius);
    count++;
  }
  
  if(cnt >= count)
    cnt = 0;
  else if(cnt < 0)
    cnt = count - 1;
}

void keyPressed(){
  if(key == ENTER){
    //bs.add(new Body(random(minSM,maxSM),mouseX,mouseY));
    Body b = bs.get(maxindex);
    PVector p = b.pos;
    bs.add(new Body(random(minPM,maxPM),
                    random(-p.x+10,p.x+10), 
                    random(-p.y+10,p.y+10), 
                    random(-p.z+10,p.z+10)));
  }
  else if(key == 'p' || key == 'P'){
    run = !run;
  }else if(key == ' '){
    Body b = bs.get(maxindex);
    cam.lookAt(b.pos.x,b.pos.y,b.pos.z,1500);
  }else if(key == 'q' || key == 'Q'){
    cnt++;
    Body b = bs.get(index);
    cam.lookAt(b.pos.x,b.pos.y,b.pos.z,1500);
  }else if(key == 'e' || key == 'E'){
    cnt--;
    Body b = bs.get(index);
    cam.lookAt(b.pos.x,b.pos.y,b.pos.z,1500);
  }else if(key == 's' || key == 'S'){
    Body b = bs.get(maxindex);
    b.vel = new PVector(0, 0, 0);
  }
}
