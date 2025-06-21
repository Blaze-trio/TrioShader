#version 460

//attributes
in vec3 vaPosition;
in vec2 vaUV0;
in vec4 vaColor; 

//uniforms
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

uniform vec3 chunkOffset;

//outputs
out vec2 textCoord;
out vec3 foliageColor; 

void main(){
    textCoord = vaUV0;
    foliageColor = vaColor.rgb;
    vec4 viewSpacePositionVec4 = modelViewMatrix * vec4(vaPosition+chunkOffset, 1.0);
    gl_Position = projectionMatrix * viewSpacePositionVec4;
}