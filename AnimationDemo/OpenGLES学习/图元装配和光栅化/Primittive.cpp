//
//  Primittive.cpp
//  AnimationDemo
//
//  Created by lieon on 2021/1/19.
//  Copyright © 2021 lieon. All rights reserved.
//

#include "Primittive.hpp"
#include "esUtil.h"

/**
 # 图元和光栅化
 ## 图元
 - 图元是可以用OpenGL ES中的glDrawArrays, glDrawElements, glDrawRangeElements, glDrawArrayInstanced , glDrawElementsInstaced命令绘制的几何形状对象
 - OpenGL ES 3.0可以绘制如下图元
    - 三角形
    - 直线
    - 点精灵
 ### 三角形
    - 三角形是描述由3D应用程序渲染的几何形状对象时最常用的方法，OpenGL ES支持的三角形图元有 ``GL_TRIANGLES、GL_TRIANGLE_STRIP、GL_TRIANGLE_FAN``
 ### 直线
    - OpenGL ES 支持的直线图元有`` GL_LINES、GL_LINE_STRIP GL_LINE_LOOP``
 ### 点精灵
 - OpenGL ES支持的点精灵图元是 ``GL_POINTS``。点精灵对指定的每个顶点绘制，点精灵通常用于将粒子效果当作点而非正方形绘制，从而实现高效渲染。点精灵是指定位置和半径的屏幕对齐的正方形，位置描述正方形的中心，半径用于计算点精灵的正方形的4个坐标
 
 ## 绘制图元
    - OpenGL ES 绘制图元的API: ``glDrawArrays, glDrawElements, glDrawRangeElements, glDrawArrayInstanced , glDrawElementsInstaced``
    ```C++
     #define VERTEX_POS_INDX 0
     #define NUM_FACES 6
     GLfloat vertices[] = { ... };
     glEnableVertexAttribArray(VERTEX_POS_INDX);
     glVertexAttribPointer(VERTEX_POS_INDX, 3, GL_FLOAT,
                           GL_FLOAT,
                           0, vertices)
    glDrawArrays(GL_TRIANGLES, 0, 36);
    ```
     
    ```C++
      #define VERTEX_POS_INDX 0
      #define NUM_FACES 6
      GLfloat vertices[] = { ... };
      glEnableVertexAttribArray(VERTEX_POS_INDX);
      glVertexAttribPointer(VERTEX_POS_INDX, 3, GL_FLOAT,
                            GL_FLOAT,
                            0, vertices)
     glDrawElements(GL_TRIANGLES,
                    sizeof(indices) / sizeof(GLubyte),
                    GL_UNSIGNED_BYTE,
                    indices)
    ```
 
 ### 图元重启
 - 使用图元重启，可以在一次绘图调用中渲染多个不相连的图元（例如三角扇和三角带）。这对于降低绘图API调用的开销是有利的，图元重启的另一种方法是生成退化三角形（需要一些注意事项），这种方法不简介、
 - 使用图元重启，可以通过在索引列表中插入一个特殊索引来重启一个索引绘图调用的图元。这个特殊索引是该索引类型的最大可能索引
 - 例如，假定两个三角形条带分别有元素索引（0， 1，2，3）和（8，9，10，11）。如果我们想利用图元重启在一次调用``glDrawElements*``中绘制两个条带，索引类型GL_UNSIGNED_BYTE，则组合的元素索引列表为(0, 1, 2, 3, 255, 8, 9, 10, 11)
 - 可以用如下代码启用和禁用图元重启
 ```C++
    glEnable(GL_PRIMITIVE_RESTART_FIXED_INDEX);
    glDisable(GL_PRIMITIVE_RESTART_FIXED_INDEX)
 ```
 ### 驱动顶点
 - 没懂
 ### 几何形状实例化
 - ``glDrawArraysInstanced``
 - ``glDrawElementsInstanced``
 ### 性能提示
 - 没懂
 ## 图元装配
 - 如图展示了图元装配阶段。通过glDraw***提供的顶点由顶点着色器执行，顶点着色器变换的每个顶点包括描述顶点(x, y, z, w)值的顶点位置。图元类型和顶点索引确定将被渲染的单独单元，对于每个单独图元及其对应的顶点，图元装配阶段执行如图所示的操作
 ### 坐标系统
 - 如图展示了顶点通过顶点着色器和图元装配阶段时的坐标系统。顶点以物体或本地坐标空间输入到OpenGL ES，这是最可能用来建模和存储一个对象的坐标空间。在顶点着色器执行之后，顶点位置被认为是在裁剪坐标空间内。顶点位置从本地坐标系统到裁剪坐标的变换通过加装执行这一转换的对应矩阵来完成，这些矩阵保存在顶点着色器中定义的统一变量中
 #### 裁剪
 - 为了避免在可视景提之外处理图元，图元被裁剪到裁剪空间。执行顶点着色器之后顶点位置处于裁剪坐标空间内。裁剪坐标是有（Xc, Yc, Zc, Wc）指定的同类坐标。在裁剪空间中定义顶点坐标根据视景体裁剪
 #### 透视分割
 - 没懂
 ### 视口变换
 - 视口是一个二维矩形窗口区域，是所有OpenGL ES渲染操作最终显示的地方。``glViewport``
 和 ``glDepthRangef``指定的值用于将顶点位置从规范化设备坐标转为窗口（屏幕）坐标
 
 ## 光栅化
 - 如下图展示了光栅化管线。在顶点变换和图元裁剪之后，在光栅化管线取得单独图元，并为改图元生成对应的片段，每个片段由屏幕空间中的整数位置(x,y)标识。片段代表了屏幕空间中(x,y)指定的像素位置由片段着色器处理而生成片段颜色的附加片段数据
 
 ### 剔除
 - 后续再看，现在没看懂
 ### 多边形偏移
 - 后续再看，现在没看懂
 
 ### 遮挡查询
 - 后续再看，现在没看懂
 */



void drawArray() {

}
