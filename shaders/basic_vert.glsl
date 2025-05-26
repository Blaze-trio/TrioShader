#version 460
//attributes
in vec3 vaPosition;
in vec2 vaUV0;
in vec4 vaColor; 
in uvec2 vaUV2; // Changed from ivec2 to uvec2

uniform vec3 chunkOffset; // offset for chunk position
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse; // model view matrix for the GBuffer

out vec2 textCoord;// the texture coordinate to be passed to the fragment shader
out vec3 foliageColor; 
out vec2 lightMapCoords;

void main(){
    textCoord = vaUV0;
    foliageColor = vaColor.rgb; // pass the color to the fragment shader
    lightMapCoords = vec2(vaUV2) *(1.0/256.0)+(1.0/32.0); // Explicit cast from uvec2 to ivec2
    vec3 worldSpacePosition = cameraPosition + (gbufferModelViewInverse * modelViewMatrix * vec4(vaPosition+chunkOffset,1)).xyz;
    float distanceFromCamera = distance(worldSpacePosition,cameraPosition);
    
    // Apply curvature by moving vertices downward based on distance
    vec3 curvedPosition = vaPosition + chunkOffset;
    curvedPosition.y -= 0.2 * distanceFromCamera; // Apply downward curvature
    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(curvedPosition, 1);
}