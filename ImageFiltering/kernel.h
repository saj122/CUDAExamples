#ifndef KERNEL_H
#define KERNEL_H

struct uchar4;

void sharpenParallel(uchar4 *arr, int w, int h);
void intensityParallel(uchar4 *arr, unsigned char* out, int w, int h);
void horizSobelParallel(unsigned char *arr, int w, int h);
#endif