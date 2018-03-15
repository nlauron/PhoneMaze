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

uniform int fogSelector;
uniform int depthFog;

const vec3 FogDiffuse = vec3(0.15, 0.05, 0.0);
const vec3 RimColor = vec3 (0.2, 0.2, 0.2);

in vec3 world_pos;
in vec3 world_normal;
in vec4 view_space;

const vec3 fogColor = vec3(0.5, 0.5, 0.5);
const float FogDensity = 0.05;

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

in vec3 vPosition;

vec4 spotLight (int _lightNum) {
    float nDotVP;
    float nDotR;
    float pf = 0.0;
    float spotDot;
    float spotAttenuation;
    float attenuation;
    float d;
    vec3 VP;
    vec3 reflection;
    
    VP = vec3(light[_lightNum].position) - vPosition;
    
    d = length(VP);
    
    VP = normalize (VP);
    
    attenuation = 1.f / (light[_lightNum].constantAttenuation + light[_lightNum].linearAttenuation * d + light[_lightNum].quadraticAttenuation * d * d);
    
    spotDot = dot (-VP, normalize (light[_lightNum].direction));
    
    if (spotDot < light[_lightNum].spotCosCutoff) {
        spotAttenuation = 0.f;
    } else {
        float spotValue = smoothstep(light[_lightNum].spotCosCutoff, light[_lightNum].spotCosInnerCutoff, spotDot);
        spotAttenuation = pow(spotValue, light[_lightNum].spotExponent);
    }
    
    attenuation *= spotAttenuation;
    reflection = normalize (reflect(-normalize(VP), normalize(v_normal)));
    
    nDotVP = max (0.f, dot (v_normal, VP));
    nDotR = max (0.f, dot (normalize (v_normal), reflection));
    
    pf = clamp(nDotVP, 0.0, pow(nDotR, material.shininess));
    
    vec4 ambient = material.ambient * light[_lightNum].ambient * attenuation;
    vec4 diffuse = material.diffuse * light[_lightNum].diffuse * nDotVP * attenuation;
    vec4 specular = material.specular * light[_lightNum].specular * pf * attenuation;
    
    return ambient + diffuse + specular;
}

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
        
        float dist = 0.0;
        float fogFactor = 0.0;
        
        if(depthFog == 0) {
            dist = abs(view_space.z);
        } else {
            dist = length(view_space);
        }
        
        if (fogSelector == 0){
            fogFactor = (80.0 - dist) / (80.0 - 20.0);
            fogFactor = clamp(fogFactor, 0.0, 1.0);
        
            finalColor = mix(fogColor, lightColor, fogFactor);
        } else if (fogSelector == 1) {
            fogFactor = 1.0 / exp(dist * FogDensity);
            fogFactor = clamp (fogFactor, 0.0, 1.0);
            
            finalColor = mix( fogColor, lightColor, fogFactor);
        }
        o_fragColor = vec4(finalColor, 1);
        
    }
    
    if (!passThrough && shadeInFrag) {
        vec3 eyeNormal = normalize(normalMatrix * v_normal);
        vec3 lightPosition = vec3(0.0, 1.0, 1.0);
        vec4 diffuseColor =  v_colorDiffuse;
        
        float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
        
        o_fragColor = diffuseColor * nDotVP * texture(texSampler, v_texcoord);
    } else {
        o_fragColor = v_color;
    }

}

