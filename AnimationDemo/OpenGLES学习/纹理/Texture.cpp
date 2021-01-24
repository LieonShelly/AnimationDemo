//
//  Texture.cpp
//  AnimationDemo
//
//  Created by lieon on 2021/1/23.
//  Copyright © 2021 lieon. All rights reserved.
//

#include "Texture.hpp"
#include "esUtil.h"

/**
 # 纹理
 ## 纹理基础
 - 纹理用多种形式：2D纹理，2D纹理数组、3D纹理、立方图纹理
 - 纹理通常使用纹理坐标应用到一个表面，纹理坐标可以视为纹理数组数据中的索引。
 ### 2D纹理
 - 2D纹理是一个图像数据的二维数组
 - 一个纹理的单独数据元素称为纹素
 - 用2D纹理纹理渲染时，纹理坐标用作纹理图像中的索引
 - 2D纹理的纹理坐标用(s, t)指定或者(u, v)
 - 纹理图像左下角由st坐标(0.0, 0.0)指定，右上角由st(1.0, 1.0)指定
 - 在[0.0, 1.0]区间之外的坐标是允许的，在该区间之外的纹理读取行为由纹理包装模式决定
 
 ### 立方图纹理
 - 没懂
 ### 3D纹理
 - 没懂，暂时不想了解这么多
 ### 2D纹理数组
 - 2D纹理数组常常用于存储2D图像的一个动画。数组的每个切片表示纹理动画的一帧。
 - 2D纹理数组定位使用(s, t, r), r坐标选择2D纹理数组中要使用的切片, (s, t)坐标用于选择切片
 ### 纹理对象和纹理的加载
 - 纹理加载的步骤
    - 创建纹理对象，纹理对象是一个容器对象，保存渲染所需的纹理数据，例如：图像格式，过滤模式和包装模式。在OpenGL ES中，纹理对象用一个无符号整数表示，该整数是纹理对象的一个句柄。用于生成纹理对象的函数是 ``glGenTextures``
    - 绑定纹理对象进行操作，``glBindTexture``
    - 加载图像数据, ``glTexImage2D``
 
    ```C++
     GLuint textureId;
     
     GLubyte pixels[4 * 3] = {
         255, 0, 0,
         0, 255, 0,
         0, 0, 255,
         255, 255, 0
     };
     
     glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
     
     glGenTextures(1, &textureId);
     glBindTexture(GL_TEXTURE_2D, textureId);
     glTexImage2D(GL_TEXTURE_2D,
                  0,
                  GL_RED,
                  2, 2, 0, GL_RGB,
                  GL_UNSIGNED_BYTE,
                  pixels);
     glTexParameteri(GL_TEXTURE_2D,
                     GL_TEXTURE_MIN_FILTER,
                     GL_NEAREST);
     glTexParameteri(GL_TEXTURE_2D,
                     GL_TEXTURE_MAG_FILTER,
                     GL_NEAREST);
    ```
 ### 纹理过滤和mip贴图
 - 当前缩小或放大过滤器设置为 ``GL_NEAREST``时：一个纹素将在提供的纹理坐标位置上读取。这称作点采样或者最忌采样
 - 最近采样可能产生严重的视觉伪像，因为三角形在屏幕空间中变得较小，在不同像素间的插值中，纹理坐标有很大的跳跃。结果是，从一个大的纹理贴图中取得少量样本，造成锯齿伪像
 - 为了解决锯齿伪像的方案称为mip贴图(mipmapping)
 - mip贴图的思路是构建一个图像链---mip贴图链。
 - mip贴图链：始于原始图像，后续的每个图像在每个未读上是前一个图像的一半，一直到最后达到链底部的1x1纹理。
 ####纹理过滤
 - 纹理渲染时发生两种过滤：缩小和放大。缩小发生在屏幕上投影的多边形小于纹理尺寸的时候，放大发生在屏幕投影的多边形大于纹理尺寸的时候。
 - 对于放大，mip贴图不起作用
 - 对于缩小，可以使用不同的采样模式
 */

void testBindText() {
    GLuint textureId;
    
    GLubyte pixels[4 * 3] = {
        255, 0, 0,
        0, 255, 0,
        0, 0, 255,
        255, 255, 0
    };
    
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    
    glGenTextures(1, &textureId);
    glBindTexture(GL_TEXTURE_2D, textureId);
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RED,
                 2, 2, 0, GL_RGB,
                 GL_UNSIGNED_BYTE,
                 pixels);
    glTexParameteri(GL_TEXTURE_2D,
                    GL_TEXTURE_MIN_FILTER,
                    GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D,
                    GL_TEXTURE_MAG_FILTER,
                    GL_NEAREST);
}



