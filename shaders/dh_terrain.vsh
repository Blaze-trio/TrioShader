#version 460 compatibility
//attributes

out vec4 blockColor; 
out vec2 lightMapCoords;
out vec3 viewSpaceFragPosition;
void main(){
    blockColor = gl_Color; // pass the color to the fragment shader
    lightMapCoords = (gl_TextureMatrix[1]*gl_MultiTexCoord2).xy; // Explicit cast from uvec2 to ivec2
    viewSpacePosition = (gl_ModelViewMatrix * gl_Vertex).xyz; // Calculate view space position
    gl_Position = ftransform();
}