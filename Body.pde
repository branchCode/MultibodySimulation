class Body{
  public float mass;
  public float radius;
  public PVector pos;
  public PVector vel;
  public color col;
  public PVector force;
  
  ArrayList<PVector> traj = new  ArrayList<PVector>();
  boolean exist = true;
  
  public Body(float m, float x, float y, float z){
    this.mass = m;
    this.radius = calculateR();
    this.pos = new PVector(x, y, z);
    this.vel = new PVector(random(-maxV,maxV),random(-maxV,maxV),random(-maxV,maxV));
    this.col = color(random(256),random(256),random(256));
    this.traj.add(new PVector(this.pos.x,this.pos.y,this.pos.z));
    //this.force = new PVector(0,0,0);
  }
  
  float calculateR(){
    return pow(mass/PI * (3.0/4),1.0/3); 
  }
  
  void update(){
    for(int i = 0; i < bs.size(); ++i){
      Body otherb = bs.get(i);
      if(this == otherb || !otherb.exist)
        continue;
      //PVector d = PVector.add(otherb.pos, PVector.add(otherb.vel,
      //                        PVector.mult(PVector.div(otherb.force,
      //                        otherb.mass), 0.5 * dt)));
      //PVector s = PVector.add(pos, PVector.add(vel,
      //                        PVector.mult(PVector.div(force,
      //                        mass), 0.5 * dt)));
      PVector dir = PVector.sub(otherb.pos,pos);
      //PVector dir = PVector.sub(d, s);
      float dmag = dir.mag();
      if(dmag < radius + otherb.radius){
      PVector new_vel = PVector.div(PVector.add(PVector.mult(vel,mass),
                                                PVector.mult(otherb.vel,otherb.mass)),
                                    mass + otherb.mass);
        if(mass > otherb.mass){
          mass += otherb.mass;
          radius = this.calculateR();
          vel = new_vel;
          otherb.exist = false;
        }
        else{
          exist = false;
          return ;
        }
      }
      else if(dmag > radius + otherb.radius + e){
        float fmag = G * otherb.mass * mass * pow(dmag,r);
        force = dir.normalize().mult(fmag);
        //dt = 1.0 / (frameRate * 10);
        vel.add(force.div(mass).mult(dt));          
      }
    }
    
    pos.add(vel);
    traj.add(new PVector(pos.x,pos.y,pos.z));
    if(traj.size() > MAXL){
      traj.remove(0);
    }
  }
  
  void show(){
    pushMatrix();
    noStroke();
    fill(col);
    translate(pos.x,pos.y,pos.z);
    sphere(radius);
    popMatrix();
    //translate(-pos.x,-pos.y,-pos.z);
    for(int i = 0; i < traj.size() - 1; ++i){
      PVector pa = traj.get(i);
      PVector pb = traj.get(i+1);
      stroke(col);
      //translate(pa.x,pa.y,pa.z);
      //ellipse(0,0,4,4);
      line(pa.x,pa.y,pa.z,pb.x,pb.y,pb.z);
    }
  }
}
