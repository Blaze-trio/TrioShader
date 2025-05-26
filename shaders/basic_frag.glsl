#version 460
uniform sampler2D gtexture;
uniform sampler2D lightmap;
/* DRAWBUFFERS:0*/
layout(location = 0) out vec4 outColor0;
in vec2 textCoord;
in vec3 foliageColor;
in vec2 lightMapCoords;

void main(){
    vec3 lightColor = pow(texture(lightmap, lightMapCoords).rgb,vec3(2.2));
    vec4 outputColorData = pow(texture(gtexture,textCoord),vec4(2.2));
    vec3 outputColor = outputColorData.rgb * pow(foliageColor,vec3(2.2)) * lightColor;
    float transparency = outputColorData.a;
    if(transparency<.1){
        discard;
    }
    outColor0 = pow(vec4(outputColor,transparency),vec4(1/2.2));
}