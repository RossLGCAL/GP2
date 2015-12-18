cmake_minimum_required (VERSION 2.8)
project (GP2)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
list( APPEND CMAKE_CXX_FLAGS "-std=c++0x ${CMAKE_CXX_FLAGS}")

set(CMAKE_PREFIX_PATH "C:/Dev/glew/include")
set(CMAKE_LIBRARY_PATH "C:/Dev/glew/lib/Release/x64")

find_package(OpenGL REQUIRED)
find_package(SDL2 REQUIRED)
find_package(SDL2_Image REQUIRED)
find_package(SDL2_TTF REQUIRED)
find_package(GLEW REQUIRED)
find_package(GLM REQUIRED)
find_package(FBX REQUIRED)

add_executable(GP2 src/main.cpp src/Graphics.cpp src/Shader.cpp src/Texture.cpp src/FBXLoader.cpp src/FileSystem.cpp src/GameObject.cpp src/Mesh.cpp src/Material.cpp src/OutlineMaterial.cpp src/ToonMaterial.cpp
include/Common.h include/FBXLoader.h include/Graphics.h include/Shader.h include/Vertices.h include/Texture.h include/Mesh.h include/FileSystem.h include/GameObject.h
include/Cube.h include/Mesh.h include/Material.h include/OutlineMaterial.h include/ToonMaterial.h)

include_directories(GP2 include/ ${OPENGL_INCLUDE_DIRS} ${SDL2_INCLUDE_DIR} ${GLEW_INCLUDE_DIRS} ${GLM_INCLUDE_DIRS} ${SDL2IMAGE_INCLUDE_DIR} ${SDL2_TTF_INCLUDE_DIR} ${FBX_INCLUDE_DIR})
# create the program
target_link_libraries(GP2 ${SDL2_LIBRARY} ${OPENGL_LIBRARIES} ${GLEW_LIBRARIES} ${SDL2IMAGE_LIBRARY} ${SDL2_TTF_LIBRARY} ${FBX_LIBRARY})

if (MSVC)
add_custom_command(TARGET GP2  POST_BUILD
                   COMMAND ${CMAKE_COMMAND} -E copy_directory
                       ${CMAKE_SOURCE_DIR}/dlls $<TARGET_FILE_DIR:GP2>)
endif (MSVC)

add_custom_command(TARGET GP2  PRE_BUILD
                   COMMAND ${CMAKE_COMMAND} -E copy_directory
                 ${CMAKE_SOURCE_DIR}/assets $<TARGET_FILE_DIR:GP2>/assets)
