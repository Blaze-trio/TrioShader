#version 460 compatibility

uniform mat4 dhProjection;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;

out vec4 blockColor; 
out vec2 lightMapCoords;
out vec3 viewSpacePosition; // Fixed: changed from 'viewSpaceFragPosition'
out vec3 geoNormal;

void main(){
    geoNormal = gl_NormalMatrix * gl_Normal;
    blockColor = gl_Color;
    lightMapCoords = (gl_TextureMatrix[1]*gl_MultiTexCoord1).xy;
    
    // Apply the same curvature effect as regular terrain
    vec3 worldPos = (gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex).xyz + cameraPosition;
    float distanceFromCamera = distance(worldPos, cameraPosition);
    
    // Apply curvature
    vec4 curvedVertex = gl_Vertex;
    curvedVertex.y -= 0.2 * distanceFromCamera; // Same curvature as regular terrain
    
    viewSpacePosition = (gl_ModelViewMatrix * curvedVertex).xyz;
    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * curvedVertex;
}