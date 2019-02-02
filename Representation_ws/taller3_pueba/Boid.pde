class Boid {
  public Frame frame;
  // fields
  Vector position, velocity, acceleration, alignment, cohesion, separation; // position, velocity, and acceleration in
  // a vector datatype
  float neighborhoodRadius; // radius in which it looks for fellow boids
  float maxSpeed = 4; // maximum magnitude for the velocity vector
  float maxSteerForce = .1f; // maximum magnitude of the steering vector
  float sc = 1; // scale factor for the render of the boid
  float flap = 0;
  float t = 0;

  Boid(Vector inPos) {
    
    
    position = new Vector();
    position.set(inPos);
    
    load = new LoadFile( );
    vertex = load.vertex( );
    faces = load.faces( );
    load.free( );
    graph( );
    retainedMode( );
    
    frame = new Frame(scene) {
      // Note that within visit() geometry is defined at the
      // frame local coordinate system.
      @Override
      public void visit() {
        if (animate)
          run(flock);
        render();
      }
    };
    frame.setPosition(new Vector(position.x(), position.y(), position.z()));
    velocity = new Vector(random(-1, 1), random(-1, 1), random(1, -1));
    acceleration = new Vector(0, 0, 0);
    neighborhoodRadius = 100;
  }

  public void run(ArrayList<Boid> bl) {
    t += .1;
    flap = 10 * sin(t);
    // acceleration.add(steer(new Vector(mouseX,mouseY,300),true));
    // acceleration.add(new Vector(0,.05,0));
    if (avoidWalls) {
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), flockHeight, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), 0, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(flockWidth, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(0, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), 0)), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), flockDepth)), 5));
    }
    flock(bl);
    move();
    checkBounds();
  }

  Vector avoid(Vector target) {
    Vector steer = new Vector(); // creates vector for steering
    steer.set(Vector.subtract(position, target)); // steering vector points away from
    steer.multiply(1 / sq(Vector.distance(position, target)));
    return steer;
  }

  //-----------behaviors---------------

  void flock(ArrayList<Boid> boids) {
    //alignment
    alignment = new Vector(0, 0, 0);
    int alignmentCount = 0;
    //cohesion
    Vector posSum = new Vector();
    int cohesionCount = 0;
    //separation
    separation = new Vector(0, 0, 0);
    Vector repulse;
    for (int i = 0; i < boids.size(); i++) {
      Boid boid = boids.get(i);
      //alignment
      float distance = Vector.distance(position, boid.position);
      if (distance > 0 && distance <= neighborhoodRadius) {
        alignment.add(boid.velocity);
        alignmentCount++;
      }
      //cohesion
      float dist = dist(position.x(), position.y(), boid.position.x(), boid.position.y());
      if (dist > 0 && dist <= neighborhoodRadius) {
        posSum.add(boid.position);
        cohesionCount++;
      }
      //separation
      if (distance > 0 && distance <= neighborhoodRadius) {
        repulse = Vector.subtract(position, boid.position);
        repulse.normalize();
        repulse.divide(distance);
        separation.add(repulse);
      }
    }
    //alignment
    if (alignmentCount > 0) {
      alignment.divide((float) alignmentCount);
      alignment.limit(maxSteerForce);
    }
    //cohesion
    if (cohesionCount > 0)
      posSum.divide((float) cohesionCount);
    cohesion = Vector.subtract(posSum, position);
    cohesion.limit(maxSteerForce);

    acceleration.add(Vector.multiply(alignment, 1));
    acceleration.add(Vector.multiply(cohesion, 3));
    acceleration.add(Vector.multiply(separation, 1));
  }

  void move() {
    velocity.add(acceleration); // add acceleration to velocity
    velocity.limit(maxSpeed); // make sure the velocity vector magnitude does not
    // exceed maxSpeed
    position.add(velocity); // add velocity to position
    frame.setPosition(position);
    frame.setRotation(Quaternion.multiply(new Quaternion(new Vector(0, 1, 0), atan2(-velocity.z(), velocity.x())), 
      new Quaternion(new Vector(0, 0, 1), asin(velocity.y() / velocity.magnitude()))));
    acceleration.multiply(0); // reset acceleration
  }

  void checkBounds() {
    if (position.x() > flockWidth)
      position.setX(0);
    if (position.x() < 0)
      position.setX(flockWidth);
    if (position.y() > flockHeight)
      position.setY(0);
    if (position.y() < 0)
      position.setY(flockHeight);
    if (position.z() > flockDepth)
      position.setZ(0);
    if (position.z() < 0)
      position.setZ(flockDepth);
  }

  HashMap colorVertex;
  HashMap graph;
  PShape[] shapeFV;
  PShape[] shapeVV;
  float[][] vertex;

  int[][] faces;
LoadFile load ;

  void render() {
    pushStyle();

    // uncomment to draw boid axes
    //scene.drawAxes(10);

    strokeWeight(2);
    stroke(color(255, 255, 255));
    fill(color(255, 255, 255, 125));

    // highlight boids under the mouse
    if (scene.trackedFrame("mouseMoved") == frame) {
      stroke(color(0, 0, 255));
      fill(color(0, 0, 255));
    }

    // highlight avatar
    if (frame ==  avatar) {
      stroke(color(255, 0, 0));
      fill(color(255, 0, 0));
    }

///  DRAW BIRD

/*
    //draw boid
    beginShape(TRIANGLES);
    
       
    
    vertex(7 * sc, 0, 0);
    vertex(-3 * sc, 2 * sc, 0);
    vertex(-3 * sc, -2 * sc, 0);

    vertex(7 * sc, 0, 0);
    vertex(-3 * sc, 2 * sc, 0);
    vertex(-3 * sc, 0, 2 * sc);

    vertex(7 * sc, 0, 0);
    vertex(-3 * sc, 0, 2 * sc);
    vertex(-3 * sc, -2 * sc, 0);
 
    endShape(); 
    
    
pushMatrix();
stroke(color(64, 64, 64));
fill(color(102, 102, 102));
 
//box(10);
noStroke(); 
sphere(5);
popMatrix();


*/


 /* 
    fill(color(255, 255, 255));
    int sides = 20;
    int r = 3;
    float angle = 360 / sides;
    float halfHeight = 3 / 2;
    // draw top shape
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, -halfHeight );    
    }
    endShape(CLOSE);
    // draw bottom shape
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight );    
    }
    endShape(CLOSE);
    
    fill(color(255, 255, 255));
    beginShape(TRIANGLE_STRIP);
for (int i = 0; i < sides + 1; i++) {
    float x = cos( radians( i * angle ) ) * r;
    float y = sin( radians( i * angle ) ) * r;
    vertex( x, y, halfHeight);
    vertex( x, y, -halfHeight);    
}
endShape(CLOSE); 
    

*/
/*    
pushMatrix();
stroke(color(64, 64, 64));
fill(color(102, 102, 102));
 
//box(10);
noStroke(); 
sphere(5);
popMatrix();

*/



/*

load = new LoadFile( );
vertex = load.vertex( ); 
    faces = load.faces( );
for( int i = 0; i < load.facesSize( ); i++ ){
        beginShape( );
        for( int j = 0; j < 3; j++ )
          vertex( vertex[faces[i][j]][0] * sc, vertex[faces[i][j]][1] * sc, vertex[faces[i][j]][2] * sc );
        endShape();
      }
      
 */
 

    //draw boid
    if( representation == 0 )
      faceVertex( );
    else if( representation == 1 )
      vertexVertex( ); 
      



       
      
      
      
      
    popStyle();
    
  }
  
  void vertexVertex( ){

     for( int i = 0; i < load.vertexSize(); i++ ){
      HashMap node =  ((HashMap)graph.get( i ));
      Integer[] nodes = (Integer[])((node.keySet( )).toArray( new Integer[0] ));
      beginShape( TRIANGLE_STRIP );
      for( int j = 0; j < node.size( ); j++ ){
        vertex( vertex[i][0] * sc, vertex[i][1] * sc, vertex[i][2] * sc );
        vertex( vertex[nodes[j]][0] * sc, vertex[nodes[j]][1] * sc, vertex[nodes[j]][2] * sc );
      }
      endShape( );
    }

  } 
    void faceVertex(  ){

    if( retainedMode == 1 ){
      for( int i = 0; i < load.facesSize( ); i++ )
        shape( shapeFV[i] );
    }else{
      for( int i = 0; i < load.facesSize( ); i++ ){
        beginShape( );
        for( int j = 0; j < 3; j++ )
          vertex( vertex[faces[i][j]][0] * sc, vertex[faces[i][j]][1] * sc, vertex[faces[i][j]][2] * sc );
        endShape();
      }
    }

  }
 
  
  void visitorRetained( int key, HashMap node ){
    colorVertex.replace( key, "g" );
    Integer[] nodes = (Integer[])((node.keySet( )).toArray( new Integer[0] ));
    shapeVV[key].beginShape( TRIANGLE_STRIP );
    for( int i = 0; i < nodes.length; i++ ){;
      if( colorVertex.get( nodes[i] ).equals( "b" ) ){
        shapeVV[key].vertex( vertex[nodes[i]][0] * sc, vertex[nodes[i]][1] * sc, vertex[nodes[i]][2] * sc );
        shapeVV[key].vertex( vertex[key][0] * sc, vertex[key][1] * sc, vertex[key][2] * sc );
      }else if( colorVertex.get( nodes[i] ).equals( "w" ) ){
        visitor( nodes[i], (HashMap) graph.get( nodes[i] ) );
      }
    }
    shapeVV[key].endShape( );
    colorVertex.replace( key, "b" );
  }
  
  void graph( ){
    graph = new HashMap();
    colorVertex = new HashMap();
    for( int i = 0; i < load.vertexSize( ); i++ ){
      graph.put( i, new HashMap( ) );
      colorVertex.put( i, "w" );
    }
    for( int i = 0; i < load.facesSize( ); i++ ){
      ((HashMap) graph.get( faces[i][0] )).put( faces[i][1], null );
      ((HashMap) graph.get( faces[i][0] )).put( faces[i][2], null );
      ((HashMap) graph.get( faces[i][1] )).put( faces[i][0], null );
      ((HashMap) graph.get( faces[i][1] )).put( faces[i][2], null );
      ((HashMap) graph.get( faces[i][2] )).put( faces[i][0], null );
      ((HashMap) graph.get( faces[i][2] )).put( faces[i][1], null );
    }
  }

  void retainedMode(){
    // Create the polygon mesh in retained mode with vertex-vertex representation
    shapeVV = new PShape[load.vertexSize()];
    for( int i = 0; i < load.vertexSize( ); i++){
      shapeVV[i] = createShape(  );
    }
    for( int i = 0; i < load.vertexSize( ); i++){
      
      visitorRetained( 0, (HashMap) graph.get( 0 ) );
      
      shapeVV[i].setFill( color( 255, 0, 0, 125 ) );
      shapeVV[i].setStroke( color( 0, 255, 0 ) );
      shapeVV[i].setStrokeWeight( 2 );
    }
    // Create the polygon mesh in retained mode with face-vertex representation
    shapeFV = new PShape[load.facesSize()];
    for( int i = 0; i < load.facesSize( ); i++ ){
      shapeFV[i] = createShape( );
      shapeFV[i].beginShape( );
      for( int j = 0; j < 3; j++ ){
        shapeFV[i].vertex( vertex[faces[i][j]][0] * sc, vertex[faces[i][j]][1] * sc, vertex[faces[i][j]][2] * sc );
      }
      shapeFV[i].endShape( );
      shapeFV[i].setFill( color( 255, 0, 0, 125 ) );
      shapeFV[i].setStroke( color( 0, 255, 0 ) );
      shapeFV[i].setStrokeWeight( 2 );
    }
  }
  
  
  void visitor( int key, HashMap node ){
    colorVertex.replace( key, "g" );
    Integer[] nodes = (Integer[])((node.keySet( )).toArray( new Integer[0] ));
    
    //  print("TOTALAAAAAAAAAAAAAAAA, " , nodes.length,"\n");
    for( int i = 0; i < nodes.length; i++ ){
      
     // print("VALOR, ",i , nodes[i],"\n");
      if( colorVertex.get( nodes[i] ).equals( "b" ) ){
        vertex( vertex[nodes[i]][0] * sc, vertex[nodes[i]][1] * sc, vertex[nodes[i]][2] * sc );
        vertex( vertex[key][0] * sc, vertex[key][1] * sc, vertex[key][2] * sc );
      }else if( colorVertex.get( nodes[i] ).equals( "w" ) ){
        visitor( nodes[i], (HashMap) graph.get( nodes[i] ) );
      }
    }
    colorVertex.replace( key, "b" );
  }


}
