#version 120

#define FLOAT float
#define INT   int
#define MAT3  mat3
#define MAT4  mat4
#define VEC2  vec2
#define VEC3  vec3
#define VEC4  vec4
#define SAMPLER2D sampler2D
#define TEXTURE2D texture2D
#define VS_IN(vvv) vvv
#define VS_OUT(vvv) vvv
#define PS_IN(vvv) vvv
#define PS_OUT(vvv) gl_##vvv
#define ATTRIBUTE attribute
#define VARYING varying
#define UNIFORM uniform
#define MIX mix

#define L_DIFFUSE(lig)   lig[0].rgba
#define L_AMBIENT(lig)   lig[1].rgba
#define L_SPECULAR(lig)  lig[2].rgba
#define L_POSITION(lig)  lig[3].xyz
#define L_RADIUS(lig)    lig[3].w

#define PARALAX_SCALE 0.03
#define PARALAX_BIAS -PARALAX_SCALE/2.0

#define FOG_START(fog)    fog.x
#define FOG_END(fog)      fog.y
#define FOG_DENSITY(fog)  fog.z

ATTRIBUTE VEC4 aPosition;
ATTRIBUTE VEC3 aNormal;
ATTRIBUTE VEC2 aTCoord0;
ATTRIBUTE VEC3 aTangent;
ATTRIBUTE VEC3 aBinormal;

UNIFORM MAT4 uModelViewProjMatrix;
UNIFORM MAT4 uModelViewMatrix;
UNIFORM MAT3 uNormalMatrix;
UNIFORM MAT4 uLighting[4];

VARYING VEC4 TexCoord0;
VARYING VEC4 TexCoord1;
VARYING VEC3 EyeVec;
VARYING VEC4 Position;
VARYING VEC4 LightVec0;
VARYING VEC4 LightVec1;
VARYING VEC4 LightVec2;

void main(void)
{
    VEC4 vertex = VS_IN(aPosition);
    VEC4 positionMVP = uModelViewProjMatrix * vertex;

    VEC4 position = uModelViewMatrix * vertex;
    VEC3 eyeVec = -position.xyz;
    VEC3 normal = VS_IN(aNormal);
    normal = uNormalMatrix * normal;

    VEC3 tangent  = VS_IN(aTangent).xyz;
    VEC3 binormal = VS_IN(aBinormal).xyz;
    tangent  = uNormalMatrix * tangent;
    binormal = uNormalMatrix * binormal;
    VS_OUT(EyeVec) = VEC3(
        dot(eyeVec, tangent),
        dot(eyeVec, binormal),
        dot(eyeVec, normal));
    // transforming lights into TBN space
    {
    // Light 0
        VEC3 lPosition = L_POSITION(uLighting[0]);
        VEC3 lightVec = lPosition - position.xyz;
        VS_OUT(LightVec0) = VEC4(
            dot(lightVec, tangent),
            dot(lightVec, binormal),
            dot(lightVec, normal),
            0.0);
    }
    {
    // Light 1
        VEC3 lPosition = L_POSITION(uLighting[1]);
        VEC3 lightVec = lPosition - position.xyz;
        VS_OUT(LightVec1) = VEC4(
            dot(lightVec, tangent),
            dot(lightVec, binormal),
            dot(lightVec, normal),
            0.0);
    }
    {
    // Light 2
        VEC3 lPosition = L_POSITION(uLighting[2]);
        VEC3 lightVec = lPosition - position.xyz;
        VS_OUT(LightVec2) = VEC4(
            dot(lightVec, tangent),
            dot(lightVec, binormal),
            dot(lightVec, normal),
            0.0);
    }
    {
    // Light 3
        VEC3 lPosition = L_POSITION(uLighting[3]);
        VEC3 lightVec = lPosition - position.xyz;
        VS_OUT(LightVec0).w = dot(lightVec, tangent);
        VS_OUT(LightVec1).w = dot(lightVec, binormal);
        VS_OUT(LightVec2).w = dot(lightVec, normal);
    }
    VS_OUT(Position) = position;

    VEC4 tc0 = VEC4(VS_IN(aTCoord0).xy, 1.0, 1.0);
    VS_OUT(TexCoord0) = VEC4(tc0.xy, 0.0, 0.0);

    VEC4 tc3 = tc0;
    VS_OUT(TexCoord1) = VEC4(tc3.xy, 0.0, 0.0);

    gl_Position = positionMVP;
}
