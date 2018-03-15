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

void main()
{
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
        vec3 lightPosition = vec3(0.0, 0.0, 1.0);
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
