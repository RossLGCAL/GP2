#version 330

//Data In
in vec2 texCoords;
in vec3 worldNormal;
in vec3 cameraDirectionOut;
in vec3 lightInTangentSpace;
in vec3 cameraInTangentSpace;

// textures
layout(location = 0) uniform sampler2D u_diffuseTexture;
layout(location = 1) uniform sampler2D u_heightTexture;
layout(location = 2) uniform sampler2D u_normalTexture;

//Uniforms
uniform vec3 lightDirection;
uniform vec4 ambientMaterialColour;
uniform vec4 diffuseMaterialColour;
uniform vec4 specularMaterialColour;
uniform vec4 ambientLightColour;
uniform vec4 diffuseLightColour;
uniform vec4 specularLightColour;
uniform float specularPower;
uniform float parallaxScale;
uniform samplerCube cubeTexture;

//Data Out
out vec4 FragColor;
out vec4 resultingColor;

vec2 parallaxMapping(in vec3 V, in vec2 T, out float parallaxHeight)
{
   // get depth for this fragment
   float initialHeight = texture(u_heightTexture, texCoords).r;

   // calculate amount of offset for Parallax Mapping
   vec2 texCoordOffset = parallaxScale * V.xy / V.z * initialHeight;

   // calculate amount of offset for Parallax Mapping With Offset Limiting
   texCoordOffset = parallaxScale * V.xy * initialHeight;

   // retunr modified texture coordinates
   return texCoords - texCoordOffset;
}

vec4 normalMappingLighting(in vec2 T, in vec3 L, in vec3 V, float shadowMultiplier)
{
   // restore normal from normal map
   vec3 N = normalize(texture(u_normalTexture, T).xyz * 2 - 1);
   vec3 D = texture(u_diffuseTexture, T).rgb;

   // ambient lighting
   float iamb = 0.2;

   // diffuse lighting
   float idiff = clamp(dot(N, L), 0, 1);

   // specular lighting
   float ispec = 0;

   if(dot(N, L) > 0.2)
   {
      vec3 R = reflect(-L, N);
      ispec = pow(dot(R, V), 32) / 1.5;
   }

   vec4 resColor;
   resColor.rgb = D * (ambientLighting + (idiff + ispec) * pow(shadowMultiplier, 4));
   resColor.a = 1;

   return resColor;
}

void main(void)
{
	// normalize vectors after vertex shader
    vec3 V = normalize(cameraInTangentSpace);
    vec3 L = normalize(lightInTangentSpace);

	vec3 lightDirectionNormalized=normalize(lightDirection);
	vec3 halfWayVec = normalize(cameraDirectionOut + lightDirectionNormalized);
	float diffuseTerm = max(dot(worldNormal, lightDirectionNormalized),0.0f);
	float specularTerm = pow(max(dot(worldNormal, halfWayVec),0.0f), specularPower);

	vec3 reflected = reflect (normalize(worldNormal), normalize(cameraDirectionOut));
	vec4 reflectionColour = texture(cubeTexture, normalize(reflected));

	vec4 materialColour = (ambientMaterialColour*ambientLightColour) + (diffuseMaterialColour*diffuseLightColour*diffuseTerm) + (specularMaterialColour*specularLightColour*specularTerm);

	FragColor=mix(materialColour,reflectionColour,0.5f);

	// get new texture coordinates from Parallax Mapping
    float parallaxHeight;
    vec2 T = parallaxMapping(V, texCoords, parallaxHeight);

	// get self-shadowing factor for elements of parallax
    float shadowMultiplier = parallaxSoftShadowMultiplier(L, T, parallaxHeight - 0.05);

    // calculate lighting
    resultingColor = normalMappingLighting(T, L, V, shadowMultiplier);
}

