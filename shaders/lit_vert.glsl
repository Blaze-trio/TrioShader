#version 460

//attributes
in vec3 vaPosition;
in vec2 vaUV0;
in vec4 vaColor; 
in uvec2 vaUV2;
in vec3 vaNormal;
in vec4 at_tangent;

//uniforms
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 gbufferModelViewInverse;
uniform mat3 normalMatrix;
uniform vec3 chunkOffset;
uniform vec3 cameraPosition;

//outputs
out vec2 textCoord;
out vec3 foliageColor; 
out vec2 lightMapCoords;
out vec3 geoNormal;
out vec3 viewSpacePosition;
out vec4 tangent;

void main(){
    tangent = vec4(normalize(normalMatrix * at_tangent.rgb), at_tangent.a);
    geoNormal = vaNormal * normalMatrix;
    textCoord = vaUV0;
    foliageColor = vaColor.rgb;
    lightMapCoords = vec2(vaUV2) * (1.0/256.0) + (1.0/32.0);
    
    vec3 worldSpacePosition = cameraPosition + (gbufferModelViewInverse * modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0)).xyz;
    float distanceFromCamera = distance(worldSpacePosition, cameraPosition);
    
    // // Apply curvature by moving vertices downward based on distance
    // vec3 curvedPosition = vaPosition + chunkOffset;
    // curvedPosition.y -= 0 * distanceFromCamera;
    
    vec4 viewSpacePositionVec4 = modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0);
    viewSpacePosition = viewSpacePositionVec4.xyz;
    gl_Position = projectionMatrix * viewSpacePositionVec4;
}