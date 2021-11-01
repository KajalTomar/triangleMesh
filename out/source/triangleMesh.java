import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class triangleMesh extends PApplet {

//------------------------------------------------------------------------------
// NAME: Kajal Tomar
// STUDENT NUMBER: 7793306
// COURSE: COMP3490
// INSTRUCTOR: John Braico
// ASSIGNMENT: 2, QUESTION: 2
//------------------------------------------------------------------------------
final float VERTICE_RADIUS = 0.03f; // to set the radius for the handles

ArrayList<float[]> vertices = new ArrayList<float[]>(); // [x,y]
ArrayList<int[]> triangles = new ArrayList<int[]>(); // [v1, v1, v3] // list of all the triangles

float panel_top;

// keeps track of what is selected 
int currentlySelected = -1; 
int selectedVertex = -1;
int selectedEdge = -1; 

boolean hit; 

public void setup() {
  
  
  frameRate(30);

  // all of this is optional:
  colorMode(RGB, 1.0f);
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

public void draw() {
  background(0.9f, 0.85f, 0.85f);
 
  resetMatrix();
  drawTriangles();

  // use this for a unit coordinate system:
  resetMatrix();
  scale(1,-1);
  image(controlPanel, -1, 1-2.0f*PANEL_HEIGHT/height, 2.0f*PANEL_WIDTH/width, 2.0f*PANEL_HEIGHT/height);
  panel_top = 2.0f*PANEL_HEIGHT/height-1;

  // use this for a window coordinate system:
  //image(controlPanel, 0, height-PANEL_HEIGHT, PANEL_WIDTH, PANEL_HEIGHT);
}

// draws all the triangles 
// based on whether they are selected or not
public void drawTriangles(){
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
public void drawUnselectedTriangle(float[] v1, float[] v2, float[] v3){
 
  strokeWeight(2);
  noFill();

  beginShape(TRIANGLES);
    vertex(v1[0], v1[1]);
    vertex(v2[0], v2[1]);
    vertex(v3[0], v3[1]);
  endShape();
    
}

// draws a triangle if it's selected
public void drawSelectedTriangle(float[] v1, float[] v2, float[] v3){

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
public void mouseClicked(){
  float x = 2.0f * mouseX / width - 1; // convert mouseX to unit coordinates
  float y = 2.0f * (height-mouseY+1) / height - 1; // convert mouseY to unit coordinates
 
  // make sure the user clicked within the panel
  if(y < panel_top){

    // the width of the panel is divided into 10 sections 
    // each if statement will call the corresponding function 
    // to the given button.
    if(x >= -1 && x <- 0.8f){
      moveLeft();
    }
    else if(x >= -0.8f && x < -0.6f){
      moveUp();
    }
    else if(x >= -0.6f && x < -0.4f){
     moveDown();
    }
    else if(x >= -0.4f && x < -0.2f){
      moveRight();
    }
    else if(x >= -0.2f && x < 0.0f){
      scale(true); 
    }
    else if(x >= 0.0f && x < 0.2f){
      scale(false);
    }
    else if(x >= 0.2f && x < 0.4f){
      rotate(false);
    }
    else if(x >= 0.4f && x < 0.6f){
      rotate(true);
    }
    else if(x >= 0.6f && x < 0.8f){
     cut();
    }
    else if(x >= 0.8f && x < 1.0f){
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
public void moveLeft(){
  float moveAmount = 0.05f;
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
public void moveUp(){
  float moveAmount = 0.05f;
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
public void moveDown(){
  float moveAmount = 0.05f;
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
public void moveRight(){
  float moveAmount = 0.05f;
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
public void scale(boolean scaleUp){
  float scaleAmount = 0.90f; 
  int[] tri;
  float[] v1,v2,v3;
  float[] center = new float[2];
 
  
  if(scaleUp){
    scaleAmount = 1.10f;
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
public void rotate(boolean CC){
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
public void cut(){
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
public void generateRandomTriangle(){

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
public boolean isDegenerate(float[] v1, float[] v2, float[] v3){
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
public float crossProduct(PVector v1, PVector v2){
   return (v1.x*v2.y - v1.y*v2.x);
}

// what happens when a user interacts with
// the mesh and the triangles 
public void mousePressed(){
  boolean pInside = false;
  PVector e1, e2, e3; // edges
  PVector a1, a2, a3; // areas
  float[] v1, v2, v3; // vertices
  float distanceFromv1, distanceFromv2, distanceFromv3;
  float e1CrossA1, e2CrossA2, e3CrossA3;  // cross products 

  // change mouse x and y to unit coordinate system
  float x = 2.0f * mouseX / width - 1;
  float y = 2.0f * (height-mouseY+1) / height - 1;

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
      else if(abs(e1CrossA1) <= 0.02f && abs(e2CrossA2) >= 0.02f && abs(e3CrossA3) >= 0.02f){
          selectedEdge = 1;
          selectedVertex = -1;
           hit = true;
          break;
      }
      else if(abs(e1CrossA1) >= 0.02f && abs(e2CrossA2) <= 0.02f && abs(e3CrossA3) >= 0.02f){
    
          selectedEdge = 2; 
          selectedVertex = -1;
           hit = true;
          break;
      }
      else if(abs(e1CrossA1) >= 0.02f && abs(e2CrossA2) >= 0.02f && abs(e3CrossA3) <= 0.02f){
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
public void mouseReleased() {
  hit = false;
}

// drag the appropriate things
public void mouseDragged() {
  int[] tri;
  float[] v1,v2,v3;

  // convert to unit coordinates
  float x = 2.0f * mouseX / width - 1;
  float y = 2.0f * (height-mouseY+1) / height - 1;
  float xP = 2.0f * pmouseX / width - 1;
  float yP = 2.0f * (height-pmouseY+1) / height - 1;
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

final int COLOURS[] = {
  0xffF0FFF0, // Honeydew
  0xff4682B4, // Steel Blue
  0xff483D8B, // Dark Slate Blue
  0xff800080, // Web Purple
  0xffFFD700, // Gold
  0xffD2691E, // Chocolate
  0xffFFF5EE, // Seashell
  0xffEE82EE, // Violet
  0xffAFEEEE, // Pale Turquoise
  0xff696969, // Dim Gray
  0xffFFE4E1, // Misty Rose
  0xffBC8F8F, // Rosy Brown
  0xff87CEFA, // Light Sky Blue
  0xff8A2BE2, // Blue Violet
  0xffF5F5DC, // Beige
  0xffFFFF00, // Yellow
  0xffB8860B, // Dark Goldenrod
  0xff00FFFF, // Cyan
  0xffD2B48C, // Tan
  0xff6495ED, // Cornflower Blue
  0xffF08080, // Light Coral
  0xff90EE90, // Light Green
  0xffFF00FF, // Magenta
  0xffF0E68C, // Khaki
  0xffFF4500, // Orange Red
  0xff800000, // Web Maroon
  0xffC71585, // Medium Violet Red
  0xff00BFFF, // Deep Sky Blue
  0xff008000, // Web Green
  0xffADD8E6, // Light Blue
  0xff556B2F, // Dark Olive Green
  0xffFFA500, // Orange
  0xffFFB6C1, // Light Pink
  0xff006400, // Dark Green
  0xffD8BFD8, // Thistle
  0xffE6E6FA, // Lavender
  0xff008B8B, // Dark Cyan
  0xff000080, // Navy Blue
  0xffD3D3D3, // Light Gray
  0xff0000CD, // Medium Blue
  0xffFFFFFF, // White
  0xffFFFFF0, // Ivory
  0xffF4A460, // Sandy Brown
  0xff191970, // Midnight Blue
  0xff6A5ACD, // Slate Blue
  0xffBEBEBE, // Gray
  0xffADFF2F, // Green Yellow
  0xff5F9EA0, // Cadet Blue
  0xffFFF8DC, // Cornsilk
  0xffFFA07A, // Light Salmon
  0xffFFEFD5, // Papaya Whip
  0xff6B8E23, // Olive Drab
  0xffFF0000, // Red
  0xffFFFAFA, // Snow
  0xffE9967A, // Dark Salmon
  0xff98FB98, // Pale Green
  0xff808000, // Olive
  0xffFA8072, // Salmon
  0xff4B0082, // Indigo
  0xffCD853F, // Peru
  0xff00CED1, // Dark Turquoise
  0xffB03060, // Maroon
  0xff663399, // Rebecca Purple
  0xffF5FFFA, // Mint Cream
  0xff1E90FF, // Dodger Blue
  0xff008080, // Teal
  0xffB22222, // Firebrick
  0xffDCDCDC, // Gainsboro
  0xffFF6347, // Tomato
  0xffF0F8FF, // Alice Blue
  0xffFF8C00, // Dark Orange
  0xffFFF0F5, // Lavender Blush
  0xff228B22, // Forest Green
  0xffF8F8FF, // Ghost White
  0xff66CDAA, // Medium Aquamarine
  0xffDAA520, // Goldenrod
  0xffA0522D, // Sienna
  0xffC0C0C0, // Silver
  0xffE0FFFF, // Light Cyan
  0xff00008B, // Dark Blue
  0xff87CEEB, // Sky Blue
  0xff8B008B, // Dark Magenta
  0xff7B68EE, // Medium Slate Blue
  0xff778899, // Light Slate Gray
  0xff20B2AA, // Light Sea Green
  0xffFFEBCD, // Blanched Almond
  0xffDEB887, // Burlywood
  0xff7CFC00, // Lawn Green
  0xffCD5C5C, // Indian Red
  0xff7FFFD4, // Aquamarine
  0xffFAF0E6, // Linen
  0xff00FF00, // Green
  0xff8B4513, // Saddle Brown
  0xffFF69B4, // Hot Pink
  0xffFFE4C4, // Bisque
  0xffFF1493, // Deep Pink
  0xffFFFACD, // Lemon Chiffon
  0xff9ACD32, // Yellow Green
  0xff9370DB, // Medium Purple
  0xffFFC0CB, // Pink
  0xff808080, // Web Gray
  0xffDB7093, // Pale Violet Red
  0xffB0C4DE, // Light Steel Blue
  0xff00FF00, // Lime
  0xffDC143C, // Crimson
  0xffDA70D6, // Orchid
  0xff8FBC8F, // Dark Sea Green
  0xff3CB371, // Medium Sea Green
  0xff00FA9A, // Medium Spring Green
  0xffFAEBD7, // Antique White
  0xffBA55D3, // Medium Orchid
  0xffFFE4B5, // Moccasin
  0xffDDA0DD, // Plum
  0xffFFDAB9, // Peach Puff
  0xffFF7F50, // Coral
  0xffFFFFE0, // Light Yellow
  0xff708090, // Slate Gray
  0xff00FFFF, // Aqua
  0xffFAFAD2, // Light Goldenrod
  0xff9932CC, // Dark Orchid
  0xff2E8B57, // Sea Green
  0xffA52A2A, // Brown
  0xffB0E0E6, // Powder Blue
  0xff48D1CC, // Medium Turquoise
  0xffFFFAF0, // Floral White
  0xffA9A9A9, // Dark Gray
  0xff40E0D0, // Turquoise
  0xffF5F5F5, // White Smoke
  0xff4169E1, // Royal Blue
  0xffFF00FF, // Fuchsia
  0xff32CD32, // Lime Green
  0xff00FF7F, // Spring Green
  0xffA020F0, // Purple
  0xff000000, // Black
  0xffBDB76B, // Dark Khaki
  0xffF5DEB3, // Wheat
  0xffF0FFFF, // Azure
  0xffFFDEAD, // Navajo White
  0xffFDF5E6, // Old Lace
  0xff9400D3, // Dark Violet
  0xff7FFF00, // Chartreuse
  0xff0000FF, // Blue
  0xffEEE8AA, // Pale Goldenrod
  0xff8B0000, // Dark Red
  0xff2F4F4F, // Dark Slate Gray
};
  public void settings() {  size(640, 640, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "triangleMesh" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
