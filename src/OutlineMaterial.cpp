#include "OutlineMaterial.h"
#include "Shader.h"
#include "Texture.h"
OutlineMaterial::OutlineMaterial()
{

}

OutlineMaterial::~OutlineMaterial()
{

}

void OutlineMaterial::update()
{
	lastTicks = currentTicks;
	currentTicks = SDL_GetTicks();
	elapsedTime = (currentTicks - lastTicks) / 1000.0f;
	totalTime += elapsedTime;

	mat4 parentModel(1.0f);
	if (m_ParentGameObject)
	{
		parentModel = m_ParentGameObject->getModelMatrix();
	}
	mat4 translationMatrix = translate(mat4(1.0f), m_Position);
	mat4 scaleMatrix = scale(mat4(1.0f), m_Scale);

	mat4 rotationMatrix = rotate(mat4(1.0f), (m_Rotation.x + totalTime)*m_RotationSpeed.x, vec3(1.0f, 0.0f, 0.0f))*
		rotate(mat4(1.0f), (m_Rotation.y + totalTime)*m_RotationSpeed.y, vec3(0.0f, 1.0f, 0.0f))*
		rotate(mat4(1.0f), (m_Rotation.z + totalTime)*m_RotationSpeed.z, vec3(0.0f, 0.0f, 1.0f));

	m_ModelMatrix = scaleMatrix*translationMatrix*rotationMatrix;
	m_ModelMatrix *= parentModel;

	for (auto iter = m_ChildGameObjects.begin(); iter != m_ChildGameObjects.end(); iter++)
	{
		(*iter)->update();
	}
}

void OutlineMaterial::bind()
{
	Material::bind();
	glEnable(GL_CULL_FACE);
	glCullFace(GL_FRONT);
	glDepthMask(GL_FALSE);
}

void OutlineMaterial::unbind()
{
	Material::unbind();
	glDepthMask(GL_TRUE);
	glDisable(GL_CULL_FACE);
}