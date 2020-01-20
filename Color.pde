color red = color(255, 0, 0);
color green = color(0, 255, 0);
color blue = color(0, 0, 255);
color wood = color(193, 154, 107);
color purple = color(150, 70, 180);
color orange = color(255, 100,0);


//used only for development purposes
void drawGrid() {
    stroke(255);
    textSize(10);
    for (int i=0; i<width - 400; i+=100) {
        for (int j=0; j < height; j+=100) {

            line(i, 10, i, height);
            text(i, i, 10);
            line (0, j, width, j);
            text(j, 10, j);
        }
    }
}
