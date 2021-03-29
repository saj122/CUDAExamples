#ifndef INTERACTIONS_H
#define INTERACTIONS_H

#define W 800
#define H 800
#define TITLE_STRING "Phase Space"
float dampening = 10.0f;
float delta_p = 1.0f;
int sys = 0;

void keyboard(unsigned char key, int x, int y) {
  if (key == 27) exit(0);
  if (key == '0')
  {
    sys = 0;
    delta_p = 1.0f;
    dampening = 10.0f;
  } 
  if (key == '1')
  {
    sys = 1;
    delta_p = 0.2f;
    dampening = 0.2f;
  }
  if (key == '2')
  {
    delta_p = 0.005f;
    dampening = 0.005f;
    sys = 2;
  } 
  glutPostRedisplay();
}

void handleSpecialKeypress(int key, int x, int y) {
  if (key == GLUT_KEY_DOWN) dampening -= delta_p;
  if (key == GLUT_KEY_UP) dampening += delta_p;
  glutPostRedisplay();
}

void printInstructions() {
  printf("Phase Space Visualizer\n");
  printf("Use number keys to select system:\n");
  printf("\t0: linear oscillator: positive stiffness\n");
  printf("\t1: linear oscillator: negative stiffness\n");
  printf("\t2: simple damped pendulum\n");
  printf("up/down arrow keys adjust dampening value\n\n");
}

#endif
