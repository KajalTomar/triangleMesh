final float VERTICE_RADIUS = 0.03; // to set the radius for the handles

ArrayList<float[]> vertices = new ArrayList<float[]>(); // [x,y]
ArrayList<int[]> triangles = new ArrayList<int[]>(); // [v1, v1, v3] // list of all the triangles

float panel_top;

// keeps track of what is selected 
int currentlySelected = -1; 
int selectedVertex = -1;
int selectedEdge = -1; 

boolean hit; 

void setup() {
  
  size(640, 640, P3D);
  frameRate(30);

  // all of this is optional:
  colorMode(RGB, 1.0);
  ellipseMode(RADIUS);
  ortho(-1, 1, 1, -1);
  resetMatrix();
  hint(DISABLE_OPTIMIZED_STROKE);
  
  // add more here if you need:
  generateRandomTriangle();

  // this is required:
  controlPanel = loadImage("ControlPanel.png");
  if (controlPanel == null) {
    println("Can't find ControlPanel.png - did you put it in the sketch folder?");
    System.exit(0);
  }
  noLoop();
}

void draw() {
  background(0.9, 0.85, 0.85);
 
  resetMatrix();
  drawTriangles();

  // use this for a unit coordinate system:
  resetMatrix();
  scale(1,-1);
  image(controlPanel, -1, 1-2.0*PANEL_HEIGHT/height, 2.0*PANEL_WIDTH/width, 2.0*PANEL_HEIGHT/height);
  panel_top = 2.0*PANEL_HEIGHT/height-1;

  // use this for a window coordinate system:
  //image(controlPanel, 0, height-PANEL_HEIGHT, PANEL_WIDTH, PANEL_HEIGHT);
}

// draws all the triangles 
// based on whether they are selected or not
void drawTriangles(){
  float[] v1, v2, v3; 

  for (int[] tri: triangles) { 
    v1 = vertices.get(tri[0]);
    v2 = vertices.get(tri[1]);
    v3 = vertices.get(tri[2]);

    // if a triangle is selected 
    // then draw that one as selected
    // and rest normally.
    if(currentlySelected != -1){
      if (tri == triangles.get(currentlySelected)){
        drawSelectedTriangle(v1,v2,v3);    
      }
      else{
        drawUnselectedTriangle(v1,v2,v3);       
      }
    } 
    // if nothing is selected then just draw the triangle normally
    else {
      drawUnselectedTriangle(v1,v2,v3);      
    }
    
  }
}

// draws a triangle that isn't currently selected.
void drawUnselectedTriangle(float[] v1, float[] v2, float[] v3){
 
  strokeWeight(2);
  noFill();

  beginShape(TRIANGLES);
    vertex(v1[0], v1[1]);
    vertex(v2[0], v2[1]);
    vertex(v3[0], v3[1]);
  endShape();
    
}

// draws a triangle if it's selected
void drawSelectedTriangle(float[] v1, float[] v2, float[] v3){

    if(currentlySelected != -1){
      strokeWeight(4);
      fill(COLOURS[19]);

      // draw the triangle
      beginShape(TRIANGLES);
        vertex(v1[0], v1[1]);
        vertex(v2[0], v2[1]);
        vertex(v3[0], v3[1]);
      endShape();

      // if an edge is selected, then draw that edge in red
      if(selectedEdge == 1){
        stroke(255,0,0);
        line(v1[0],v1[1],v2[0], v2[1]);
      }
      else if(selectedEdge == 2){
        stroke(255,0,0);
        line(v2[0],v2[1],v3[0], v3[1]);
      }
      else if(selectedEdge == 3){
        stroke(255,0,0);
        line(v3[0],v3[1],v1[0], v1[1]);
      }

      stroke(0,0,0);

      // draw a circle aroud each vertex
      // if it's selected, then draw a larger circle for that vertex.
      if(selectedVertex == -1){
        circle(v1[0], v1[1], VERTICE_RADIUS);
        circle(v2[0], v2[1], VERTICE_RADIUS);
        circle(v3[0], v3[1], VERTICE_RADIUS);
      }
      if(selectedVertex == 1){
         circle(v1[0], v1[1], VERTICE_RADIUS*2);
         circle(v2[0], v2[1], VERTICE_RADIUS);
         circle(v3[0], v3[1], VERTICE_RADIUS);
      }
      else if (selectedVertex == 2){
        circle(v1[0], v1[1], VERTICE_RADIUS);
        circle(v2[0], v2[1], VERTICE_RADIUS*2);
        circle(v3[0], v3[1], VERTICE_RADIUS);
      }
      else if (selectedVertex == 3){
        circle(v1[0], v1[1], VERTICE_RADIUS);
        circle(v2[0], v2[1], VERTICE_RADIUS);
        circle(v3[0], v3[1], VERTICE_RADIUS*2);
      }

    }
}

// This method is used for when the user clicks 
// on the buttons on the control panel. 
void mouseClicked(){
  float x = 2.0 * mouseX / width - 1; // convert mouseX to unit coordinates
  float y = 2.0 * (height-mouseY+1) / height - 1; // convert mouseY to unit coordinates
 
  // make sure the user clicked within the panel
  if(y < panel_top){

    // the width of the panel is divided into 10 sections 
    // each if statement will call the corresponding function 
    // to the given button.
    if(x >= -1 && x <- 0.8){
      moveLeft();
    }
    else if(x >= -0.8 && x < -0.6){
      moveUp();
    }
    else if(x >= -0.6 && x < -0.4){
     moveDown();
    }
    else if(x >= -0.4 && x < -0.2){
      moveRight();
    }
    else if(x >= -0.2 && x < 0.0){
      scale(true); 
    }
    else if(x >= 0.0 && x < 0.2){
      scale(false);
    }
    else if(x >= 0.2 && x < 0.4){
      rotate(false);
    }
    else if(x >= 0.4 && x < 0.6){
      rotate(true);
    }
    else if(x >= 0.6 && x < 0.8){
     cut();
    }
    else if(x >= 0.8 && x < 1.0){
      // reset everything and generate a new triangle
      vertices.clear();
      triangles.clear();
      selectedEdge = -1;
      selectedVertex = -1;
      currentlySelected = -1;
      generateRandomTriangle();
      redraw();
    }
 
  }
}

// move the currently selected object or 
// the entire mesh by a small amount to the left.
void moveLeft(){
  float moveAmount = 0.05;
  int[] tri;
  float[] v1,v2,v3;

  if(currentlySelected != -1){
    tri = triangles.get(currentlySelected);
    v1 = vertices.get(tri[0]);
    v2 = vertices.get(tri[1]);
    v3 = vertices.get(tri[2]);

    v1[0] -= moveAmount;
    v2[0] -= moveAmount;
    v3[0] -= moveAmount;
  }
  else {
    // clicked outside all the triangles 
    // move all the triangles
     for (int[] triangle: triangles) {
      v1 = vertices.get(triangle[0]);
      v2 = vertices.get(triangle[1]);
      v3 = vertices.get(triangle[2]);

      v1[0] -= moveAmount;
      v2[0] -= moveAmount;
      v3[0] -= moveAmount; 
     }

     redraw(); 
  }
}

// move the currently selected object or 
// the entire mesh by a small amount up.
void moveUp(){
  float moveAmount = 0.05;
  int[] tri;
  float[] v1,v2,v3;

   // if there is a selected triangle, then move only that triangle 
  if(currentlySelected != -1){
    tri = triangles.get(currentlySelected);
    v1 = vertices.get(tri[0]);
    v2 = vertices.get(tri[1]);
    v3 = vertices.get(tri[2]);

    v1[1] += moveAmount;
    v2[1] += moveAmount;
    v3[1] += moveAmount;
  }
  else {
    // nothings is selected
    // move the mesh (all the triangles)
     for (int[] triangle: triangles) {
      v1 = vertices.get(triangle[0]);
      v2 = vertices.get(triangle[1]);
      v3 = vertices.get(triangle[2]);

      v1[1] += moveAmount;
      v2[1] += moveAmount;
      v3[1] += moveAmount; 
     }

     redraw(); 
  }
}

// move the currently selected object or 
// the entire mesh by a small amount down.
void moveDown(){
  float moveAmount = 0.05;
  int[] tri;
  float[] v1,v2,v3;
  
  // if there is a selected triangle, then move only that triangle 
  if(currentlySelected != -1){
    tri = triangles.get(currentlySelected);
    v1 = vertices.get(tri[0]);
    v2 = vertices.get(tri[1]);
    v3 = vertices.get(tri[2]);

    v1[1] -= moveAmount;
    v2[1] -= moveAmount;
    v3[1] -= moveAmount;
  }
  else {
    // nothings is selected
    // move the mesh (all the triangles)
     for (int[] triangle: triangles) {
      v1 = vertices.get(triangle[0]);
      v2 = vertices.get(triangle[1]);
      v3 = vertices.get(triangle[2]);

      v1[1] -= moveAmount;
      v2[1] -= moveAmount;
      v3[1] -= moveAmount; 
     }

     redraw(); 
  }
}

// move the currently selected object or 
// the entire mesh by a small amount to the right.
void moveRight(){
  float moveAmount = 0.05;
  int[] tri;
  float[] v1,v2,v3;

  // if there is a selected triangle, then move only that triangle 
  if(currentlySelected != -1){
    tri = triangles.get(currentlySelected);
    v1 = vertices.get(tri[0]);
    v2 = vertices.get(tri[1]);
    v3 = vertices.get(tri[2]);

    v1[0] += moveAmount;
    v2[0] += moveAmount;
    v3[0] += moveAmount;
  }
  else {
    // nothings is selected
    // move the mesh (all the triangles)
     for (int[] triangle: triangles) {
      v1 = vertices.get(triangle[0]);
      v2 = vertices.get(triangle[1]);
      v3 = vertices.get(triangle[2]);

      v1[0] += moveAmount;
      v2[0] += moveAmount;
      v3[0] += moveAmount; 
     }

     redraw(); 
  }
}

// scale the currently selected object or 
// the entire mesh by a small amount up or down.
void scale(boolean scaleUp){
  float scaleAmount = 0.90; 
  int[] tri;
  float[] v1,v2,v3;
  float[] center = new float[2];
 
  
  if(scaleUp){
    scaleAmount = 1.10;
  }

  // if there is a selected triangle, then scale only that triangle 
  if(currentlySelected != -1){
    tri = triangles.get(currentlySelected);
    v1 = vertices.get(tri[0]);
    v2 = vertices.get(tri[1]);
    v3 = vertices.get(tri[2]);

    // get the center coordinates
    center[0] = (v1[0]+v2[0]+v3[0])/3;
    center[1] = (v1[1]+v2[1]+v3[1])/3;
  
      // translate to the centre
      v1[0] -= center[0];
      v2[0] -= center[0];
      v3[0] -= center[0];

      v1[1] -= center[1];
      v2[1] -= center[1];
      v3[1] -= center[1];
    
      // scale
      v1[0] *= scaleAmount;
      v2[0] *= scaleAmount;
      v3[0] *= scaleAmount;

      v1[1] *= scaleAmount;
      v2[1] *= scaleAmount;
      v3[1] *= scaleAmount;
        
      // translate back
      v1[0] += center[0];
      v2[0] += center[0];
      v3[0] += center[0];

      v1[1] += center[1];
      v2[1] += center[1];
      v3[1] += center[1];

      redraw();
  }
  else {
    // nothings is selected
    // scale the mesh (all the triangles)
     for (int[] triangle: triangles) {
      v1 = vertices.get(triangle[0]);
      v2 = vertices.get(triangle[1]);
      v3 = vertices.get(triangle[2]);

       // get the center 
    center[0] = (v1[0]+v2[0]+v3[0])/3;
    center[1] = (v1[1]+v2[1]+v3[1])/3;
  
      // translate to the centre
      v1[0] -= center[0];
      v2[0] -= center[0];
      v3[0] -= center[0];

      v1[1] -= center[1];
      v2[1] -= center[1];
      v3[1] -= center[1];
    
      // scale
      v1[0] *= scaleAmount;
      v2[0] *= scaleAmount;
      v3[0] *= scaleAmount;

      v1[1] *= scaleAmount;
      v2[1] *= scaleAmount;
      v3[1] *= scaleAmount;
        
      // translate back
      v1[0] += center[0];
      v2[0] += center[0];
      v3[0] += center[0];

      v1[1] += center[1];
      v2[1] += center[1];
      v3[1] += center[1]; 
     }

     redraw(); 
  }
}

// rotate the selected triangle or the entire mesh around its centre. 
void rotate(boolean CC){
  int rotateBy = -20;

  int[] tri;
  float[] v1,v2,v3;

  float[] center = new float[2]; 
  float originalX, originalY;

  if(CC){
      rotateBy = 20;
  }
  
  // if there is a selected triangle, then rotate only that triangle 
  if(currentlySelected != -1){
    tri = triangles.get(currentlySelected);
    v1 = vertices.get(tri[0]);
    v2 = vertices.get(tri[1]);
    v3 = vertices.get(tri[2]);

    // get the center 
    center[0] = (v1[0]+v2[0]+v3[0])/3;
    center[1] = (v1[1]+v2[1]+v3[1])/3;
  
    // translate to the centre
    v1[0] -= center[0];
    v2[0] -= center[0];
    v3[0] -= center[0];

    v1[1] -= center[1];
    v2[1] -= center[1];
    v3[1] -= center[1];

    // rotate
    originalX = v1[0];
    originalY = v1[1];

    v1[0] = originalX*cos(rotateBy) - originalY*sin(rotateBy);
    v1[1] = originalX*sin(rotateBy) + originalY*cos(rotateBy);
    
    originalX = v2[0];
    originalY = v2[1];

    v2[0] = originalX*cos(rotateBy) - originalY*sin(rotateBy);
    v2[1] = originalX*sin(rotateBy) + originalY*cos(rotateBy);
    
    originalX = v3[0];
    originalY = v3[1];

    v3[0] = originalX*cos(rotateBy) - originalY*sin(rotateBy);
    v3[1] = originalX*sin(rotateBy) + originalY*cos(rotateBy);

    // translate back
    v1[0] += center[0];
    v2[0] += center[0];
    v3[0] += center[0];

    v1[1] += center[1];
    v2[1] += center[1];
    v3[1] += center[1];

    redraw();

  }
  else {
    // nothings is selected
    // rotate the mesh (all the triangles)

     for (int[] triangle: triangles) {
      v1 = vertices.get(triangle[0]);
      v2 = vertices.get(triangle[1]);
      v3 = vertices.get(triangle[2]);

      // get the center 
      center[0] = (v1[0]+v2[0]+v3[0])/3;
      center[1] = (v1[1]+v2[1]+v3[1])/3;
  
      // translate to the centre
      v1[0] -= center[0];
      v2[0] -= center[0];
      v3[0] -= center[0];

      v1[1] -= center[1];
      v2[1] -= center[1];
      v3[1] -= center[1];

      // rotate

      originalX = v1[0];
      originalY = v1[1];

      v1[0] = originalX*cos(rotateBy) - originalY*sin(rotateBy);
      v1[1] = originalX*sin(rotateBy) + originalY*cos(rotateBy);
      
      originalX = v2[0];
      originalY = v2[1];

      v2[0] = originalX*cos(rotateBy) - originalY*sin(rotateBy);
      v2[1] = originalX*sin(rotateBy) + originalY*cos(rotateBy);
      
      originalX = v3[0];
      originalY = v3[1];

      v3[0] = originalX*cos(rotateBy) - originalY*sin(rotateBy);
      v3[1] = originalX*sin(rotateBy) + originalY*cos(rotateBy);

     // translate back
      v1[0] += center[0];
      v2[0] += center[0];
      v3[0] += center[0];

      v1[1] += center[1];
      v2[1] += center[1];
      v3[1] += center[1];

     }

     redraw(); 
  }
}

// when an edge is selected will cut the edge, creating new triangles.
void cut(){
  int[] tri;
  float[] v1,v2,v3;
  float[] center = new float[2]; 
  PVector e1,e2,e3;

  // only cut if an edge is selected
  if(selectedEdge != -1){
    tri = triangles.get(currentlySelected);
    v1 = vertices.get(tri[0]);
    v2 = vertices.get(tri[1]);
    v3 = vertices.get(tri[2]);   
  }
}

// generates a random triangle and addes associated
// vertices to the list.
void generateRandomTriangle(){

    float[] v1 = new float[2];
    float[] v2 = new float[2];
    float[] v3 = new float[2];

    boolean finalTriangle = false; 

    // generate triangle vertices until we 
    // get ones that would not 
    // create a degenerate triangle.
    while (!finalTriangle){

      v1[0] = random(-0.75f,0.75f);    
      v1[1] = random(0.0f,0.75f); 

      v2[0] = random(-0.75f,0.0f); 
      v2[1] = random(-0.75f,0.0f); 
     
      v3[0] = random(0.0f,0.75f); 
      v3[1] = random(-0.75f,0.0f); 
      
      if(!isDegenerate(v1, v2, v3)){
        finalTriangle = true;
      }
    }

    // add the vertices to the list
    vertices.add(v1);
    vertices.add(v2);
    vertices.add(v3);

    // add the triangle to the list 
    int[] triangle = {0, 1, 2};
    triangles.add(triangle);
}

// check if a triagle is denerate
boolean isDegenerate(float[] v1, float[] v2, float[] v3){
    boolean degenerate = false; 
    PVector e1, e2, e3;

    e1 = new PVector(v2[0] - v1[0], v2[1] - v1[1]);
    e2 = new PVector(v3[0] - v2[0], v3[1] - v2[1]);
    e3 = new PVector(v1[0] - v3[0], v1[1] - v3[1]);

    // check if these points will make a degenerate triangle
      if(crossProduct(e2,e1) == 0 || crossProduct(e3,e2) == 0 || crossProduct(e1,e3) == 0 ){
        degenerate = true; 
        System.out.println("degenerate");
      }

    return degenerate;
      
}

// returns the cross product of two vectors
float crossProduct(PVector v1, PVector v2){
   return (v1.x*v2.y - v1.y*v2.x);
}

// what happens when a user interacts with
// the mesh and the triangles 
void mousePressed(){
  boolean pInside = false;
  PVector e1, e2, e3; // edges
  PVector a1, a2, a3; // areas
  float[] v1, v2, v3; // vertices
  float distanceFromv1, distanceFromv2, distanceFromv3;
  float e1CrossA1, e2CrossA2, e3CrossA3;  // cross products 

  // change mouse x and y to unit coordinate system
  float x = 2.0 * mouseX / width - 1;
  float y = 2.0 * (height-mouseY+1) / height - 1;

  // go through each triangle, do the point-in-triangle test
  // to see if the press was inside a triangle (and which one).
   for (int[] tri: triangles) {

    // caculations 
    v1 = vertices.get(tri[0]);
    v2 = vertices.get(tri[1]);
    v3 = vertices.get(tri[2]);

    // edge vertices 
    e1 = new PVector(v2[0]-v1[0], v2[1]-v1[1]);
    e2 = new PVector(v3[0]-v2[0], v3[1]-v2[1]);
    e3 = new PVector(v1[0]-v3[0], v1[1]-v3[1]);

    // area vectors
    a1 = new PVector(x-v1[0],y-v1[1]);
    a2 = new PVector(x-v2[0],y-v2[1]);
    a3 = new PVector(x-v3[0],y-v3[1]);
  
    // cross products
    e1CrossA1 =  crossProduct(e1,a1);
    e2CrossA2 =  crossProduct(e2,a2);
    e3CrossA3 =  crossProduct(e3,a3);

    // if this triangle is already selected, the check
    // if the user has selected an edge, vertex,
    // the triangle (again) or pressed outside the mesh
    if(currentlySelected == triangles.indexOf(tri)){
      
      //  more calculations 
      distanceFromv1 = dist(v1[0], v1[1], x, y);
      distanceFromv2 = dist(v2[0], v2[1], x, y);
      distanceFromv3 = dist(v3[0], v3[1], x, y);

      // this if-else block first checks if any of the
      // vertices was selected, then the edge,
      // the triangle 
      if(distanceFromv1 <= VERTICE_RADIUS){
        selectedVertex = 1;
        selectedEdge = -1;
         hit = true;
         break;
      }
      else if(distanceFromv2 <= VERTICE_RADIUS){
    
        selectedVertex = 2;
        selectedEdge = -1;
         hit = true;
        break;
      }
      else if(distanceFromv3 <= VERTICE_RADIUS){
    
        selectedVertex = 3;
        selectedEdge = -1;
          hit = true;
         break;
      }
      else if(abs(e1CrossA1) <= 0.02 && abs(e2CrossA2) >= 0.02 && abs(e3CrossA3) >= 0.02){
          selectedEdge = 1;
          selectedVertex = -1;
           hit = true;
          break;
      }
      else if(abs(e1CrossA1) >= 0.02 && abs(e2CrossA2) <= 0.02 && abs(e3CrossA3) >= 0.02){
    
          selectedEdge = 2; 
          selectedVertex = -1;
           hit = true;
          break;
      }
      else if(abs(e1CrossA1) >= 0.02 && abs(e2CrossA2) >= 0.02 && abs(e3CrossA3) <= 0.02){
          selectedEdge = 3;
          selectedVertex = -1;
           hit = true;
          break;
      }     
      else if((e1CrossA1 > 0 && e2CrossA2 > 0 && e3CrossA3 > 0 ) ||
            (e1CrossA1 < 0 && e2CrossA2 < 0 && e3CrossA3 < 0)){               
                selectedEdge = -1; 
                selectedVertex = -1;
                hit = true;
                redraw();
                break;
      }
      else if (y > panel_top) {
        // they clicked outside the triangle 
        // deselect
        currentlySelected = -1;
        selectedVertex = -1; 
        selectedEdge = -1;
        hit = true; 
      } 
    }  
    // the point is in this triagle 
    // and nothing was selected beforehand.
    else if((e1CrossA1 > 0 && e2CrossA2 > 0 && e3CrossA3 > 0 ) ||
            (e1CrossA1 < 0 && e2CrossA2 < 0 && e3CrossA3 < 0)){

      currentlySelected = triangles.indexOf(tri);
      selectedEdge = -1;
      selectedVertex = -1;
      hit = true;
      redraw();
      break; 
    }
    
  }

  redraw();
}

// if the mouse is relased then let everything go
void mouseReleased() {
  hit = false;
}

// drag the appropriate things
void mouseDragged() {
  int[] tri;
  float[] v1,v2,v3;

  // convert to unit coordinates
  float x = 2.0 * mouseX / width - 1;
  float y = 2.0 * (height-mouseY+1) / height - 1;
  float xP = 2.0 * pmouseX / width - 1;
  float yP = 2.0 * (height-pmouseY+1) / height - 1;
  float distance;

  // if a triangle is selected then we will drag
  // the triangle or one of its component
  if(currentlySelected != -1){
    tri = triangles.get(currentlySelected);
    v1 = vertices.get(tri[0]);
    v2 = vertices.get(tri[1]);
    v3 = vertices.get(tri[2]);

    if(hit){

      // the triangle is selected (and none of the edges or vertices are)
      // so just drag the whole triangle
      if(selectedEdge == -1 && selectedVertex == -1){
        v1[0] += x - xP;
        v1[1] += y - yP;

        v2[0] += x - xP;
        v2[1] += y - yP;

        v3[0] += x - xP;
        v3[1] += y - yP;
      }
      // if an edfe is selected, drag the vertices that its made of
      else if(selectedEdge == 1){
        v1[0] += x - xP;
        v1[1] += y - yP;
        v2[0] += x - xP;
        v2[1] += y - yP;
      }
      else if(selectedEdge == 2){
         v2[0] += x - xP;
         v2[1] += y - yP;
         v3[0] += x - xP;
        v3[1] += y - yP;
      }
      else if(selectedEdge == 3){
        v3[0] += x - xP;
        v3[1] += y - yP;
        v1[0] += x - xP;
        v1[1] += y - yP;
      }
      // if a vertex is selected, drag the vertex
      else if(selectedVertex == 1){
        v1[0] += x - xP;
        v1[1] += y - yP;
      } 
       else if(selectedVertex == 2){
        v2[0] += x - xP;
        v2[1] += y - yP;
      } 
       else if(selectedVertex == 3){
        v3[0] += x - xP;
        v3[1] += y - yP;
      }
      redraw();
    }
  } 
  else {
     // Dragging with no selection will move the entire mesh.
     // So move every triangle uniformly 
     for (int[] triangle: triangles) {
      v1 = vertices.get(triangle[0]);
      v2 = vertices.get(triangle[1]);
      v3 = vertices.get(triangle[2]);

      v1[0] += x - xP;
      v1[1] += y - yP;

      v2[0] += x - xP;
      v2[1] += y - yP;

      v3[0] += x - xP;
      v3[1] += y - yP;
     }

     redraw(); 
  }

}


PImage controlPanel;
int PANEL_ICONS = 10;
int PANEL_WIDTH = 640; 
int PANEL_HEIGHT = 64;

final color COLOURS[] = {
  #F0FFF0, // Honeydew
  #4682B4, // Steel Blue
  #483D8B, // Dark Slate Blue
  #800080, // Web Purple
  #FFD700, // Gold
  #D2691E, // Chocolate
  #FFF5EE, // Seashell
  #EE82EE, // Violet
  #AFEEEE, // Pale Turquoise
  #696969, // Dim Gray
  #FFE4E1, // Misty Rose
  #BC8F8F, // Rosy Brown
  #87CEFA, // Light Sky Blue
  #8A2BE2, // Blue Violet
  #F5F5DC, // Beige
  #FFFF00, // Yellow
  #B8860B, // Dark Goldenrod
  #00FFFF, // Cyan
  #D2B48C, // Tan
  #6495ED, // Cornflower Blue
  #F08080, // Light Coral
  #90EE90, // Light Green
  #FF00FF, // Magenta
  #F0E68C, // Khaki
  #FF4500, // Orange Red
  #800000, // Web Maroon
  #C71585, // Medium Violet Red
  #00BFFF, // Deep Sky Blue
  #008000, // Web Green
  #ADD8E6, // Light Blue
  #556B2F, // Dark Olive Green
  #FFA500, // Orange
  #FFB6C1, // Light Pink
  #006400, // Dark Green
  #D8BFD8, // Thistle
  #E6E6FA, // Lavender
  #008B8B, // Dark Cyan
  #000080, // Navy Blue
  #D3D3D3, // Light Gray
  #0000CD, // Medium Blue
  #FFFFFF, // White
  #FFFFF0, // Ivory
  #F4A460, // Sandy Brown
  #191970, // Midnight Blue
  #6A5ACD, // Slate Blue
  #BEBEBE, // Gray
  #ADFF2F, // Green Yellow
  #5F9EA0, // Cadet Blue
  #FFF8DC, // Cornsilk
  #FFA07A, // Light Salmon
  #FFEFD5, // Papaya Whip
  #6B8E23, // Olive Drab
  #FF0000, // Red
  #FFFAFA, // Snow
  #E9967A, // Dark Salmon
  #98FB98, // Pale Green
  #808000, // Olive
  #FA8072, // Salmon
  #4B0082, // Indigo
  #CD853F, // Peru
  #00CED1, // Dark Turquoise
  #B03060, // Maroon
  #663399, // Rebecca Purple
  #F5FFFA, // Mint Cream
  #1E90FF, // Dodger Blue
  #008080, // Teal
  #B22222, // Firebrick
  #DCDCDC, // Gainsboro
  #FF6347, // Tomato
  #F0F8FF, // Alice Blue
  #FF8C00, // Dark Orange
  #FFF0F5, // Lavender Blush
  #228B22, // Forest Green
  #F8F8FF, // Ghost White
  #66CDAA, // Medium Aquamarine
  #DAA520, // Goldenrod
  #A0522D, // Sienna
  #C0C0C0, // Silver
  #E0FFFF, // Light Cyan
  #00008B, // Dark Blue
  #87CEEB, // Sky Blue
  #8B008B, // Dark Magenta
  #7B68EE, // Medium Slate Blue
  #778899, // Light Slate Gray
  #20B2AA, // Light Sea Green
  #FFEBCD, // Blanched Almond
  #DEB887, // Burlywood
  #7CFC00, // Lawn Green
  #CD5C5C, // Indian Red
  #7FFFD4, // Aquamarine
  #FAF0E6, // Linen
  #00FF00, // Green
  #8B4513, // Saddle Brown
  #FF69B4, // Hot Pink
  #FFE4C4, // Bisque
  #FF1493, // Deep Pink
  #FFFACD, // Lemon Chiffon
  #9ACD32, // Yellow Green
  #9370DB, // Medium Purple
  #FFC0CB, // Pink
  #808080, // Web Gray
  #DB7093, // Pale Violet Red
  #B0C4DE, // Light Steel Blue
  #00FF00, // Lime
  #DC143C, // Crimson
  #DA70D6, // Orchid
  #8FBC8F, // Dark Sea Green
  #3CB371, // Medium Sea Green
  #00FA9A, // Medium Spring Green
  #FAEBD7, // Antique White
  #BA55D3, // Medium Orchid
  #FFE4B5, // Moccasin
  #DDA0DD, // Plum
  #FFDAB9, // Peach Puff
  #FF7F50, // Coral
  #FFFFE0, // Light Yellow
  #708090, // Slate Gray
  #00FFFF, // Aqua
  #FAFAD2, // Light Goldenrod
  #9932CC, // Dark Orchid
  #2E8B57, // Sea Green
  #A52A2A, // Brown
  #B0E0E6, // Powder Blue
  #48D1CC, // Medium Turquoise
  #FFFAF0, // Floral White
  #A9A9A9, // Dark Gray
  #40E0D0, // Turquoise
  #F5F5F5, // White Smoke
  #4169E1, // Royal Blue
  #FF00FF, // Fuchsia
  #32CD32, // Lime Green
  #00FF7F, // Spring Green
  #A020F0, // Purple
  #000000, // Black
  #BDB76B, // Dark Khaki
  #F5DEB3, // Wheat
  #F0FFFF, // Azure
  #FFDEAD, // Navajo White
  #FDF5E6, // Old Lace
  #9400D3, // Dark Violet
  #7FFF00, // Chartreuse
  #0000FF, // Blue
  #EEE8AA, // Pale Goldenrod
  #8B0000, // Dark Red
  #2F4F4F, // Dark Slate Gray
};
