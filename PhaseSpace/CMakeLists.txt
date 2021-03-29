cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
project(PhaseSpace LANGUAGES CXX CUDA)
 
include(CTest)

set(OpenGL_GL_PREFERENCE "LEGACY")
 
find_package(GLUT REQUIRED)
if (GLUT_FOUND)
  include_directories(${GLUT_INCLUDE_DIR})
endif()

find_package(GLEW REQUIRED)
if (GLEW_FOUND)
    include_directories($(GLEW_INCLUDE_DIRS))
endif()

find_package(OpenGL)

add_library(phase_space STATIC
  interactions.h
  kernel.cu
  kernel.h
)

target_compile_features(phase_space PUBLIC cxx_std_17)
 
set_target_properties( phase_space
                       PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
set_property(TARGET phase_space PROPERTY CUDA_ARCHITECTURES 70 72 75 80 86)
 
add_executable(phase_space_test test.cu)
 
set_property(TARGET phase_space_test 
             PROPERTY CUDA_SEPARABLE_COMPILATION ON)
set_property(TARGET phase_space_test PROPERTY CUDA_ARCHITECTURES 70 72 75 80 86)
target_link_libraries(phase_space_test PRIVATE phase_space ${GLUT_LIBRARIES} ${GLEW_LIBRARIES} ${OPENGL_LIBRARY} )
