#version 460
uniform sampler2D gtexture;
/* DRAWBUFFERS:0*/
layout(location = 0) out vec4 outColor0;
in vec2 textCoord;
in vec3 foliageColor;
void main(){
    vec4 outputColorData = texture(gtexture,textCoord);
    vec3 outputColor = outputColorData.rgb * foliageColor;
    float transparency = outputColorData.a;
    if(transparency<.1){
        discard;
    }
    outColor0 = vec4(outputColor,transparency);
}