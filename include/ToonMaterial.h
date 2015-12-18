#ifndef _TOONMATERIAL_H
#define _TOONMATERIAL_H

#include "Material.h"

class ToonMaterial :public Material
{
public:
	ToonMaterial();
	~ToonMaterial();

	void bind();
	void unbind();
private:

};
#endif