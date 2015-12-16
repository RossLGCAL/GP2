#ifndef _TEXTURE_H
#define _TEXTURE_H

#include "Common.h"

	GLuint loadTextureFromFile(const string& filename);
	GLuint loadTextureFromFont(const string& fontFilename, int	pointSize, const string& text);
	GLuint loadCubeTexture(const string& filenamePosZ, const string& filenameNegZ, const string& filenamePosX, const string& filenameNegX, const string& filenamePosY, const string& filenameNegY);
	GLuint convertSDLSurfaceToTexture(SDL_Surface * surface);

	void loadCubeMapFace(const string& filename, GLenum face);

#endif
