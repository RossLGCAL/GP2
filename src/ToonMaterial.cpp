#include "ToonMaterial.h"

ToonMaterial::ToonMaterial()
{

}

ToonMaterial::~ToonMaterial()
{

}

void ToonMaterial::bind()
{
	glEnable(GL_CULL_FACE);
	//only render back
	glCullFace(GL_BACK);
	glDepthMask(GL_TRUE);
}

void ToonMaterial::unbind()
{
	glDisable(GL_CULL_FACE);
}