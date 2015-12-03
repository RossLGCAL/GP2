#version 150

in vec3 vertexPosition;
in vec3 instancePosition;

uniform mat4 MVP;

void main()
{
  gl_Position = MVP * vec4((vertexPosition+instancePosition), 1.0);
}
