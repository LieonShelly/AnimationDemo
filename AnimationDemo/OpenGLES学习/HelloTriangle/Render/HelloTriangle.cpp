//
//  HelloTriangle.cpp
//  AnimationDemo
//
//  Created by lieon on 2021/1/12.
//  Copyright © 2021 lieon. All rights reserved.
//

#include "HelloTriangle.hpp"

GLuint loadShader(GLenum type, const char *shaderSrc) {
    GLuint shader;
    GLint compiled;
    shader = glCreateShader(type);
    if (shader == 0) {
        return 0;
    }
    // load the shader source
    glShaderSource(shader, 1, &shaderSrc, NULL);
    // compile the shader
    glCompileShader(shader);
    //check the compile status
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if (!compiled) {
        GLint infoLen = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            char * infolog =  (char*)(malloc(sizeof(GLint)));
            glGetShaderInfoLog(shader, infoLen, NULL, infolog);
            esLogMessage ( "Error compiling shader:\n%s\n", infolog );
            free(infolog);
        }
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

int init(ESContext *esContext ) {
    UserData *userData = (UserData*)esContext->userData;
    char vShaderStr[] =
    "#version 300 es                          \n"
    "layout(location = 0) in vec4 vPosition;  \n"
    "void main()                              \n"
    "{                                        \n"
    "   gl_Position = vPosition;              \n"
    "}                                        \n";
    char fShaderStr[] =
    "#version 300 es                              \n"
    "precision mediump float;                     \n"
    "out vec4 fragColor;                          \n"
    "void main()                                  \n"
    "{                                            \n"
    "   fragColor = vec4 ( 1.0, 0.0, 0.0, 1.0 );  \n"
    "}                                            \n";
    GLuint vertexShader;
    GLuint fragmentShader;
    GLuint programObject;
    GLint linked;
    vertexShader = loadShader(GL_VERTEX_SHADER, vShaderStr);
    fragmentShader = loadShader(GL_FRAGMENT_SHADER, fShaderStr);
    programObject = glCreateProgram();
    if (programObject == 0) {
        return 0;;
    }
    glAttachShader(programObject, vertexShader);
    glAttachShader(programObject, fragmentShader);
    // linke the program
    glLinkProgram(programObject);
    // check the link status
    glGetProgramiv(programObject, GL_LINK_STATUS, &linked);
    if (!linked) {
        GLint infonLen = 0;
        glGetProgramiv(programObject, GL_INFO_LOG_LENGTH, &infonLen);
        if (infonLen > 1) {
            char *infoLog = (char*)malloc(sizeof(infonLen));
            glGetProgramInfoLog(programObject, infonLen, NULL, infoLog);
            esLogMessage ( "Error linking program:\n%s\n", infoLog );
            free(infoLog);
        }
        glDeleteProgram(programObject);
        return  false;
    }
    userData->programObject = programObject;
    
    glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
    return true;
}

void draw(ESContext *esContext) {
    UserData *userDara = (UserData*)esContext->userData;
    GLfloat vVertices[] = {
        0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f
    };
    glViewport(0, 0, esContext->width, esContext->height);
    glClear(GL_COLOR_BUFFER_BIT);
    glUseProgram(userDara->programObject);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, vVertices);
    glEnableVertexAttribArray(0);
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

void shutDown(ESContext *esContext) {
    UserData *useDatta = (UserData*)esContext->userData;
    glDeleteProgram(useDatta->programObject);
}

int esMain(ESContext *esContext) {
    esContext->userData = malloc(sizeof(UserData));
    esCreateWindow(esContext, "Hello", 320, 240, ES_WINDOW_RGB);
    if (!init(esContext)) {
        return  GL_FALSE;
    }
    esRegisterShutdownFunc(esContext, shutDown);
    esRegisterDrawFunc(esContext, draw);
    return GL_TRUE;
}
