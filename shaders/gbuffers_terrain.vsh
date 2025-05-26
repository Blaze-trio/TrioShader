#version 460
//attributes
in vec3 vaPosition;
in vec2 vaUV0;
in vec4 vaColor; 

uniform vec3 chunkOffset; // offset for chunk position
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse; // model view matrix for the GBuffer
out vec2 textCoord;// the texture coordinate to be passed to the fragment shader
out vec3 foliageColor; 
void main(){
    textCoord = vaUV0;
    foliageColor = vaColor.rgb; // pass the color to the fragment shader
    vec3 worldSpacePosition = cameraPosition + (gbufferModelViewInverse * modelViewMatrix * vec4(vaPosition+chunkOffset,1)).xyz;
    float distanceFromCamera = distance(worldSpacePosition,cameraPosition);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition+chunkOffset-0.2*distanceFromCamera, 1);
}