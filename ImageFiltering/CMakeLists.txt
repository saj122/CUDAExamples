cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
project(ImageFiltering LANGUAGES CXX CUDA)
 
include(CTest)

find_package( OpenCV REQUIRED )
include_directories( ${OpenCV_INCLUDE_DIRS} )

add_library(image_filtering STATIC
    kernel.cu
    kernel.h
)

target_compile_features(image_filtering PUBLIC cxx_std_17)
 
set_target_properties( image_filtering
                       PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
set_property(TARGET image_filtering PROPERTY CUDA_ARCHITECTURES 70 72 75 80 86)
 
add_executable(image_filtering_test test.cu)
 
set_property(TARGET image_filtering_test 
             PROPERTY CUDA_SEPARABLE_COMPILATION ON)
set_property(TARGET image_filtering_test PROPERTY CUDA_ARCHITECTURES 70 72 75 80 86)
target_link_libraries(image_filtering_test PRIVATE image_filtering ${OpenCV_LIBS})
