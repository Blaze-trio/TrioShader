#version 460
uniform sampler2D gtexture;
uniform sampler2D lightmap;
/* DRAWBUFFERS:0*/
layout(location = 0) out vec4 outColor0;
in vec2 textCoord;
in vec3 foliageColor;
flat in ivec2 lightMapCoords;

void main(){
    vec3 lightColor = texture(lightmap, vec2(lightMapCoords) / 256.0).rgb;
    vec4 outputColorData = texture(gtexture,textCoord);
    vec3 outputColor = outputColorData.rgb * foliageColor * lightColor;
    float transparency = outputColorData.a;
    if(transparency<.1){
        discard;
    }
    outColor0 = vec4(outputColor,transparency);
}