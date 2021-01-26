//
//  VertextShader.hpp
//  AnimationDemo
//
//  Created by lieon on 2021/1/20.
//  Copyright © 2021 lieon. All rights reserved.
//

#ifndef VertextShader_hpp
#define VertextShader_hpp

#include "esUtil.h"

#include <stdio.h>

class VertextShader {
    
    /**
     # 顶点着色器
     - 如图展示OpenGL ES 3.0可编程管线，有阴影的方框表示OpenGL ES 3.0中的可编程阶段。
     - 顶点着色器可用于传统的基于顶点操作，例如通过矩阵变换位置，计算照明方程式以生成逐顶点的颜色以及生成或者变换纹理坐标
     ## 顶点着色器概述
     - 顶点着色器提供顶点操作的通用可编程方法。如下图展示了顶点着色器的输入和输出，顶点着色器的输入包括：
     - 属性---用顶点数组提供的煮顶点数据
     - 统一变量和统一变量缓冲区---顶点着色器使用的不变数据类型
     - 采样器---代表顶点着色亲使用的纹理的特殊统一变量类型
     - 着色器程序---顶点着色器程雪源代码货色描述在操作顶点的可执行文件
     - 顶点着色器的输出称作顶点着色器输出变量。在图元光栅化阶段，为每个生成的片段计算这些变量，并作为片段着色器的输入传入
     
     ### 顶点着色器内建变量
     - 顶点着色器的内建变量可以分为特殊变量（顶点着色亲的输入输出），统一变量（如深度范围）以及规定最大值（如属性数量，顶点着色器输出变量数量和统一变量数量）的常量
     #### 内建特殊变量
     - 它们可以作为顶点着色器的输入或者在之后成为片段着色器输入的顶点着色器输出，或者片段着色器的输出。
     - ``gl_VertexID`` 是一个输入变量，用于保存顶点的整数索引。这个整数型变量用highp精度限定符声明
     - ``gl_IntanceID``是一个输入变量，用于保存实例化绘图调用中图元的实例编号。对于常规的绘图调用，该值为0.gl_InstaceID是一个整数型变量，用highp精度限定符号声明
     - ``gl_Position``用于输出顶点位置的裁剪坐标。该值在裁剪和视口阶段用于执行相应的图元裁剪以及裁剪坐标到屏幕坐标的顶点位置转换。如果顶点着色器we写入gl_Position。则gl_Position的值未定义。gl_Position是一个浮点变量，用highp精度限定符声明
     - ``gl_PointSize``用于写人以像素表示的点精灵尺寸，在渲染点精灵时使用。顶点着色器输出的gl_PointSize值被限定在OpenGL ES 3.0实现支持的非平滑点大小范围之内。gl_PointSize是一个浮点变量，用highp精度限定符声明
     - ``gl_FrontFacing``是一个特殊变量，但不是由顶点着色器直接写入的，而是根据顶点着色器生层的位置值和渲染的图元类型生成的。它是一个布尔变量
     #### 内建统一状态
     - 顶点着色器内可用的唯一内建统一状态是窗口坐标中的深度范围。这由内建统一变量名``gl_DepthRange``给出，该变量声明为 ``gl_DepthRangeParmeters``类型统一变量
     ```C++
     struct gl_DepthRangeParmeters {
     highp float near;
     highp float far;
     highp float diff;
     }
     uniform gl_DepthRangeParmeters gl_DepthRange;
     ```
     #### 内建常量
     - 顶点着色器内内建常量如下：
     ```C++
     
     // 可以指定的顶点属性的最大数量
     const mediump int gl_MaxVertexArribs = 16;
     //顶点着色器中可以使用的vec4统一变量项目的最大数量
     const mediump int gl_MaxVertexUniforVectors = 256;
     // 输出向量的最大数量
     const mediump int gl_MaxVertexOutputVectors = 16;
     //顶点着色器中可用的纹理单元的最大数量
     const mediump int gl_MaxVertexTextureImageUnits = 16;
     // 顶点和片段着色器中可用纹理单元最大数量的总和
     const mediump int gl_MaxCombinedTextureImageUnits = 32;
     ```
     #### 精度限定符
     ```C++
     highp vec4 position;
     out lowp vec4 color;
     mediump float s;
     highp int one;
     ```
     - 默认精度限定符
     ```C++
     precision highp float;
     precision mediump int;
     ```
     ### 顶点着色器中的统一变量限制数量
     - gl_MaxVextexUniformVectors描述了可以用于顶点着色器的统一变量的最大数量，gl_MaxVextexUniformVectors最小值为256个vec4项目。统一变量存储用于存储如下变量:
     - 用统一变量限定符声明的变量
     - 常数变量
     - 字面量
     - 特定于实现的常量
     
     ```C++
     #vesion 300 es
     #define NUM_TEXTURES 2
     uniform mat4 tex_maritx(NUM_TEXTURES);
     uniform bool enable_tex(NUM_TEXTURES);
     uniform bool enable_tex_martrix(NUM_TEXTURES);
     
     in vec4 a_texcoord0;
     in vec4 a_texcoord1;
     
     out vec4 v_texcoord(NUM_TEXTURES);
     ```
     ### 矩阵变换
     - 模型-视图-投影矩阵（MVP），顶点着色器的位置输入保存为物体坐标，而输出位置保存为裁剪坐标。MVP矩阵是3D图形中进行矩阵变换的3个非常重要的交换矩阵的乘积：模型矩阵、视图矩阵和投影矩阵
     - 模型矩阵---将物体坐标变换为世界坐标
     - 视图矩阵---将世界坐标变为眼睛坐标
     - 投影矩阵---将眼睛坐标变换为裁剪坐标
     #### 模型-视图矩阵
     - 这个4x4矩阵将顶点位置从物体坐标转换为眼睛坐标，组合了从物体到世界坐标和世界坐标到眼睛坐标的变换
     #### 投影矩阵
     - 投影矩阵取眼睛坐标（应用模型-视图矩阵计算）并产生裁剪坐标。在固定功能OpenGL中，这种变换用glFrustum后者OpenGL工具函数gluPerpective指定
     
     ### 顶点着色器中的照明
     - 没懂
     */
    
    typedef struct {
        // Handle to a program object
        GLuint programObject;
        
        // Uniform locations
        GLint  mvpLoc;
        
        // Vertex daata
        GLfloat  *vertices;
        GLuint   *indices;
        int       numIndices;
        
        // Rotation angle
        GLfloat   angle;
        
        // MVP matrix
        ESMatrix  mvpMatrix;
    } UserData;
    
    int init(ESContext *esContext) {
        UserData *userData = (UserData*)esContext->userData;
        const char vShaderStr[] =
        "#version 300 es                             \n"
        "uniform mat4 u_mvpMatrix;                   \n"
        "layout(location = 0) in vec4 a_position;    \n"
        "layout(location = 1) in vec4 a_color;       \n"
        "out vec4 v_color;                           \n"
        "void main()                                 \n"
        "{                                           \n"
        "   v_color = a_color;                       \n"
        "   gl_Position = u_mvpMatrix * a_position;  \n"
        "}                                           \n";
        
        const char fShaderStr[] =
        "#version 300 es                                \n"
        "precision mediump float;                       \n"
        "in vec4 v_color;                               \n"
        "layout(location = 0) out vec4 outColor;        \n"
        "void main()                                    \n"
        "{                                              \n"
        "  outColor = v_color;                          \n"
        "}                                              \n";
        userData->programObject = esLoadProgram(vShaderStr, fShaderStr);
        
        userData->mvpLoc = glGetUniformLocation(userData->programObject, "u_mvpMatrix");
        
        userData->numIndices = esGenCube(1.0,
                                         &userData->vertices,
                                         NULL, NULL,
                                         &userData->indices);
        userData->angle = 45.0f;
        glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
        return 1;
    }
    
    void update(ESContext *esContext, float deltaTime) {
        UserData *userData = (UserData*)esContext->userData;
        ESMatrix perspective;
        ESMatrix modelview;
        float    aspect;

        // Compute a rotation angle based on time to rotate the cube
        userData->angle += ( deltaTime * 40.0f );

        if ( userData->angle >= 360.0f )
        {
           userData->angle -= 360.0f;
        }

        // Compute the window aspect ratio
        aspect = ( GLfloat ) esContext->width / ( GLfloat ) esContext->height;

        // Generate a perspective matrix with a 60 degree FOV
        esMatrixLoadIdentity ( &perspective );
        esPerspective ( &perspective, 60.0f, aspect, 1.0f, 20.0f );

        // Generate a model view matrix to rotate/translate the cube
        esMatrixLoadIdentity ( &modelview );

        // Translate away from the viewer
        esTranslate ( &modelview, 0.0, 0.0, -2.0 );

        // Rotate the cube
        esRotate ( &modelview, userData->angle, 1.0, 0.0, 1.0 );

        // Compute the final MVP by multiplying the
        // modevleiw and perspective matrices together
        esMatrixMultiply ( &userData->mvpMatrix, &modelview, &perspective );
    }
    
    
    void draw(ESContext *esContext) {
        UserData *userData = (UserData*)esContext->userData;
        
        glViewport(0.0, 0.0, esContext->width, esContext->height);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        glUseProgram(userData->programObject);
        glVertexAttribPointer(0, 3, GL_FLOAT,
                              GL_FALSE,
                              3 * sizeof(GLfloat),
                              userData->vertices);
        glEnableVertexAttribArray(0);
        glVertexAttrib4f(1.0, 1.0f, 0.0f, 0.0f, 1.0f);
        
        // Load the MVP matrix
        glUniformMatrix4fv ( userData->mvpLoc, 1, GL_FALSE, ( GLfloat * ) &userData->mvpMatrix.m[0][0] );

        // Draw the cube
        glDrawElements ( GL_TRIANGLES, userData->numIndices, GL_UNSIGNED_INT, userData->indices );
    }
    
    void shutDown(ESContext *escContext) {
        
    }
    
    void esMain(ESContext *esContext) {
        
    }
};


#endif /* VertextShader_hpp */
