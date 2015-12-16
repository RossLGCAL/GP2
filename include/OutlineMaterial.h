#ifndef _OUTLINEMATERIAL_H
#define _OUTLINEMATERIAL_H

#include "Material.h"
#include "Common.h"
#include "Vertices.h"
#include "Mesh.h"
class OutlineMaterial :public Material
{
public:
	OutlineMaterial();
	~OutlineMaterial();
	void update();
	void bind();
	void unbind();

	mat4& getModelMatrix()
	{
		return m_ModelMatrix;
	};
	

private:
	mat4 m_ModelMatrix;
	vec3 m_Position;
	vec3 m_Rotation;
	vec3 m_Scale;
	vec3 m_RotationSpeed;

	float elapsedTime;
	float totalTime;

	unsigned int lastTicks, currentTicks;

	vector<shared_ptr<OutlineMaterial> > m_ChildGameObjects;
	OutlineMaterial * m_ParentGameObject;
};
#endif