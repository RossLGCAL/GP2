#ifndef _MATERIAL_H
#define _MATERIAL_H

#include "Common.h"

class Material
{
public:
  Material();
  ~Material();

  void bind()
  {
	  glUseProgram(m_ShaderProgram);
  };


  virtual void unbind()
  {

  };


  void loadShader(const string& vsFilename, const string& fsFilename);

  void loadDiffuseMap(const string& filename);

  void loadSkyBoxTextures(const string& filenamePosZ, const string& filenameNegZ, const string& filenamePosX,
    const string& filenameNegX, const string& filenamePosY, const string& filenameNegY);

  void loadToonMap(float *pData, int width);

  vec4& getAmbientMaterial()
  {
    return m_AmbientMaterial;
  };

  vec4& getDiffuseMaterial()
  {
    return m_DiffuseMaterial;
  };

  vec4& getSpecularMaterial()
  {
    return m_SpecularMaterial;
  };

  void setAmbientMaterial(const vec4& colour)
  {
    m_AmbientMaterial=colour;
  };

  void setDiffuseMaterial(const vec4& colour)
  {
    m_DiffuseMaterial=colour;
  };

  void setSpecularMaterial(const vec4& colour)
  {
    m_SpecularMaterial=colour;
  };

  float getSpecularPower()
  {
    return m_SpecularPower;
  };

  GLuint getShaderProgram()
  {
    return m_ShaderProgram;
  };

  GLuint getDiffuseMap()
  {
    return m_DiffuseMap;
  };

  GLuint getEnvironmentMap()
  {
    return m_EnvironmentMap;
  };

  GLuint getToonMap()
  {
	  return m_ToonShadeMap;
  };

  void setUniform(const string& name, vec3& v)
  {
	  glUniform3fv(m_UniformLocationMap[name], 1, value_ptr(v));
  };

  void setUniform(const string& name, vec4& v)
  {
	  glUniform4fv(m_UniformLocationMap[name], 1, value_ptr(v));
  };

  void setUniform(const string& name, mat4& m)
  {
	  glUniformMatrix4fv(m_UniformLocationMap[name], 1, GL_FALSE, value_ptr(m));
  };

  void setUniform(const string& name, float f)
  {
	  glUniform1f(m_UniformLocationMap[name], f);
  };

  void setUniform(const string& name, int i)
  {
	  glUniform1i(m_UniformLocationMap[name], i);
  };

  bool operator < (const Material& mat) const
  {
    return (m_ShaderProgram < mat.m_ShaderProgram);
  };
private:
	void setupUniforms();
private:
  GLuint m_ShaderProgram;

  vec4 m_AmbientMaterial;
  vec4 m_DiffuseMaterial;
  vec4 m_SpecularMaterial;
  float m_SpecularPower;

  GLuint m_DiffuseMap;
  GLuint m_EnvironmentMap;
  GLuint m_ToonShadeMap;

  map<string, GLint> m_UniformLocationMap;
};
#endif
