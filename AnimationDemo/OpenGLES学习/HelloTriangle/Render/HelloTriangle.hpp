//
//  HelloTriangle.hpp
//  AnimationDemo
//
//  Created by lieon on 2021/1/12.
//  Copyright © 2021 lieon. All rights reserved.
//

#ifndef HelloTriangle_hpp
#define HelloTriangle_hpp

#include <stdio.h>

#include "esUtil.h"

typedef struct {
    GLuint programObject;
    GLuint *vboIds;
    GLuint vaoId;
} UserData;

GLuint loadShader(GLenum type, const char *shaderSrc);

int init(ESContext *esContext );

void draw(ESContext *esContext);

void shutDown(ESContext *esContext);

int esMain(ESContext *esContext);


#endif /* HelloTriangle_hpp */
