#include "kernel.h"

#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>

#include <cuda_runtime.h>
#include <stdlib.h>

#include <iostream>

int main(int argc, char** argv)
{
    std::string str(argv[1]);
    std::cout << str << std::endl;
    cv::Mat img = cv::imread(str, cv::IMREAD_COLOR);
    if(img.empty())
    {
        std::cout << "Could not read the image: " << str << std::endl;
        return 1;
    }

    cv::namedWindow("Original", 0);
    cv::resizeWindow("Original", 1280,720);
    cv::imshow("Original", img);
    
    const int w = img.cols;
    const int h = img.rows;

    if(*argv[2] == '0')
    {
        uchar4 *arrS = (uchar4*)malloc(w*h*sizeof(uchar4));
        cv::Mat sharp = img.clone();
        uint8_t* pixelPtr = (uint8_t*)img.data;
        int cn = img.channels();
        for (int r = 0; r < h; ++r) {
            for (int c = 0; c < w; ++c) {
                arrS[r*w + c].x = pixelPtr[r*img.cols*cn + c*cn + 0];
                arrS[r*w + c].y = pixelPtr[r*img.cols*cn + c*cn + 1];
                arrS[r*w + c].z = pixelPtr[r*img.cols*cn + c*cn + 2];
            }
        }

        sharpenParallel(arrS, w, h);

        for (int r = 0; r < h; ++r) {
            for (int c = 0; c < w; ++c) {
                sharp.at<uchar>(r, c, 0) = arrS[r*w + c].x;
                sharp.at<uchar>(r, c, 1) = arrS[r*w + c].y;
                sharp.at<uchar>(r, c, 2) = arrS[r*w + c].z;
            }
        }
        
        
        cv::namedWindow("Sharpen", 0);
        cv::resizeWindow("Sharpen", 1280,720);
        cv::imshow("Sharpen", sharp);
        cv::waitKey(0);
        free(arrS);
    }
    else if(*argv[2] == '1')
    {
        uchar4 *arrI = (uchar4*)malloc(w*h*sizeof(uchar4));

        uint8_t* pixelPtr = (uint8_t*)img.data;
        int cn = img.channels();
        for (int r = 0; r < h; ++r) {
            for (int c = 0; c < w; ++c) {
                arrI[r*w + c].x = pixelPtr[r*img.cols*cn + c*cn + 0];
                arrI[r*w + c].y = pixelPtr[r*img.cols*cn + c*cn + 1];
                arrI[r*w + c].z = pixelPtr[r*img.cols*cn + c*cn + 2];
            }
        }

        unsigned char* outArr = (unsigned char*)malloc(w*h*sizeof(unsigned char));
        intensityParallel(arrI, outArr, w, h);
        cv::Mat intens = cv::Mat(img.rows,img.cols, CV_8UC1, (void*)outArr);

        cv::namedWindow("Intensity", 0);
        cv::resizeWindow("Intensity", 1280,720);
        cv::imshow("Intensity", intens);
        cv::waitKey(0);
        free(arrI);
        free(outArr);
    }
    else if(false)
    {
        unsigned char* outArr = (unsigned char*)malloc(w*h*sizeof(unsigned char));
        uint8_t* pixelPtr = (uint8_t*)img.data;
        int cn = img.channels();
        for (int r = 0; r < h; ++r) {
            for (int c = 0; c < w; ++c) {
                outArr[r*w + c] = 0.2126*pixelPtr[r*img.cols*cn + c*cn + 0] + 0.7152*pixelPtr[r*img.cols*cn + c*cn + 1]+0.0722*pixelPtr[r*img.cols*cn + c*cn + 2];
            }
        }

        horizSobelParallel(outArr, w, h);

        cv::Mat sobel = cv::Mat(img.rows,img.cols, CV_8UC1, (void*)outArr);
        
        cv::namedWindow("Sobel", 0);
        cv::resizeWindow("Sobel", 1280,720);
        cv::imshow("Sobel", sobel);
        cv::waitKey(0);
        free(outArr);
    }

    return 0;
}