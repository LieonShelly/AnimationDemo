//
//  VertexArrayObjects.cpp
//  AnimationDemo
//
//  Created by lieon on 2021/1/19.
//  Copyright © 2021 lieon. All rights reserved.
//

#include "VertexArrayObjects.hpp"



#define VERTEX_POS_SIZE       3 // x, y and z
#define VERTEX_COLOR_SIZE     4 // r, g, b, and a

#define VERTEX_POS_INDX       0
#define VERTEX_COLOR_INDX     1

#define VERTEX_STRIDE         ( sizeof(GLfloat) *     \
                                ( VERTEX_POS_SIZE +    \
                                  VERTEX_COLOR_SIZE ) )

int initWithVAO ( ESContext *esContext ) {
   UserData *userData = (UserData*)esContext->userData;
   const char vShaderStr[] =
      "#version 300 es                            \n"
      "layout(location = 0) in vec4 a_position;   \n"
      "layout(location = 1) in vec4 a_color;      \n"
      "out vec4 v_color;                          \n"
      "void main()                                \n"
      "{                                          \n"
      "    v_color = a_color;                     \n"
      "    gl_Position = a_position;              \n"
      "}";


   const char fShaderStr[] =
      "#version 300 es            \n"
      "precision mediump float;   \n"
      "in vec4 v_color;           \n"
      "out vec4 o_fragColor;      \n"
      "void main()                \n"
      "{                          \n"
      "    o_fragColor = v_color; \n"
      "}" ;

   GLuint programObject;

   // 3 vertices, with (x,y,z) ,(r, g, b, a) per-vertex
   GLfloat vertices[3 * ( VERTEX_POS_SIZE + VERTEX_COLOR_SIZE )] =
   {
      0.0f,  0.5f, 0.0f,        // v0
      1.0f,  0.0f, 0.0f, 1.0f,  // c0
      -0.5f, -0.5f, 0.0f,        // v1
      0.0f,  1.0f, 0.0f, 1.0f,  // c1
      0.5f, -0.5f, 0.0f,        // v2
      0.0f,  0.0f, 1.0f, 1.0f,  // c2
   };
   // Index buffer data
    GLushort indices[3] = {0, 1, 2};
    programObject = esLoadProgram(vShaderStr, fShaderStr);
    if (programObject == 0) {
        return  GL_FALSE;
    }
    userData->programObject = programObject;
    glGenBuffers(2, userData->vboIds);
    glBindBuffer(GL_ARRAY_BUFFER, userData->vboIds[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, userData->vboIds[1]);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    // Generate VAO Id
    glGenVertexArrays(1, &userData->vaoId);
    // bind the VAO and then setup the vertex
    // attribute
    glBindVertexArray(userData->vaoId);
    
    glBindBuffer(GL_ARRAY_BUFFER, userData->vboIds[0]);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, userData->vboIds[1]);
    
    glEnableVertexAttribArray(VERTEX_POS_INDX);
    glEnableVertexAttribArray(VERTEX_COLOR_INDX);
    
    glVertexAttribPointer(VERTEX_POS_INDX,
                          VERTEX_POS_SIZE,
                          GL_FLOAT,
                          GL_FALSE,
                          VERTEX_STRIDE,
                          (const void *)0);
    glVertexAttribPointer(VERTEX_COLOR_INDX,
                          VERTEX_COLOR_SIZE,
                          GL_FLOAT,
                          GL_FALSE,
                          VERTEX_STRIDE,
                          (const void *)(VERTEX_POS_SIZE * sizeof(GLfloat)));
    // reset to the default VAO
    glBindVertexArray(0);
    
    glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
    return GL_TRUE;
}

void drawWithVAO(ESContext *esContext) {
    UserData *userData = (UserData*)esContext->userData;
    glViewport(0, 0, esContext->width, esContext->height);
    glClear(GL_COLOR_BUFFER_BIT);
    glUseProgram(userData->programObject);
    
    // Bind the VAO
    glBindVertexArray(userData->vaoId);
    
    // Draw with VAO settings
    glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_SHORT, (const void *)0);
    
    // return the default VAO
    glBindVertexArray(0);
}

void shutdownWithVAO ( ESContext *esContext ) {
   UserData *userData = (UserData*)esContext->userData;
   glDeleteProgram ( userData->programObject );
   glDeleteBuffers ( 2, userData->vboIds );
   glDeleteVertexArrays ( 1, &userData->vaoId );
}

int esMainWithVAO ( ESContext *esContext ) {
   esContext->userData = malloc ( sizeof ( UserData ) );
   esCreateWindow ( esContext, "VertexArrayObjects", 320, 240, ES_WINDOW_RGB );
   if ( !initWithVAO( esContext ) ) {
      return GL_FALSE;
   }
   esRegisterShutdownFunc ( esContext, shutdownWithVAO );
   esRegisterDrawFunc (esContext, drawWithVAO);
   return GL_TRUE;
}
