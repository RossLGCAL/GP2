#ifndef _GAMEOBJECT_H
#define _GAMEOBJECT_H

#include "Common.h"
#include "Vertices.h"
#include "Mesh.h"
#include "Material.h"

class GameObject
{
public:
	GameObject();
	~GameObject();

	void update();
	void addChild(shared_ptr<GameObject> child);
	void createBuffers(Vertex * pVerts, int numVerts, int *pIndices, int numIndices);
	void loadShader(const string& vsFilename, const string& fsFilename);
	void loadDiffuseMap(const string& filename);

	void setPosition(const vec3& position)
	{
		m_Position = position;
	};

	void setRotation(const vec3& rotation)
	{
		m_Rotation = rotation;
	};
#
	void setRotationSpeed(const vec3& rotationSpeed)
	{
		m_RotationSpeed=rotationSpeed;
	}

	void setScale(const vec3& scale)
	{
		m_Scale = scale;
	};

	int getNumberOfChildren()
	{
		return m_ChildGameObjects.size();
	};

	GameObject * getParent()
	{
		return m_ParentGameObject;
	};

	shared_ptr<GameObject> getChild(int i)
	{
		return m_ChildGameObjects.at(i);
	};

	GLuint getVertexArrayObject()
	{
		return m_Mesh->getVertexArrayObject();
	};

	GLuint getShaderProgram()
	{
		return m_Material->getShaderProgram();
	};

	mat4& getModelMatrix()
	{
		return m_ModelMatrix;
	};

	vec4& getAmbientMaterial()
	{
		return m_Material->getAmbientMaterial();
	};

	vec4& getDiffuseMaterial()
	{
		return m_Material->getDiffuseMaterial();
	};

	vec4& getSpecularMaterial()
	{
		return m_Material->getSpecularMaterial();
	};

	float getSpecularPower()
	{
		return m_Material->getSpecularPower();
	};

	int getNumberOfIndices()
	{
		return m_Mesh->getNumberOfIndices();
	};

	int getNumberOfVertices()
	{
		return m_Mesh->getNumberOfVertices();
	};

	GLuint getDiffuseMap()
	{
		return m_Material->getDiffuseMap();
	};

	void setMesh(shared_ptr<Mesh> mesh)
	{
		m_Mesh=mesh;
	};

	void setMaterial(shared_ptr<Material> material)
	{
		m_Material=material;
	};

	bool operator < (const GameObject& obj) const
	{
		return (m_Material < obj.m_Material);
	};

	vec3& getPosition()
	{
		return m_Position;
	};

	shared_ptr<Mesh> getMesh()
	{
		return m_Mesh;
	};

	shared_ptr<Material> getMaterial()
	{
		return m_Material;
	};
private:

	shared_ptr<Mesh> m_Mesh;
	shared_ptr<Material> m_Material;

	mat4 m_ModelMatrix;
	vec3 m_Position;
	vec3 m_Rotation;
	vec3 m_Scale;
	vec3 m_RotationSpeed;

	float elapsedTime;
	float totalTime;

	unsigned int lastTicks, currentTicks;

	vector<shared_ptr<GameObject> > m_ChildGameObjects;
	GameObject * m_ParentGameObject;
};

#endif
