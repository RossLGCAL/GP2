// basic fragment shader for Parallax Mapping
#version 330

// data from vertex shader
in vec2	o_texcoords;
in vec3	o_toLightInTangentSpace;
in vec3	o_toCameraInTangentSpace;

// textures
layout(location = 0) uniform sampler2D u_diffuseTexture;
layout(location = 1) uniform sampler2D u_heightTexture;
layout(location = 2) uniform sampler2D u_normalTexture;

// color output to the framebuffer
out vec4 resultingColor;

// scale for size of Parallax Mapping effect
uniform float	parallaxScale; // ~0.1

// Implements Parallax Mapping technique
// Returns modified texture coordinates, and last used depth
vec2 parallaxMapping(in vec3 V, in vec2 T, out float parallaxHeight)
{
      // determine optimal number of layers
   const float minLayers = 10;
   const float maxLayers = 15;
   float numLayers = mix(maxLayers, minLayers, abs(dot(vec3(0, 0, 1), V)));

   // height of each layer
   float layerHeight = 1.0 / numLayers;
   // current depth of the layer
   float curLayerHeight = 0;
   // shift of texture coordinates for each layer
   vec2 dtex = parallaxScale * V.xy / V.z / numLayers;

   // current texture coordinates
   vec2 currentTextureCoords = T;

   // depth from heightmap
   float heightFromTexture = texture(u_heightTexture, currentTextureCoords).r;

   // while point is above the surface
   while(heightFromTexture > curLayerHeight) 
   {
      // to the next layer
      curLayerHeight += layerHeight; 
      // shift of texture coordinates
      currentTextureCoords -= dtex;
      // new depth from heightmap
      heightFromTexture = texture(u_heightTexture, currentTextureCoords).r;
   }

   ///////////////////////////////////////////////////////////

   // previous texture coordinates
   vec2 prevTCoords = currentTextureCoords + texStep;

   // heights for linear interpolation
   float nextH	= heightFromTexture - curLayerHeight;
   float prevH	= texture(u_heightTexture, prevTCoords).r
                           - curLayerHeight + layerHeight;

   // proportions for linear interpolation
   float weight = nextH / (nextH - prevH);

   // interpolation of texture coordinates
   vec2 finalTexCoords = prevTCoords * weight + currentTextureCoords * (1.0-weight);

   // interpolation of depth values
   parallaxHeight = curLayerHeight + prevH * weight + nextH * (1.0 - weight);

   // return result
   return finalTexCoords;
}

// Implements self-shadowing technique - hard or soft shadows
// Returns shadow factor
float parallaxSoftShadowMultiplier(in vec3 L, in vec2 initialTexCoord, in float initialHeight)
{
   float shadowMultiplier = 1;

   const float minLayers = 15;
   const float maxLayers = 30;

   // calculate lighting only for surface oriented to the light source
   if(dot(vec3(0, 0, 1), L) > 0)
   {
      // calculate initial parameters
      float numSamplesUnderSurface	= 0;
      shadowMultiplier	= 0;
      float numLayers	= mix(maxLayers, minLayers, abs(dot(vec3(0, 0, 1), L)));
      float layerHeight	= initialHeight / numLayers;
      vec2 texStep	= parallaxScale * L.xy / L.z / numLayers;

      // current parameters
      float currentLayerHeight	= initialHeight - layerHeight;
      vec2 currentTextureCoords	= initialTexCoord + texStep;
      float heightFromTexture	= texture(u_heightTexture, currentTextureCoords).r;
      int stepIndex	= 1;

      // while point is below depth 0.0 )
      while(currentLayerHeight > 0)
      {
         // if point is under the surface
         if(heightFromTexture < currentLayerHeight)
         {
            // calculate partial shadowing factor
            numSamplesUnderSurface	+= 1;
            float newShadowMultiplier	= (currentLayerHeight - heightFromTexture) *
                                             (1.0 - stepIndex / numLayers);
            shadowMultiplier	= max(shadowMultiplier, newShadowMultiplier);
         }

         // offset to the next layer
         stepIndex	+= 1;
         currentLayerHeight	-= layerHeight;
         currentTextureCoords	+= texStep;
         heightFromTexture	= texture(u_heightTexture, currentTextureCoords).r;
      }

      // Shadowing factor should be 1 if there were no points under the surface
      if(numSamplesUnderSurface < 1)
      {
         shadowMultiplier = 1;
      }
      else
      {
         shadowMultiplier = 1.0 - shadowMultiplier;
      }
   }
   return shadowMultiplier;
}

// Calculates lighting by Blinn-Phong model and Normal Mapping
// Returns color of the fragment
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

// Entry point for Parallax Mapping shader
void main(void)
{
   // normalize vectors after vertex shader
   vec3 V = normalize(o_toCameraInTangentSpace);
   vec3 L = normalize(o_toLightInTangentSpace);

   // get new texture coordinates from Parallax Mapping
   float parallaxHeight;
   vec2 T = parallaxMapping(V, o_texcoords, parallaxHeight);

   // get self-shadowing factor for elements of parallax
   float shadowMultiplier = parallaxSoftShadowMultiplier(L, T, parallaxHeight - 0.05);

   // calculate lighting
   resultingColor = normalMappingLighting(T, L, V, shadowMultiplier);
}
