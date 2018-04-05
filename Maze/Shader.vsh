#version 300 es

layout(location = 0) in vec4 position;
layout(location = 1) in vec4 color;
layout(location = 2) in vec3 normal;
layout(location = 3) in vec2 texCoordIn;
layout(location = 4) in vec4 colorDiffuse;
out vec4 v_color;
out vec3 v_normal;
out vec2 v_texcoord;
out vec4 v_colorDiffuse;

out vec3 world_pos;
out vec3 world_normal;
out vec4 view_space;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform bool passThrough;
uniform bool shadeInFrag;
uniform bool foggy;
uniform bool spotLight;
uniform bool Normalize;
uniform vec3 viewerPos;

out vec3 eyeDirection;
out vec3 eyeCord3;
struct Materials
{
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    float shininess;
};


struct Lights
{
    vec4 position;
    vec3 direction;
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    float spotCosCutoff;
    float spotCosInnerCutoff;
    float spotExponent;
    float constantAttenuation;
    float linearAttenuation;
    float quadraticAttenuation;
};

uniform Materials material;
#define numLights 8
uniform Lights light[numLights];
out vec3 vPosition;
uniform mat4 MV;
uniform mat4 MVP;

void main()
{
    if (spotLight) {
    v_normal = (normalMatrix * normal);
    if (Normalize == true)
    {
        v_normal = normalize(normal);
    }
    
    vec4 vertexPos = MV * vec4(position);
    vec3 vertexEyePos = vertexPos.xyz / vertexPos.w;
    
    vPosition = vertexEyePos;
    gl_Position = MVP*vec4(position);
    }
    if (foggy) {
        world_pos = (modelViewProjectionMatrix * vec4(position)).xyz;
        world_normal = normalize(mat3(normalMatrix)* normal);
        v_texcoord = texCoordIn;
        view_space = modelViewProjectionMatrix * vec4(position);
    }
    if (passThrough)
    {
        // Simple passthrough shader
        v_color = color;
        v_normal = vec3(0, 0, 0);
        v_texcoord = vec2(0, 0);
    } else if (shadeInFrag) {
        v_normal = normal;
        v_texcoord = texCoordIn;
        v_colorDiffuse = colorDiffuse;
    } else {
        // Diffuse shading
        vec3 eyeNormal = normalize(normalMatrix * normal);
        vec3 lightPosition = vec3(0.0, 1000.0, 1000.0);
        vec4 diffuseColor = colorDiffuse;
        
        float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
        
        v_color = diffuseColor * nDotVP;
        v_normal = vec3(0, 0, 0);
        v_texcoord = vec2(0, 0);
        v_colorDiffuse = colorDiffuse;
    }
    
    if (foggy) {
        gl_Position = modelViewProjectionMatrix * view_space;
    } else {
        gl_Position = modelViewProjectionMatrix * position;
    }
}
