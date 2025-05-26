#version 460
uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform mat4 gbufferModelViewInverse;
uniform float far;
uniform float dhNearPlane;
uniform vec3 shadowLightPosition;
/* DRAWBUFFERS:0*/
layout(location = 0) out vec4 outColor0;
in vec2 textCoord;
in vec3 foliageColor;
in vec2 lightMapCoords;
in vec3 geoNormal;
in vec3 viewSpacePosition; // Add this missing input variable

void main(){
    vec3 shadowLightDirection = normalize(shadowLightPosition);
    vec3 worldGeoNormal = mat3(gbufferModelViewInverse) * geoNormal;
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
    outColor0 = vec4(pow(outputColor,vec3(1/2.2)),transparency);
}