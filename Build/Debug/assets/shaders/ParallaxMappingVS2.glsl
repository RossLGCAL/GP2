#version 330

//Data In
in vec3 vertexPosition;
in vec3 vertexNormal;

//Attributes
layout(location = 0) in vec3 i_position;	// xyz - position
layout(location = 1) in vec3 i_normal;	   // xyz - normal
layout(location = 2) in vec2 i_texcoord0; // xy - texture coords
layout(location = 3) in vec4 i_tangent;  // xyz - tangent, w - handedness

//Uniforms
uniform mat4 MVP;
uniform mat4 Model;
uniform mat4 Projection;
uniform mat3 Normal;
uniform vec3 lightPosition;
uniform vec3 cameraPosition;

//Data Out
out vec2 texCoords;
out vec3 worldNormal;
out vec3 cameraDirectionOut;
out vec3 lightInTangentSpace;
out vec3 cameraInTangentSpace;

void main(void)
{
	worldNormal = normalize(Model*vec4(vertexNormal, 0.0f)).xyz;
	vec3 worldPos = (Model*vec4(vertexPosition, 1.0)).xyz;
	cameraDirectionOut = normalize(cameraPosition - worldPos);
	vec3 worldTangent = normalize(Normal * i_tangent.xyz);

    vec3 worldDirectionToLight = normalize(lightPosition - worldPos.xyz);
    vec3 worldDirectionToCamera = normalize(cameraPosition - worldPos.xyz);

    vec3 worldBitangnent = cross(worldNormal, worldTangent) * i_tangent.w;

	lightInTangentSpace = vec3(dot(worldDirectionToLight, worldTangent),dot(worldDirectionToLight, worldBitangnent),dot(worldDirectionToLight, worldNormal));

	cameraInTangentSpace = vec3(dot(worldDirectionToCamera, worldTangent),dot(worldDirectionToCamera, worldBitangnent),dot(worldDirectionToCamera, worldNormal));

	texCoords = i_texcoord0;

	gl_Position = Projection* MVP * worldPos;
}
