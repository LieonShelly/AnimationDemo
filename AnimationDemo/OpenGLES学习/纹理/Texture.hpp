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
        userData->textureId = CreateMipMappedTexture2D();
        glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
        return 1;
    }
    
    // create mipmapped 2D texure image
    GLuint CreateMipMappedTexture2D() {
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
        
    }
    
    void shutDown(ESContext *esContext) {
        
    }
};


#endif /* Texture_hpp */
