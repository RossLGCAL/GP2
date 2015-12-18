#include "GameObject.h"
#include "Shader.h"
#include "Texture.h"

GameObject::GameObject()
{
	m_Mesh=shared_ptr<Mesh>(new Mesh);
	m_Material=shared_ptr<Material>(NULL);

	m_ModelMatrix=mat4(1.0f);
	m_Position=vec3(0.0f);
	m_Rotation=vec3(0.0f);
	m_Scale=vec3(1.0f);


	m_ChildGameObjects.clear();

	m_ParentGameObject = NULL;
	currentTicks = SDL_GetTicks();
	totalTime = 0.0f;
}

GameObject::~GameObject()
{
	m_ChildGameObjects.clear();
}

void GameObject::update()
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
	//Adam
	mat4 rotationMatrix = rotate(mat4(1.0f), (m_Rotation.x+totalTime)*m_RotationSpeed.x, vec3(1.0f, 0.0f, 0.0f))*
		rotate(mat4(1.0f), (m_Rotation.y + totalTime)*m_RotationSpeed.y, vec3(0.0f, 1.0f, 0.0f))*
		rotate(mat4(1.0f), (m_Rotation.z + totalTime)*m_RotationSpeed.z, vec3(0.0f, 0.0f, 1.0f));

	m_ModelMatrix = scaleMatrix*translationMatrix*rotationMatrix;
	m_ModelMatrix *= parentModel;

	for (auto iter = m_ChildGameObjects.begin(); iter != m_ChildGameObjects.end(); iter++)
	{
		(*iter)->update();
	}
}

void GameObject::addChild(shared_ptr<GameObject> child)
{
	child->m_ParentGameObject = this;
	m_ChildGameObjects.push_back(child);
}

void GameObject::createBuffers(Vertex * pVerts, int numVerts, int *pIndices, int numIndices)
{
	m_Mesh=shared_ptr<Mesh>(new Mesh);
	m_Mesh->create(pVerts,numVerts,pIndices,numIndices);
}

void GameObject::loadShader(const string& vsFilename, const string& fsFilename)
{
	m_Material=shared_ptr<Material>(new Material);
	m_Material->loadShader(vsFilename,fsFilename);
}

void GameObject::loadDiffuseMap(const string& filename)
{
	m_Material->loadDiffuseMap(filename);
}
