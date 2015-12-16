#version 150

out vec4 FragColor;
in vec3 worldNormal;
in vec3 cameraDirectionOut;

uniform vec3 lightDirection;

uniform vec4 diffuseMaterialColour;
uniform vec4 specularMaterialColour;
uniform float specularPower;

uniform sampler1D toonShade;

void main()
{
	vec3 lightDirectionNormalized=normalize(lightDirection);
	float diffuseTerm = max(dot(worldNormal, lightDirectionNormalized),0.0f);
	vec3 halfWayVec = normalize(cameraDirectionOut + lightDirectionNormalized);
	float specularTerm = pow(max(dot(worldNormal, halfWayVec),0.0f), specularPower);

	vec3 diffuseShade = texture(toonShade, diffuseTerm).rgb;
	vec3 specularShade = texture(toonShade, specularTerm).rgb;

	FragColor = (diffuseMaterialColour*vec4(diffuseShade, 1.0f)) +
		(specularMaterialColour*vec4(specularShade,1.0f));
}