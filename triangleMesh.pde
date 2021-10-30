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

  // your code here

  resetMatrix();
  
  // use this for a unit coordinate system:
  resetMatrix();
  scale(1,-1);
  image(controlPanel, -1, 1-2.0*PANEL_HEIGHT/height, 2.0*PANEL_WIDTH/width, 2.0*PANEL_HEIGHT/height);
  // use this for a window coordinate system:
  //image(controlPanel, 0, height-PANEL_HEIGHT, PANEL_WIDTH, PANEL_HEIGHT);
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
//  #000000, // Black
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
