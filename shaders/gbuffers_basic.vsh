#version 460

in vec3 vaPosition;
in vec2 vaUV0;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
out vec2 textCoord;// the texture coordinate to be passed to the fragment shader
void main(){
    textCoord = vaUV0;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition, 1);
}