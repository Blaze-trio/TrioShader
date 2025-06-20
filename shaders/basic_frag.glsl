#version 460

//uniforms
uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D normals;
uniform sampler2D specular;

//martix
uniform mat4 gbufferModelViewInverse;
uniform mat4 modelViewMatrixInverse;

//values
uniform float far;
uniform float dhNearPlane;
uniform vec3 shadowLightPosition;
uniform vec3 cameraPosition;

//vertex to fragment
in vec2 textCoord;
in vec3 foliageColor;
in vec2 lightMapCoords;
in vec3 geoNormal;
in vec3 viewSpacePosition;
in vec4 tangent;

/* DRAWBUFFERS:0*/
layout(location = 0) out vec4 outColor0;

//funcions
mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
    vec3 bitangent = cross(tangent,normal);
    return mat3(tangent, bitangent, normal);
}

void main(){
    //color
    vec4 outputColorData = texture(gtexture,textCoord);
    vec3 outputColor = pow(outputColorData.rgb ,vec3(2.2))* pow(foliageColor,vec3(2.2));
    float transparency = outputColorData.a;
    if(transparency<.1){
        discard;
    }

    //lighting
    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
    vec3 worldGeoNormal = mat3(gbufferModelViewInverse) * geoNormal;
    vec3 worldTangent = mat3(gbufferModelViewInverse) * tangent.rgb;
    vec4 normalData = texture(normals, textCoord)*2.0-1.0;
    vec3 normalNormalSpace = vec3(normalData.xy,sqrt(1.0 - dot(normalData.xy, normalData.xy)));
    mat3 TBN = tbnNormalTangent(worldGeoNormal,worldTangent);
    vec3 normalWorldSpace = TBN * normalNormalSpace;
    vec4 specularData = texture(specular, textCoord);
    float perceptualSmoothness = specularData.r;
    float roughness = pow(1.0 - perceptualSmoothness, 2.0);
    float smoothness = 1 - roughness;
    vec3 reflectionDirection = reflect(-shadowLightDirection, normalWorldSpace);
    vec3 fragFeetPlayerSpace = (gbufferModelViewInverse * vec4(viewSpacePosition, 1.0)).xyz;
    vec3 fragWorldSpace = fragFeetPlayerSpace + cameraPosition;

    vec3 viewDirection = normalize(cameraPosition - fragWorldSpace);
    float diffusedlight = roughness * clamp(dot(shadowLightDirection,normalWorldSpace), 0, 1.0);
    float shininess = (1+(smoothness) *100);
    float specularLight =  clamp(smoothness * pow(dot(reflectionDirection,viewDirection),shininess), 0, 1.0);
    float ambientLight = .2;
    float lightBrightness = diffusedlight + specularLight + ambientLight;

    vec3 lightColor = pow(texture(lightmap, lightMapCoords).rgb,vec3(2.2));


    outputColor *= lightBrightness * lightColor;

    //dh blending
    float distanceFromCamera = distance(viewSpacePosition,vec3(0));
    float dhBlend = smoothstep(far -0.5*far,far,distanceFromCamera);
    transparency = mix(0.0,transparency,pow((1-dhBlend),0.6));
    
    outColor0 = vec4(pow(outputColor,vec3(1/2.2)),transparency);
}