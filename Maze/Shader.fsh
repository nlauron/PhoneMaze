#version 300 es

precision highp float;
in vec4 v_color;
in vec3 v_normal;
in vec2 v_texcoord;
in vec4 v_colorDiffuse;
out vec4 o_fragColor;

uniform sampler2D texSampler;

uniform mat3 normalMatrix;
uniform bool passThrough;
uniform bool shadeInFrag;
uniform bool foggy;

uniform vec3 light_pos;
uniform vec3 eye_pos;
uniform sampler2D texture1;

uniform int depthFog;

const vec3 FogDiffuse = vec3(0.15, 0.05, 0.0);
const vec3 RimColor = vec3 (0.2, 0.2, 0.2);

in vec3 world_pos;
in vec3 world_normal;
in vec4 viewSpace;

const vec3 fogColor = vec3(0.5, 0.5, 0.5);
const float FogDensity = 0.05;

void main()
{
    if (foggy) {
        vec3 tex1 = texture(texture1, v_texcoord).rgb;
        
        vec3 L = normalize (light_pos - world_pos);
        vec3 V = normalize (eye_pos - world_pos);
        
        vec3 diffuse = FogDiffuse * max(0.0, dot(L, world_normal));
        
        float rim = 1.0 - max(dot(V, world_normal), 0.0);
        rim = smoothstep(0.6, 1.0, rim);
        vec3 finalRim = RimColor * vec3 (rim,  rim, rim);
        
        vec3 lightColor = finalRim + diffuse + tex1;
        vec3 finalColor = vec3(0,0,0);
        
        float dist = 0;
        float fogFactor = 0;
        
        if(depthFog == 0) {
            dist = abs(viewSpace.z);
        } else {
            dist = length(viewSpace);
        }
        
        fogFactor = (80 - dist) / (80 - 20);
        fogFactor = clamp(fogFactor, 0.0, 1.0);
        
        finalColor = mix(fogColor, lightColor, fogFactor);
        
        out_color = vec(finalColor, 1);
        
    }
    if (!passThrough && shadeInFrag) {
        vec3 eyeNormal = normalize(normalMatrix * v_normal);
        vec3 lightPosition = vec3(0.0, 0.0, 1.0);
        vec4 diffuseColor =  v_colorDiffuse;
        
        float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
        
        o_fragColor = diffuseColor * nDotVP * texture(texSampler, v_texcoord);
    } else {
        o_fragColor = v_color;
    }
}

