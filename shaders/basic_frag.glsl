#version 460
uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform mat4 gbufferModelViewInverse;
uniform mat4 modelViewMatrixInverse;
uniform sampler2D normals;
uniform float far;
uniform float dhNearPlane;
uniform vec3 shadowLightPosition;
/* DRAWBUFFERS:0*/
layout(location = 0) out vec4 outColor0;
in vec2 textCoord;
in vec3 foliageColor;
in vec2 lightMapCoords;
in vec3 geoNormal;
in vec3 viewSpacePosition;
in vec4 tangent;

mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
    vec3 bitangent = cross(tangent,normal);
    return mat3(tangent, bitangent, normal);
}

void main(){
    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
    vec3 worldGeoNormal = mat3(gbufferModelViewInverse) * geoNormal;
    vec3 worldTangent = mat3(gbufferModelViewInverse) * tangent.rgb;
    vec4 normalData = texture(normals, textCoord)*2.0-1.0;
    vec3 normalNormalSpace = vec3(normalData.xy,sqrt(1.0 - dot(normalData.xy, normalData.xy)));
    mat3 TBN = tbnNormalTangent(worldGeoNormal,worldTangent);
    vec3 normalWorldSpace = TBN * normalNormalSpace;
    
    
    float lightBrightness = clamp(dot(shadowLightDirection,normalWorldSpace), 0.2, 1.0);
    vec3 lightColor = pow(texture(lightmap, lightMapCoords).rgb,vec3(2.2));
    vec4 outputColorData = pow(texture(gtexture,textCoord),vec4(2.2));
    vec3 outputColor = outputColorData.rgb * pow(foliageColor,vec3(2.2)) * lightColor;
    float transparency = outputColorData.a;
    if(transparency<.1){
        discard;
    }
    float distanceFromCamera = distance(viewSpacePosition,vec3(0));
    float dhBlend = smoothstep(far -0.5*far,far,distanceFromCamera);
    transparency = mix(0.0,transparency,pow((1-dhBlend),0.6));
    outputColor *= lightBrightness;
    outColor0 = vec4(pow(outputColor,vec3(1/2.2)),transparency);
}