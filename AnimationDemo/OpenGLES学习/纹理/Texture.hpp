//
//  Texture.hpp
//  AnimationDemo
//
//  Created by lieon on 2021/1/23.
//  Copyright © 2021 lieon. All rights reserved.
//

#ifndef Texture_hpp
#define Texture_hpp
#include "esUtil.h"
#include <stdio.h>


typedef struct {
    // Handle to a program object
    GLuint programObject;

    // Sampler location
    GLint samplerLoc;

    // Offset location
    GLint offsetLoc;

    // Texture handle
    GLuint textureId;
    
    // Vertex data
    int      numIndices;
    GLfloat *vertices;
    GLfloat *normals;
    GLuint  *indices;
    
    // Sampler locations
    GLint baseMapLoc;
    GLint lightMapLoc;

    // Texture handle
    GLuint baseMapTexId;
    GLuint lightMapTexId;
    
    // Handle to a framebuffer object
    GLuint fbo;

    // Texture handle
    GLuint colorTexId[4];

    // Texture size
    GLsizei textureWidth;
    GLsizei textureHeight;
} UserData;

class MipMap2D {
    int init(ESContext *esContext) {
        UserData *userData = (UserData*)esContext->userData;
        char VShaderStr[] =
        "#version 300 es                            \n"
        "uniform float u_offset \n"
        "layout(location = 0) in vec4 a_position;   \n"
        "layout(location = 1) in vec2 a_texCoord;   \n"
        "out vec2 v_texCoord;                       \n"
        "void main()                                \n"
        "{                                          \n"
        "   gl_position = a_position;               \n"
        "   glo_position.x += u_offset;             \n"
        "   v_texCoord = a_texCoord;                \n"
        "}                                          \n"
        ;
        char fsShaderStr[] =
        "#version 300 es                            \n"
        "precision mediump float;                   \n"
        "in vec2  v_texCoord;                       \n"
        "layout(location = 0) out vec4 outColor;    \n"
        "uniform sampler2D s_texture;               \n"
        "void main()                                \n"
        "{                                          \n"
        " outColor = texture(s_texture, v_texCoord) \n"
        "}                                          \n"
        ;
        // load the shader and get a linked program object
        userData->programObject = esLoadProgram(VShaderStr, fsShaderStr);
        
        // get the sampler location
        userData->samplerLoc = glGetUniformLocation(userData->programObject, "s_texture");
        // get the offset location
        userData->offsetLoc = glGetUniformLocation(userData->programObject, "u_offset");
        // load the texture
        userData->textureId = createMipMappedTexture2D();
        glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
        return 1;
    }
    
    // create mipmapped 2D texure image
    GLuint createMipMappedTexture2D() {
        GLuint textureId;
        int width = 256;
        int height = 256;
        int level;
        GLubyte *pixels = nullptr;
        GLubyte *prevImage = nullptr;
        GLubyte *newImage = nullptr;
        pixels = genCheckImage(width, height, 8);
        if (pixels == nullptr) {
            return 0;
        }
        // Generate a texture object
        glGenTextures(1, &textureId);
        // bind the texture object
        glBindTexture(GL_TEXTURE_2D, textureId);
        // load mipmap level 0
        glTexImage2D(GL_TEXTURE_2D,
                     0,
                     GL_RGB,
                     width,
                     height,
                     0,
                     GL_RGB,
                     GL_UNSIGNED_BYTE,
                     pixels);
        level = 1;
        prevImage = &pixels[0];
        while (width > 1 && height > 1) {
            int newWidth;
            int newHeight;
            // Generate the next mipmap level
            genMipMap2D(prevImage, &newImage, width, height, &newWidth, &newHeight);
            // load the mipmap level
            glTexImage2D ( GL_TEXTURE_2D, level, GL_RGB,
                           newWidth, newHeight, 0, GL_RGB,
                           GL_UNSIGNED_BYTE, newImage );
            free(prevImage);
            prevImage = newImage;
            level++;
            width = newWidth;
            height = newHeight;
        }
        if (newImage != nullptr) {
            free(newImage);
        }
        // set the filtering mode
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST);
        glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
        return textureId;
    }
    
    GLubyte *genCheckImage ( int width, int height, int checkSize ) {
        int x, y;
        GLubyte *pixels = (GLubyte*)malloc(width * height * 3);
        if (pixels == nullptr) {
            return nullptr;
        }
        for (y = 0; y < height; y++) {
            for (x = 0; x < width; x++) {
                GLubyte rColor = 0;
                GLubyte bColor = 0;
                if ((x / checkSize) % 2 == 0) {
                    rColor = 255 * ((y / checkSize) % 2);
                    bColor = 255 * (1 - (y / checkSize) % 2);
                } else {
                    bColor = 255 * ((y / checkSize) % 2);
                    rColor = 255 * (1 - (y / checkSize) % 2);
                }
                pixels[(y * width + x) * 3] = rColor;
                pixels[(y * width + x) * 3 + 1] = 0;
                pixels[(y * width + x) * 3 + 2] = bColor;
            }
        }
        return nullptr;
    }
    
    GLboolean genMipMap2D(GLubyte *src, GLubyte **dst, int scrcWidth, int scrHeight, int *destWidth, int *dstHeight) {
        int x, y;
        int texelSize = 3;
        *destWidth = scrcWidth / 2;
        if (*destWidth <= 0) {
            *destWidth = 1;
        }
        *dstHeight = scrHeight / 2;
        if (*dstHeight <= 0) {
            *dstHeight = 1;
        }
        *dst = (GLubyte*)malloc(sizeof(GLubyte) * texelSize * (*destWidth) * (*dstHeight));
        if (*dst == nullptr) {
            return GL_FALSE;
        }
        for (y = 0; y < *dstHeight; y++) {
            for (x = 0; x < *destWidth; x++) {
                int scrcIndex[4];
                float r = 0.0f,
                      g = 0.0f,
                      b = 0.0f;
                int sample;
                //Compute the offset for 2 x 2 grid of pixels in preivious
                // image to perform box filter
                scrcIndex[0] = (((y * 2) * scrcWidth) + (x * 2)) * texelSize;
                scrcIndex[1] = (((y * 2) * scrcWidth) + (x * 2 + 1)) * texelSize;
                scrcIndex[2] = ((((y * 2) + 1) * scrcWidth) + (x * 2)) * texelSize;
                scrcIndex[2] = ((((y * 2) + 1) * scrcWidth) + (x * 2 + 1)) * texelSize;
                
                // sum all pixels
                for (sample = 0; sample < 4; sample++) {
                    r += src[scrcIndex[sample]];
                    g += src[scrcIndex[sample + 1]];
                    b += src[scrcIndex[sample + 2]];
                }
                r /= 4.0;
                g /= 4.0;
                b /= 4.0;
                
                // store resulting pixels
                (*dst)[(y * (*destWidth) + x) * texelSize] = ( GLubyte ) ( r );
                ( *dst ) [ ( y * ( *destWidth ) + x ) * texelSize + 1] = ( GLubyte ) ( g );
                ( *dst ) [ ( y * ( *destWidth ) + x ) * texelSize + 2] = ( GLubyte ) ( b );
            }
        }
        return GL_TRUE;
    }
    
    void draw(ESContext *esContext) {
        UserData *userData = (UserData*)esContext->userData;
        GLfloat vVertices[] = { -0.5f,  0.5f, 0.0f, 1.5f,  // Position 0
            0.0f,  0.0f,              // TexCoord 0
           -0.5f, -0.5f, 0.0f, 0.75f, // Position 1
            0.0f,  1.0f,              // TexCoord 1
            0.5f, -0.5f, 0.0f, 0.75f, // Position 2
            1.0f,  1.0f,              // TexCoord 2
            0.5f,  0.5f, 0.0f, 1.5f,  // Position 3
            1.0f,  0.0f               // TexCoord 3
         };
        GLushort indices[] = { 0, 1, 2, 0, 2, 3 };
        glViewport(0, 0, esContext->width, esContext->height);
        glClear(GL_COLOR_BUFFER_BIT);
        glUseProgram(userData->programObject);
        // Load the vertex position
        glVertexAttribPointer ( 0, 4, GL_FLOAT,
                                GL_FALSE, 6 * sizeof ( GLfloat ), vVertices );
        glVertexAttribPointer ( 1, 2, GL_FLOAT,
                                GL_FALSE, 6 * sizeof ( GLfloat ), &vVertices[4] );
        glEnableVertexAttribArray ( 0 );
        glEnableVertexAttribArray ( 1 );
        // Bind the texture
        glActiveTexture ( GL_TEXTURE0 );
        glBindTexture ( GL_TEXTURE_2D, userData->textureId );
        // Set the sampler texture unit to 0
        glUniform1i ( userData->samplerLoc, 0 );
        // Draw quad with nearest sampling
        glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
        glUniform1f ( userData->offsetLoc, -0.6f );
        glDrawElements ( GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, indices );
        // Draw quad with trilinear filtering
        glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );
        glUniform1f ( userData->offsetLoc, 0.6f );
        glDrawElements ( GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, indices );

    }
    
    void shutDown(ESContext *esContext) {
        
    }
};

class SimpleTexture2D {
public:
    int init(ESContext *escontext) {
        UserData *userData = (UserData*)escontext->userData;
        char vShaderStr[] =
           "#version 300 es                            \n"
           "layout(location = 0) in vec4 a_position;   \n"
           "layout(location = 1) in vec2 a_texCoord;   \n"
           "out vec2 v_texCoord;                       \n"
           "void main()                                \n"
           "{                                          \n"
           "   gl_Position = a_position;               \n"
        "   v_texCoord = a_texCoord;                \n"
        "}\n";
        
        char fShaderStr[] =
           "#version 300 es                                     \n"
           "precision mediump float;                            \n"
           "in vec2 v_texCoord;                                 \n"
           "layout(location = 0) out vec4 outColor;             \n"
           "uniform sampler2D s_texture;                        \n"
           "void main()                                         \n"
           "{                                                   \n"
           "  outColor = texture( s_texture, v_texCoord );      \n"
        "} \n";
        
        userData->programObject = esLoadProgram(vShaderStr, fShaderStr);
        userData->samplerLoc = glGetUniformLocation(userData->programObject, "s_texture");
        userData->textureId = createSimpleTexture2D();
        glClearColor ( 1.0f, 1.0f, 1.0f, 0.0f );
        return GL_TRUE;
    }
    
    GLuint createSimpleTexture2D() {
        GLuint textureId;
        GLubyte pixels[4 * 3] =
        {
            255, 0, 0,
            0, 255, 0,
            0, 0, 255,
            255, 255, 0
        };
        // Use tightly packed data
        glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
        // 生成纹理对象
        glGenTextures(1, &textureId);
        // 绑定纹理对象
        glBindTexture(GL_TEXTURE_2D, textureId);
        // 加载纹理
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 2, 2, 0, GL_RGB, GL_UNSIGNED_BYTE, pixels);
        // 设置过滤模式
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        return textureId;
    }
    
    void draw(ESContext *esContext) {
        UserData *userData = (UserData*)esContext->userData;
        GLfloat vVertices[] = {
            -0.5f, 0.5f, 0.0f,
            0.0, 0.0f,
            -0.5, -0.5f, 0.0f,
            0.0, 1.0f,
            0.5f, -0.5f, 0.0f,
            1.0f, 1.0f,
            0.5f, 0.5f, 0.0f,
            1.0f, 0.0f
        };
        GLushort indeices[] = {0, 1, 2, 0, 2, 3 };
        glViewport(0, 0, esContext->width, esContext->height);
        glClear(GL_COLOR_BUFFER_BIT);
        glUseProgram(userData->programObject);
        // 加载顶点坐标
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), vVertices);
        // 加载纹理坐标
        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), &vVertices[3]);
        glEnableVertexAttribArray(0);
        glEnableVertexAttribArray(1);
        
        // 绑定纹理
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, userData->textureId);
        // 采样器设置为使用纹理单元0 一个纹理的位置值通常称为一个纹理单元(Texture Unit)。一个纹理的默认纹理单元是0，它是默认的激活纹理单元，
        glUniform1f(userData->samplerLoc, 0);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, indeices);
    }
    
};


class SimpleTextureCubemap {
public:
    GLuint createSimpleTextureCubeMap() {
        GLuint textureId;
        GLubyte cubePixels[6][3] =
        {
            // Face 0 - Red
            255, 0, 0,
            // Face 1 - Green,
            0, 255, 0,
            // Face 2 - Blue
            0, 0, 255,
            // Face 3 - Yellow
            255, 255, 0,
            // Face 4 - Purple
            255, 0, 255,
            // Face 5 - White
            255, 255, 255
        };
        // 生成纹理对象
        glGenTextures(1, &textureId);
        // 绑定纹理对象
        glBindTexture(GL_TEXTURE_CUBE_MAP, textureId);
        // Load the cube face - Positive X
        glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, GL_RGB, 1, 1, 0, GL_RGB, GL_UNSIGNED_BYTE, &cubePixels[0]);
        // Load the cube face - Negative X
        glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X, 0, GL_RGB, 1, 1, 0, GL_RGB, GL_UNSIGNED_BYTE, &cubePixels[1]);
        // Load the cube face - Positive Y
        glTexImage2D ( GL_TEXTURE_CUBE_MAP_POSITIVE_Y, 0, GL_RGB, 1, 1, 0,
                       GL_RGB, GL_UNSIGNED_BYTE, &cubePixels[2] );
        // Load the cube face - Negative Y
        glTexImage2D ( GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, GL_RGB, 1, 1, 0,
                       GL_RGB, GL_UNSIGNED_BYTE, &cubePixels[3] );
        // Load the cube face - Positive Z
        glTexImage2D ( GL_TEXTURE_CUBE_MAP_POSITIVE_Z, 0, GL_RGB, 1, 1, 0,
                       GL_RGB, GL_UNSIGNED_BYTE, &cubePixels[4] );
        // Load the cube face - Negative Z
        glTexImage2D ( GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, GL_RGB, 1, 1, 0,
                       GL_RGB, GL_UNSIGNED_BYTE, &cubePixels[5] );
        // Set the filtering mode
        glTexParameteri ( GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
        glTexParameteri ( GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
        return 1;
    }
    
    int init(ESContext *esContext) {
        UserData *userData = (UserData*)esContext->userData;
        char vShaderStr[] =
           "#version 300 es                            \n"
           "layout(location = 0) in vec4 a_position;   \n"
           "layout(location = 1) in vec3 a_normal;     \n"
           "out vec3 v_normal;                         \n"
           "void main()                                \n"
           "{                                          \n"
           "   gl_Position = a_position;               \n"
           "   v_normal = a_normal;                    \n"
           "}                                          \n";

        char fShaderStr[] =
           "#version 300 es                                     \n"
           "precision mediump float;                            \n"
           "in vec3 v_normal;                                   \n"
           "layout(location = 0) out vec4 outColor;             \n"
           "uniform samplerCube s_texture;                      \n"
           "void main()                                         \n"
           "{                                                   \n"
           "   outColor = texture( s_texture, v_normal );       \n"
           "}                                                   \n";
        // Load the shaders and get a linked program object
        userData->programObject = esLoadProgram ( vShaderStr, fShaderStr );

        // Get the sampler locations
        userData->samplerLoc = glGetUniformLocation ( userData->programObject, "s_texture" );

        // Load the texture
        userData->textureId = createSimpleTextureCubeMap();

        // Generate the vertex data
        userData->numIndices = esGenSphere ( 20, 0.75f, &userData->vertices, &userData->normals,
                                             NULL, &userData->indices );
        glClearColor ( 1.0f, 1.0f, 1.0f, 0.0f );
        return  GL_TRUE;
    }
    
    void draw(ESContext *esContext) {
        UserData *userData = (UserData*)esContext->userData;
        glViewport(0, 0, esContext->width, esContext->height);
        glClear(GL_COLOR_BUFFER_BIT);
        glCullFace(GL_BACK);
        glEnable(GL_CULL_FACE);
        glUseProgram(userData->programObject);
        glVertexAttribPointer(0, 3, GL_FLOAT,
                              GL_FALSE,
                              0,
                              userData->vertices);
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, userData->normals);
        glEnableVertexAttribArray ( 0 );
        glEnableVertexAttribArray ( 1 );

        // Bind the texture
        glActiveTexture ( GL_TEXTURE0 );
        glBindTexture ( GL_TEXTURE_CUBE_MAP, userData->textureId );

        // Set the sampler texture unit to 0
        glUniform1i ( userData->samplerLoc, 0 );

        glDrawElements ( GL_TRIANGLES, userData->numIndices,
                         GL_UNSIGNED_INT, userData->indices );
    }
};

class MultiTexture {
public:
    GLuint loadTexture(void *ioContext, char *fileName) {
        int width, height;
        char *buffer = esLoadTGA(ioContext, fileName, &width, &height);
        GLuint texId;
        
        glGenTextures(1, &texId);
        glBindTexture(GL_TEXTURE_2D, texId);

        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, buffer);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        free(buffer);
        return texId;
    }
    
    
    int init ( ESContext *esContext ) {
        UserData *userData = (UserData*)esContext->userData;
        char vShaderStr[] =
        "#version 300 es                            \n"
        "layout(location = 0) in vec4 a_position;   \n"
        "layout(location = 1) in vec2 a_texCoord;   \n"
        "out vec2 v_texCoord;                       \n"
        "void main()                                \n"
        "{                                          \n"
        "   gl_Position = a_position;               \n"
        "   v_texCoord = a_texCoord;                \n"
        "}                                          \n";
        
        char fShaderStr[] =
        "#version 300 es                                     \n"
        "precision mediump float;                            \n"
        "in vec2 v_texCoord;                                 \n"
        "layout(location = 0) out vec4 outColor;             \n"
        "uniform sampler2D s_baseMap;                        \n"
        "uniform sampler2D s_lightMap;                       \n"
        "void main()                                         \n"
        "{                                                   \n"
        "  vec4 baseColor;                                   \n"
        "  vec4 lightColor;                                  \n"
        "                                                    \n"
        "  baseColor = texture( s_baseMap, v_texCoord );     \n"
        "  lightColor = texture( s_lightMap, v_texCoord );   \n"
        "  outColor = baseColor * (lightColor + 0.25);       \n"
        "}                                                   \n";
        userData->programObject = esLoadProgram(vShaderStr, fShaderStr);
        userData->baseMapLoc = glGetUniformLocation ( userData->programObject, "s_baseMap" );
        userData->lightMapLoc = glGetUniformLocation ( userData->programObject, "s_lightMap" );
        // Load the textures
        userData->baseMapTexId = loadTexture ( esContext->platformData, (char*)"basemap.tga" );
        userData->lightMapTexId = loadTexture ( esContext->platformData, (char*)"lightmap.tga" );
        if ( userData->baseMapTexId == 0 || userData->lightMapTexId == 0 ) {
           return FALSE;
        }
        glClearColor ( 1.0f, 1.0f, 1.0f, 0.0f );
        return true;
    }
    
    int draw(ESContext *esContext) {
        UserData *userData = (UserData*)esContext->userData;
        GLfloat vVertices[] = { -0.5f,  0.5f, 0.0f,  // Position 0
                                 0.0f,  0.0f,        // TexCoord 0
                                -0.5f, -0.5f, 0.0f,  // Position 1
                                 0.0f,  1.0f,        // TexCoord 1
                                 0.5f, -0.5f, 0.0f,  // Position 2
                                 1.0f,  1.0f,        // TexCoord 2
                                 0.5f,  0.5f, 0.0f,  // Position 3
                                 1.0f,  0.0f         // TexCoord 3
                              };
        GLushort indices[] = { 0, 1, 2, 0, 2, 3 };
        // Set the viewport
        glViewport ( 0, 0, esContext->width, esContext->height );

        // Clear the color buffer
        glClear ( GL_COLOR_BUFFER_BIT );

        // Use the program object
        glUseProgram ( userData->programObject );

        // Load the vertex position
        glVertexAttribPointer ( 0, 3, GL_FLOAT,
                                GL_FALSE, 5 * sizeof ( GLfloat ), vVertices );
        // Load the texture coordinate
        glVertexAttribPointer ( 1, 2, GL_FLOAT,
                                GL_FALSE, 5 * sizeof ( GLfloat ), &vVertices[3] );

        glEnableVertexAttribArray ( 0 );
        glEnableVertexAttribArray ( 1 );
        
        glActiveTexture ( GL_TEXTURE0 );
        glBindTexture ( GL_TEXTURE_2D, userData->baseMapTexId );

        // 绑定纹理单元
        // Set the base map sampler to texture unit to 0
        glUniform1i ( userData->baseMapLoc, 0 );

        // Bind the light map
        glActiveTexture ( GL_TEXTURE1 );
        glBindTexture ( GL_TEXTURE_2D, userData->lightMapTexId );
        glUniform1i ( userData->lightMapLoc, 1 );

        glDrawElements ( GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, indices );
        return true;
    }
};

class MRTs {
public:
    int init(ESContext *esContext) {
        UserData *userData = (UserData*)esContext->userData;
        char vShaderStr[] =
        "#version 300 es                            \n"
        "layout(location = 0) in vec4 a_position;   \n"
        "void main()                                \n"
        "{                                          \n"
        "   gl_Position = a_position;               \n"
        "}                                          \n";
        char fShaderStr[] =
        "#version 300 es                                     \n"
        "precision mediump float;                            \n"
        "layout(location = 0) out vec4 fragData0;            \n"
        "layout(location = 1) out vec4 fragData1;            \n"
        "layout(location = 2) out vec4 fragData2;            \n"
        "layout(location = 3) out vec4 fragData3;            \n"
        "void main()                                         \n"
        "{                                                   \n"
        " fragData0 = vec4(1, 0, 0, 1);                      \n"
        "                                                    \n"
        "  // second buffer will contain green color         \n"
        "  fragData1 = vec4 ( 0, 1, 0, 1 );                  \n"
        "                                                    \n"
        "  // third buffer will contain blue color           \n"
        "  fragData2 = vec4 ( 0, 0, 1, 1 );                  \n"
        "                                                    \n"
        "  // fourth buffer will contain gray color          \n"
        "  fragData3 = vec4 ( 0.5, 0.5, 0.5, 1 );            \n"
        "}                                                   \n";
        // Load the shaders and get a linked program object
        userData->programObject = esLoadProgram ( vShaderStr, fShaderStr );
        init(esContext);
        glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
        return GL_TRUE;
    }
    
    void initFBO(ESContext *esContext) {
        UserData *userData = (UserData*)esContext->userData;
        int i;
        GLint defaultFramebuffer = 0;
        const GLenum attchments[4] =
        {
            GL_COLOR_ATTACHMENT0,
            GL_COLOR_ATTACHMENT1,
            GL_COLOR_ATTACHMENT2,
            GL_COLOR_ATTACHMENT3
        };
        glGetIntegerv(GL_FRAMEBUFFER_BINDING, &defaultFramebuffer);
        
        // setup fbo
        glGenFramebuffers(1, &userData->fbo);
        glBindFramebuffer(GL_DRAW_FRAMEBUFFER, userData->fbo);
    
        userData->textureHeight = userData->textureWidth = 400;
        glGenTextures(4, &userData->colorTexId[0]);
        
        // setup four output buffers and attach to fbo
        for (i = 0; i < 4; ++i) {
            glBindTexture(GL_TEXTURE_2D, userData->colorTexId[i]);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, userData->textureWidth, userData->textureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
            // Set the filtering mode
            glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
            glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
            glFramebufferTexture2D(GL_DRAW_FRAMEBUFFER, attchments[i], GL_TEXTURE_2D, userData->colorTexId[i], 0);
        }
        glDrawBuffers(4, attchments);
        if (GL_FRAMEBUFFER_COMPLETE != glCheckFramebufferStatus ( GL_FRAMEBUFFER )){
           return;
        }
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
    }
    
    void drawGeometry ( ESContext *esContext ) {
        UserData *userData = (UserData*)esContext->userData;
        GLfloat vVertices[] = {
            -1.0f,  1.0f, 0.0f,
            -1.0f, -1.0f, 0.0f,
            1.0f, -1.0f, 0.0f,
            1.0f,  1.0f, 0.0f,
        };
        GLushort indices[] = { 0, 1, 2, 0, 2, 3 };
        glViewport(0, 0, esContext->width, esContext->height);
        glClear(GL_COLOR_BUFFER_BIT);
        glUseProgram(userData->programObject);
        // Load the vertex position
        glVertexAttribPointer ( 0, 3, GL_FLOAT,
                                GL_FALSE, 3 * sizeof ( GLfloat ), vVertices );
        glEnableVertexAttribArray ( 0 );
        
        // Draw a quad
        glDrawElements ( GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, indices );
    }
    
    // Copy MRT output buffers to screen
    void blitTextures ( ESContext *esContext ) {
        UserData *userData = (UserData*)esContext->userData;
        // set the fbo for reading
        glBindFramebuffer(GL_READ_FRAMEBUFFER, userData->fbo);
        
        // Copy the output red buffer to lower left quadrant
        glReadBuffer(GL_COLOR_ATTACHMENT0);
        glBlitFramebuffer(0, 0, userData->textureWidth, userData->textureHeight, 0, 0, esContext->width * 0.5, esContext->height * 0.5, GL_COLOR_BUFFER_BIT, GL_LINEAR);
        // Copy the output green buffer to lower right quadrant
        glReadBuffer(GL_COLOR_ATTACHMENT1);
        glBlitFramebuffer(0, 0, userData->textureWidth, userData->textureHeight, 0, 0, esContext->width * 0.5, esContext->height * 0.5, GL_COLOR_BUFFER_BIT, GL_LINEAR);
        // Copy the output blue buffer to upper left quadrant
        glReadBuffer ( GL_COLOR_ATTACHMENT2 );
        glBlitFramebuffer ( 0, 0, userData->textureWidth, userData->textureHeight,
                            0, esContext->height/2, esContext->width/2, esContext->height,
                            GL_COLOR_BUFFER_BIT, GL_LINEAR );
        // Copy the output gray buffer to upper right quadrant
        glReadBuffer ( GL_COLOR_ATTACHMENT3 );
        glBlitFramebuffer ( 0, 0, userData->textureWidth, userData->textureHeight,
                            esContext->width/2, esContext->height/2, esContext->width, esContext->height,
                            GL_COLOR_BUFFER_BIT, GL_LINEAR );
    }
    
    void draw(ESContext *esContext) {
        UserData *userData = (UserData*)esContext->userData;
        GLint defaultFramebuffer = 0;
        const GLenum attachments[4] =
        {
           GL_COLOR_ATTACHMENT0,
           GL_COLOR_ATTACHMENT1,
           GL_COLOR_ATTACHMENT2,
           GL_COLOR_ATTACHMENT3
        };
        
        glGetIntegerv ( GL_FRAMEBUFFER_BINDING, &defaultFramebuffer );
        
        //FIRST: use MRTs to output four colors to four buffers
        glBindFramebuffer(GL_FRAMEBUFFER, userData->fbo);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        glDrawBuffers(4, attachments);
        drawGeometry(esContext);
        
        glBindFramebuffer(GL_DRAW_FRAMEBUFFER, defaultFramebuffer);
        blitTextures(esContext);
    }
};


#endif /* Texture_hpp */
