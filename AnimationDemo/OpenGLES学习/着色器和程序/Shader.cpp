//
//  Shader.cpp
//  AnimationDemo
//
//  Created by lieon on 2021/1/14.
//  Copyright © 2021 lieon. All rights reserved.
//

#include "Shader.hpp"
#include "esUtil.h"
#include "HelloTriangle.hpp"

/**
 # 获得链接后的着色器对象一般包括6个步骤
 - 创建一个顶点着色器对象和一个片段着色器对象
 - 将源代码连接到每个着色器对象
 - 编译着色器对象
 - 创建一个程序对象
 - 将编译后的着色器对象连接对程序对象
 - 链接程序对象
 # OpenGL ES 着色器语言
 ## 变量和变量类型
    - 标量 float, int, uint, bool用于浮点，整数，无符号整数和布尔值的基于标量的数据类型
    - 浮点向量 float, vec2, vec3, vec4 有1、2、3、4个分量的基于浮点的向量类型
    - 整数向量 int, ivec2, ivec3, ivec4 有1、2、3、4个分量的基于整数的向量类型
    - 无符号整数向量 uint, uvec2, uvec3, uvec4
    - 布尔向量 bool, bvec2, bvec3, bvec4
    - 矩阵 mat2, mat2x3
 ## 向量和矩阵的构造及选择
     ```C++
     float myfloat = 1.0
     float myfloat2 = 1; // Error: invalid type conversion
     bool myBool = true;
     int myInt = 0;
     int myInt2 = 0.0; // Error: invalid type conversion
 
     vec4 myVec4 = vec4(1.0); // myVec4 = {1.0, 1.0, 1.0, 1.0}
     vec3 myVec3 = vec3(1.0, 0.0, 0.5); // myVec3 = {1.0, 1.0, 1.0}
     vec3 tmp = vec3(myVec3);
     myVec4 = vec4(myVec2, tmp); // myVec4 = {myVec2.x, myVec2.y, tmp.x, tmp.y}
     mat3 myMat3 = mat3(1.0, 0.0, 0.0,
                         0.0, 1.0, 0.0,
                         1.0, 1.0, 1.0,
                         );
 
     ```
### 向量和矩阵分量
    - 向量的单独分量可以用两种方式访问：使用 "." 运算符或者通过数组下标访问。根据组成向量的分量数量，每个分量可以通过使用 {x,y,z,w}、{r,g,b,a}或者 {s,t,p,q }组合访问
    ```C++
    vec3 = myVec3 = vec3(0.0, 1.0, 2.0);
    vec3 tmp;
    tmp = myVec3.xyz; // tmp = {0.0, 1.0, 2.0}
    tmp = myVec3.xxx;  // tmp = {0.0, 0.0, 0.0}
    tmp = myVec3.zyx;  // tmp = {2.0, 1.0, 0.0}
    
    mat4 myMat4 = mat4(1.0);
    vec4 colo = myMat[0];
    float m1_1 = myMat4[1][1];
    float m2_2 = myMat4[2].z; // Get element at [2][2]
    ```
 ## 常量
     ```C++
     const float zero = 0.0;
     const float pi = 3.14159
     ```
 ## 结构体和数组
    - 结构体
    ```C++
    struct fogStruct {
        vec4 color;
        float start;
        float end;
    } fogVar;
 
    fogvar = fogStruct(vec4(1.0, 1.0, 0.0, 0.0),
                        0.5,
                        2.0
                    )
    ```
    - 数组
    ```C++
     float array[4];
     vec4 vecs[2];
    ```
 
 ## 运算符，控制流和函数
    - 运算符，与C语言一样，除了 == 和 != 之外，比较运算符只能标量。要比较向量，可以使用内建函数，逐个分量进行比较
    - 函数，与C语言一样
    - 内建函数
    ```C++
    float nDotL = dot(normal, light);
    float rDotV = dot(vieDir, (2.0 * normal) * nDotL - light);
    float specular = specularColor * pow(rDotV, specularPower);
    ```
 ## 输入/输出变量、统一变量、统一变量块和布局限定符
 ### 统一变量
    - OpenGL ES着色器语言中的变量类型限定符之一是统一变量，存储应用程序通过OpenGL ES 3.0API传入着色器的只读值。本质上，一个着色器的任何参数在所有顶点或者片段中都应该统一变量的形式传入。在编译时已知值的变量应该是常量，而不是统一变量，这样可以提高效率
    - 统一变量是在全局作用域中声明，只需要统一限定符
    ```C++
    uniform mat3 viewProhMat;
    uniform mat3 viewMat;
    uniform vec3 lightPos;
    ```
    - 统一变量通常保存在硬件中，这个区域称作为 “常量存储区”, 是硬件中为存储常量值二分配的特殊空间
 ### 统一变量块
    ```C++
    #version 300 es
    
    uniform TrnasformBlock {
        mat4 matViewProj;
        mat3 matNormal;
        mat3 matTexGen;
    }
 
    layout(location = 0) in vec4 a_position;
 
    void main() {
        gl_position = matViewProj * a_position;
    }
    ```
 ### 布局限定符
    - 布局限定符可用于指定支持统一变量块的统一缓冲区对象在内存中的布局方式。布局限定符可以提供给单独的统一变量块，或者用于所有统一变量块。
    ```C++
    layout(shared, colum_major) uniform; // dafault if not
    layout(packed, row_major) uniform; // specified
    ```
    - 单独的统一变量块也可以通过覆盖全局作用域上的默认设置来设置布局。此外，统一变量块中的单独统一变量也可以指定布局限定符，如下：
    ```C++
    layout(std140) uniform TransformBlock {
        mat4 matViewProj;
        layout(row_major) mat3 matNormal;
        mat3 matTextGen;
    };
    ```
    - 统一变量布局限定符
        - shared shared限定符指多个着色器或者多个程序中统一变量块的内存布局相同。要使用这个限定符，不同的定义中的row_major/colomn_major值必须相等。
        - packed packed布局限定符指定编译器可以优化统一变量块的内存布局。使用这个限定符时必须查询偏移位置，而且统一变量块无法在顶点/片段着色器或者程序间共享
        - std140
        - row_major  矩阵在内存以行优先顺序布局
        - column_major 矩阵在内存以列优先顺序布局
### 顶点和片段着色器输入/输出
     - OpenGL ES着色器语言的另一个特殊变量类型是顶点输入变量，顶点输入变量用于指定顶点着色器中的每个顶点的输入。用in关键字指定。它们通常存储位置，发现，纹理坐标和颜色
     ```C++
     #version 300 es
     uniform mat4 u_matViewProj;
     layout(location = 0) in vec4 a_position; // 使用layout限定符用指定顶点属性的索引
     layout(location = 1) in vec3 a_color;
     out vec3 v_color; // v_color 为输出变量，其内容从a_color输入变量中复制而来。每个顶点着色器将在一个或者多个输出变量中输出需要传递给片段着色器的数据
     void main(void) {
         gl_position = u_matViewProj * a_position;
         v_color = a_color;
     }
     ```
     ```C++
      // 片段着色器
      #version 300 es
      precision mediump float;
      
      // 从顶点着色器中的输入数据
      in vec3 v_color;
      // 片段着色器的输出
      layout(location = 0) out vec4 o_fragColor;
      void main(void) {
         o_fragColor = vec4(v_color, 1.0);
      }
     ```
     - 片段着色器将输出一个或者多个颜色。在典型的情况下，只渲染都一个颜色缓冲区，在这种情况下，布局限定符是可选的（假定输出变量进入位置0），在片段着色器中会有一个输出变量，该值将是传递给管线逐片段操作部分的输出颜色。但是，当渲染到多个渲染目标（MRT）时。我们可以使用布局限定符指定每个输出前往的渲染目标
 
 
 ## 插值限定符
    - 在没有使用限定符时，默认的插值行为是执行平滑着色。也就是说，来自顶点着色器的输出变量在图元中线性插值，片段着色器接收线性插值之后的数值作为输入。
    ```C++
    // ...顶点着色器
    // 顶点着色器的输出
    smooth out vec3 v_color;
    
    // ...片段着色器
    // v_color 从顶点着色器输出作为输入
    soomth in vec3 v_color;
    ```
    - 平面着色输出/输入
     ```C++
     // ...顶点着色器
     // 顶点着色器的输出
     flat out vec3 v_color;
     
     // ...片段着色器
     // v_color 从顶点着色器输出作为输入
    flat in vec3 v_color;
     ```

 ## 预处理和指令
    - 与C++一致，但是宏不能定义为带参数的

 ## 统一变量和插值器打包
    - 没看懂
 
 ## 精度限定符
    - 变量可以声明为低，中，高精度
    - 在没有正确使用精度限定符时可能造成伪像
    - 在OpenGL ES规范中没有规定底层硬件中必须支持多种精度，所以某个OpenGL ES实现在最高精度上进行所有运算并简单地忽略限定符是完全正常的。
    - 在某些实现上，使用较低的精度可能带来好处
     ```C++
      highp vec3 positionl
      varrying lowp vec3 color;
      mediump float specularExp;
      ```
    - 如果变量声明时没有使用进度限定符，它将拥有默认精度
     ```C++
      precision highp float;
      precision mediump int;
      ```
 ## 不变性
    ``invariant``, 一旦变量声明了不可变性，编译器便保证相同的计算和着色器输入条件下结果相同
     ```C++
    #version 300 es
    uniform mat4 u_viewProMat;
    layout(location = 0) in vec4 a_vertext;
    invariant gl_position
    void main() {
        gl_position = u_viewProMat * a_vertext;
    }
      precision highp float;
      precision mediump int;
    ```
    
 */
/**
 # 顶点属性，顶点数组，缓冲区对象
 ## 指定顶点属性数据
    - 顶点属性数据可以用一个顶点数组对每个顶点指定，也可以将一个常量值用于一个图元的所有顶点，所有OpenGL ES 3.0实现必选支持最少16顶点属性。
 ### 常量顶点属性
    - 常量顶底属性对于一个图元的所有顶点都相同，所以对一个图元的所有顶点只需要指定一个值
 ### 顶点数组
    - 顶点数组指定每个顶点的属性，是保存在应用程序地址空间（OpenGL ES称为客户端）的缓冲区。它们作为你顶点缓冲对象的基础，提供指定属性数据的一种高效，灵活的手段。顶点数组用 glVertexAttribPointer 或 glVertexAttribIPointer函数指定
    - 分配和存储顶点属性数据的常用的两种方法
        - 在一个缓冲区中存储顶点属性--- 这种方法称为结构数组。结构表示顶点的所有属性，每个顶点有一个属性的数组
        - 在单独的缓冲区中保存每个顶点属性--这种方法称为数组结构
    - 假定每个顶点有4个顶点属性---位置，法线和两个纹理坐标哦---这些属性一起保存在为所有顶点分配的一个缓冲区中。顶点位置属性一个3个浮点数的向量（x,y,z）的形式指定，顶点法线也以3个浮点数组组成的向量形式指定，每个纹理坐标以两个浮点数组组成的向量的形式指定.
    - 如图是缓冲区的内存布局，缓冲区的跨距为组成顶点的所有属性总大小（一个顶点等于10个浮点数或者40个字节---12个字节用于位置，12个字节用于法线，8个字节用于Tex0，8个字节用于Tex1）
    - 在常量顶点属性和顶点数组之间选择
        - ``glEnableVertexAttribArray``和 ``glDisableVertexAttribArray``分别用于启用和禁用通用顶点属性数组。如果某个通用属性索引的顶点属性数组被禁用，将使用为该索引指定的常量顶点属性数据
 
 ## 在顶点着色器中声明顶点属性变量
 - 在顶点着色器中，变量通过使用``in``限定符声明顶点属性。属性变量也可以选择包含一个布局限定符号，提供属性索引。
 ```C++
     layout(location = 0) in vec4 a_position;
     layout(location = 1) in vec2 a_texcoord;
     layout(location = 2) in vec3 a_noraml;
 ```
 - in 限定符只能用于数据类型为 float, vec2, vec3, vec4, int, ivec2, ivec3, ivec4, uint. uvec2, uvec3, uvec4, mat2, mat2x2, mat2x3, mat2x4, mat3, mat3x3, mat3x4, mat4, mat4x2, mat4x3
 - 属性变量不能声明为数组或者结构
 - 在顶点着色器中声明为顶点属性的变量是只读变量，不能修改
 ### 将顶点属性绑定到顶点着色器中的属性变量
 - 在OpenGL ES 3.0中，可以使用3种方法将通用顶点属性索引映射到顶点着色器中的一个属性变量名称
    - 索引可以在顶点着色器源代码中用 ``layout(location = N)``限定符指定
    - OpenGL ES 3.0将通用属性索引绑定到属性名称 ``glBindAttribLocation``, 这种绑定在下一次程序链接时生效---不会改变当前链接的程序中使用的绑定
    - 【没懂这句话】应用程序可以将顶点属性索引绑定到属性名称, 这种绑定在程序链接时进行 可使用``glGetAttribLocation``命令查询分配的绑定
 
 ##  顶点缓冲区对象
 - 顶点缓冲区对象使OpenGL ES 3.0应用程序可以在高性能的图形内存中分配和缓存顶点数据，并从这个内存进行渲染，从而避免在每次绘制图元的时候重新发送数据。
 - 不仅是顶点数据，描述图元顶点索引，作为``glDrawElements``参数传递的元素也可以缓存
 - OpenGL ES 3.0支持两类缓冲区对象，用于指定顶点和图元数据：``数组缓冲区对象``和``元素数组缓冲区对象``。
 - ``GL_ARRAY_BUFFER``标志指定的数组缓冲区对象用于创建保存顶点数据的缓冲区对象
 - ``GL_ELEMENT_ARRAY_BUFFER``标志指定元素缓冲区对象用于创建保存图元索引的缓冲区对象
 - 在使用缓冲对象渲染之前，需要分配缓冲区对象并将顶点数据和元素索引上传到相应的缓冲区对象
 ```C++

 void initVertexBufferObjects(const GLvoid * vertextBuffer,
                              GLushort *indices,
                              GLuint numVertices,
                              GLuint numIndices,
                              GLuint *vboIds) {
     // 创建两个缓冲区对象
     glGenBuffers(2, vboIds);
     // 一个用于保存实际的顶点属性数据
     glBindBuffer(GL_ARRAY_BUFFER, vboIds[0]);
     glBufferData(GL_ARRAY_BUFFER,
                  numVertices * sizeof(const void*),
                  vertextBuffer,
                  GL_STATIC_DRAW);
     // 用于保存组成图元的元素索引
     glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vboIds[1]);
     glBufferData(GL_ELEMENT_ARRAY_BUFFER,
                  numVertices * sizeof(GLushort),
                  indices,
                  GL_STATIC_DRAW);
     
 }
 ```
 - ``void glGenBuffers (GLsizei n, GLuint* buffers)``分配n个缓冲区对象名称，并在buffers中返回它们
 - ``glBindBuffer``命令用于指定当前缓冲区对象
 - ``void glBufferData (GLenum target, GLsizeiptr size, const GLvoid* data, GLenum usage)`` 将根据size的值保留相应的数据存储。data参数可以为NULL，表示保留的数据存储不进行初始化。如果data是一个有效的指针，则其内容被复制到分配到的数据内存中
 
 ```C++
 void drawPrimituveWithoutVBOs(GLfloat *vertices, GLint vtxStride, GLint numIndices, GLushort *indices) {
     GLfloat *vtxBuf = vertices;
     glBindBuffer(GL_ARRAY_BUFFER, 0);
     glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
     
     glEnableVertexAttribArray(VERTEX_POS_INDX);
     glEnableVertexAttribArray(VERTEX_COLOR_INDX);
     
     glVertexAttribPointer(VERTEX_POS_INDX,
                           VERTEX_POS_SIZE,
                           GL_FLOAT,
                           GL_FALSE,
                           vtxStride,
                           vtxBuf);
     vtxBuf += VERTEX_POS_SIZE;
     glVertexAttribPointer(VERTEX_COLOR_INDX,
                           VERTEX_COLOR_SIZE,
                           GL_FLOAT,
                           GL_FALSE,
                           vtxStride,
                           vtxBuf);
     glDrawElements(GL_TRIANGLES,
                    numIndices,
                    GL_UNSIGNED_SHORT,
                    indices);
     glDisableVertexAttribArray(VERTEX_POS_INDX);
     glDisableVertexAttribArray(VERTEX_COLOR_INDX);
 }

 void drawPrimituveWithVBOs(ESContext *esContext,
                            GLint numVertices,
                            GLfloat *vtxBuf,
                            GLint vtxStide,
                            GLint numIndices,
                            GLushort *indices) {
     UserData *userData = (UserData*)esContext->userData;
     GLuint offset = 0;
     if (userData->vboIds[0] == 0 && userData->vboIds[1] == 0) {
         glGenBuffers(2, userData->vboIds);
         glBindBuffer(GL_ARRAY_BUFFER, userData->vboIds[0]);
         glBufferData(GL_ARRAY_BUFFER, vtxStide * numVertices, vtxBuf, GL_STATIC_DRAW);
         
         glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, userData->vboIds[1]);
         glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort) * numIndices, indices, GL_STATIC_DRAW);
     }
     glBindBuffer(GL_ARRAY_BUFFER, userData->vboIds[0]);
     glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, userData->vboIds[1]);
     glEnableVertexAttribArray(VERTEX_POS_INDX);
     glEnableVertexAttribArray(VERTEX_COLOR_INDX);
     glVertexAttribPointer(VERTEX_POS_INDX,
                           VERTEX_POS_SIZE,
                           GL_FLOAT,
                           GL_FALSE,
                           vtxStide,
                           (const void*)offset);
     offset += VERTEX_POS_SIZE * sizeof(GLfloat);
     glVertexAttribPointer(VERTEX_COLOR_INDX,
                           VERTEX_COLOR_SIZE,
                           GL_FLOAT,
                           GL_FALSE,
                           vtxStide,
                           (const void*)offset);
     glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_SHORT, 0);
     glDisableVertexAttribArray(VERTEX_POS_INDX);
     glDisableVertexAttribArray(VERTEX_COLOR_INDX);
     glBindBuffer(GL_ARRAY_BUFFER, 0);
     glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0);
 }

 ```
 
 ## 顶点数组对象
 - 加载顶点属性的两种方式: 顶点数组和顶点缓冲区对象
 - 顶点缓冲区对象由于顶点数组，因为能够减少CPU和GPU之间复制的数据量，从而获得更好的性能
 - 顶点数组对象（VAO）能够使顶点数组使用更加高效
 - 在使用顶点缓冲区对象设置绘图操作可能多次需要调用 glbindBuffer, glVertexAttribPointer 和 glEnableVertexAttribArray。为了更快地再顶点数组配置之间切换， OPenGL ES 3.0推出了顶点数组对象
 - ``void glGenVertexArrays (GLsizei n, GLuint* arrays) ``创建新的顶点数组对象
 - 每个VAO都包含一个完整的状态向量，描述所有顶点缓冲区绑定和启用的顶点客户状态。绑定VAO时，它 的状态向量提供顶点缓冲区状态的当前设置。
 - 用``glBindVertexArray``绑定顶点数组对象后，更改顶点数组状态的后续调用将影响新的VAO
 - 这样，应用程序可以通过绑定一个已经设置状态的顶点数组对象快速地再顶点数组配置之前切换。所有变化可以在一个函数中调用完成，没有必要多次调用以更改顶点数组状态
 
 ## 映射缓冲区
 - 待补充
 ## 复制缓冲区
 - 待补充
 */

#define VERTEX_POS_SIZE 3
#define VERTEX_COLOR_SIZE 4
#define VERTEX_POS_INDX 0
#define VERTEX_COLOR_INDX 1

void drawPrimituveWithoutVBOs(GLfloat *vertices, GLint vtxStride, GLint numIndices, GLushort *indices) {
    glGenVertexArrays(0, NULL);
    GLfloat *vtxBuf = vertices;
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    
    glEnableVertexAttribArray(VERTEX_POS_INDX);
    glEnableVertexAttribArray(VERTEX_COLOR_INDX);
    
    glVertexAttribPointer(VERTEX_POS_INDX,
                          VERTEX_POS_SIZE,
                          GL_FLOAT,
                          GL_FALSE,
                          vtxStride,
                          vtxBuf);
    vtxBuf += VERTEX_POS_SIZE;
    glVertexAttribPointer(VERTEX_COLOR_INDX,
                          VERTEX_COLOR_SIZE,
                          GL_FLOAT,
                          GL_FALSE,
                          vtxStride,
                          vtxBuf);
    glDrawElements(GL_TRIANGLES,
                   numIndices,
                   GL_UNSIGNED_SHORT,
                   indices);
    glDisableVertexAttribArray(VERTEX_POS_INDX);
    glDisableVertexAttribArray(VERTEX_COLOR_INDX);
}

void drawPrimituveWithVBOs(ESContext *esContext,
                           GLint numVertices,
                           GLfloat *vtxBuf,
                           GLint vtxStide,
                           GLint numIndices,
                           GLushort *indices) {
    UserData *userData = (UserData*)esContext->userData;
    GLuint offset = 0;
    if (userData->vboIds[0] == 0 && userData->vboIds[1] == 0) {
        glGenBuffers(2, userData->vboIds);
        glBindBuffer(GL_ARRAY_BUFFER, userData->vboIds[0]);
        glBufferData(GL_ARRAY_BUFFER, vtxStide * numVertices, vtxBuf, GL_STATIC_DRAW);
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, userData->vboIds[1]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort) * numIndices, indices, GL_STATIC_DRAW);
    }
    glBindBuffer(GL_ARRAY_BUFFER, userData->vboIds[0]);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, userData->vboIds[1]);
    glEnableVertexAttribArray(VERTEX_POS_INDX);
    glEnableVertexAttribArray(VERTEX_COLOR_INDX);
    glVertexAttribPointer(VERTEX_POS_INDX,
                          VERTEX_POS_SIZE,
                          GL_FLOAT,
                          GL_FALSE,
                          vtxStide,
                          (const void*)offset);
    offset += VERTEX_POS_SIZE * sizeof(GLfloat);
    glVertexAttribPointer(VERTEX_COLOR_INDX,
                          VERTEX_COLOR_SIZE,
                          GL_FLOAT,
                          GL_FALSE,
                          vtxStide,
                          (const void*)offset);
    glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_SHORT, 0);
    glDisableVertexAttribArray(VERTEX_POS_INDX);
    glDisableVertexAttribArray(VERTEX_COLOR_INDX);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0);
}

void initVertexBufferObjects(const GLvoid * vertextBuffer,
                             GLushort *indices,
                             GLuint numVertices,
                             GLuint numIndices,
                             GLuint *vboIds) {
    // 创建两个缓冲区对象
    glGenBuffers(2, vboIds);
    // 一个用于保存实际的顶点属性数据
    glBindBuffer(GL_ARRAY_BUFFER, vboIds[0]);
    glBufferData(GL_ARRAY_BUFFER,
                 numVertices * sizeof(const void*),
                 vertextBuffer,
                 GL_STATIC_DRAW);
    // 用于保存组成图元的元素索引
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vboIds[1]);
    // void glBufferData (GLenum target, GLsizeiptr size, const GLvoid* data, GLenum usage) 将根据size的值保留相应的数据存储。data参数可以为NULL，表示保留的数据存储不进行初始化。如果data是一个有效的指针，则其内容被复制到分配到的数据内存中
    glBufferData(GL_ELEMENT_ARRAY_BUFFER,
                 numVertices * sizeof(GLushort),
                 indices,
                 GL_STATIC_DRAW);
    
}

#define VERTEX_POS_SIZE 3 // x, y, z
#define VERTEX_NORMAL_SIZE 3 // x, y, z
#define VERTEX_TEXCOORD0_SIZE 2 // s,t
#define VERTEX_TEXCOORD1_SIZE 2 // s, t

#define VERTEX_POS_INDEX 0
#define VERTEX_NORMAL_INDEX 1
#define VERTEX_TEXCOORD0_INDEX 2
#define VERTEX_TEXCOORD1_INDEX 3

#define VERTEX_POS_OFFSET 0
#define VERTEX_NORMAL_OFFSET 3
#define VERTEX_TEXCOORD0_OFFSET 6
#define VERTEX_TEXCOORD1_OFFSET 8

#define VERTEX_ATTRIB_SIZE (VERTEX_POS_SIZE + VERTEX_NORMAL_SIZE + VERTEX_TEXCOORD0_SIZE + VERTEX_TEXCOORD1_SIZE)


void testVertexStructArray() {
    int numVertices = 4;
    float *p = (float*)malloc(numVertices * VERTEX_ATTRIB_SIZE * sizeof(float));
    glVertexAttribPointer(VERTEX_POS_INDEX,
                          VERTEX_POS_SIZE,
                          GL_FLOAT, GL_FALSE,
                          VERTEX_POS_SIZE * sizeof(float),
                          p);
    
    glVertexAttribPointer(VERTEX_NORMAL_INDEX,
                          VERTEX_NORMAL_SIZE,
                          GL_FLOAT, GL_FALSE,
                          VERTEX_POS_SIZE * sizeof(float),
                          p + VERTEX_NORMAL_OFFSET);
    
    glVertexAttribPointer(VERTEX_TEXCOORD0_INDEX,
                          VERTEX_TEXCOORD0_SIZE,
                          GL_FLOAT, GL_FALSE,
                          VERTEX_POS_SIZE * sizeof(float),
                          p + VERTEX_TEXCOORD0_OFFSET);
    
    glVertexAttribPointer(VERTEX_TEXCOORD1_INDEX,
                          VERTEX_TEXCOORD1_SIZE,
                          GL_FLOAT, GL_FALSE,
                          VERTEX_POS_SIZE * sizeof(float),
                          p + VERTEX_TEXCOORD1_OFFSET);
}


int initProgram(ESContext *esContext) {
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

    programObject = esLoadProgram ( vShaderStr, fShaderStr );
    if ( programObject == 0 ) {
       return GL_FALSE;
    }
    userData->programObject = programObject;
    glClearColor ( 1.0f, 1.0f, 1.0f, 0.0f );
    return GL_TRUE;
}


void drawShader(ESContext *esContext) {
    UserData *userData = (UserData*)esContext->userData;
    GLfloat color[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    GLfloat vertexPos[3 * 3] =
    {
        0.0f, 0.5f, 0.0f,
        -0.5, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f,
    };
    glViewport(0, 0, esContext->width, esContext->height);
    glClear(GL_COLOR_BUFFER_BIT);
    glUseProgram(userData->programObject);
    glVertexAttrib4fv(0, color);
    // 设置顶点数组
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, vertexPos);
    // 启用通用顶点属性数组
    glEnableVertexAttribArray(1);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glDisableVertexAttribArray(1);
    
}

int initVAO(ESContext *esContext) {
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
    
    GLfloat vertices[3 * (VERTEX_POS_SIZE + VERTEX_COLOR_SIZE)] =
    {
        0.0f, 0.5f, 0.0f,
        1.0f, 0.0f, 0.0f, 1.0f,
        -0.5f, -0.5f, 0.0f,
        0.0f, 1.0f, 0.0f, 1.0f,
        0.5f, -0.5f, 0.0f,
        0.0f, 0.5f, 1.0f, 1.0f
    };
    GLushort indices[3] = {0, 1, 2};
    
    GLuint programObject;

    programObject = esLoadProgram ( vShaderStr, fShaderStr );
    if ( programObject == 0 ) {
       return GL_FALSE;
    }
    userData->programObject = programObject;
    glGenBuffers(2, userData->vboIds);
    
    glBindBuffer(GL_ARRAY_BUFFER, userData->vboIds[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ARRAY_BUFFER, userData->vboIds[1]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    glGenVertexArrays(1, &userData->vaoId);
    glBindVertexArray(userData->vaoId);
    return GL_TRUE;
}

