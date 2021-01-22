//
//  VertexArrayObjects.hpp
//  AnimationDemo
//
//  Created by lieon on 2021/1/19.
//  Copyright © 2021 lieon. All rights reserved.
//

#ifndef VertexArrayObjects_hpp
#define VertexArrayObjects_hpp
#include "esUtil.h"
#include <stdio.h>

typedef struct {
    // Handle to a program object
    GLuint programObject;

    // VertexBufferObject Ids
    GLuint vboIds[2];

    // VertexArrayObject Id
    GLuint vaoId;

} UserData;

int initWithVAO ( ESContext *esContext );

void drawWithVAO(ESContext *esContext);

void shutdownWithVAO ( ESContext *esContext );

int esMainWithVAO ( ESContext *esContext );

#endif /* VertexArrayObjects_hpp */
