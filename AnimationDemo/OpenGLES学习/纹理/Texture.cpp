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
 ## 什么是纹理
 - 纹理是一个缓存，用来保存图像的颜色元素值
 - 纹理可以使用任何图像
 - 当纹理应用到图形中，会使渲染场景更加自然
 - 当用一个图像初始化纹理缓存之后，在这个图像中的每个像素变成了纹理中的一个纹素。与像素类似，纹素保存颜色数据。像素和纹素之间的差别：像素通常表示计算机屏幕上的实际的颜色点，因此像素通常被用作为一个测量单位。纹素存在一个虚拟的没有尺寸的数学坐标系中
 - 纹理坐标用(S, T)表示你，纹理的尺寸永远是在S轴上从0.0到1.0，在T轴上从0.0到1.0。从1像素高64像素宽的图像初始化来的纹理会沿着整个T轴有1纹素，沿着S轴有有64纹素
 
## 对齐纹理和几何图形
 - 在每个顶点的x,y,z坐标被转换成视口坐标后，GPU会设置转换生成三角形内的每个像素的颜色。转换几何形状数据为帧缓存中的颜色像素的渲染步骤叫做点阵话，``每个颜色像素叫做片元``。
 - 当OpenGL ES没有使用纹理时，GPU会根据包含该片元的对象的顶点颜色来计算每个片元的颜色。
 - 当设置了使用纹理后，GPU会根据在当前绑定的纹理缓存中的纹素来计算每个片元的颜色
 - 程序需要指定怎么对齐纹理和顶点，以便让GPU知道每个片元的颜色由哪些纹素决定。这个对齐又叫做映射，是通过扩展为每个顶点保存的数据来实现的：除了X，Y、Z坐标，每个顶点还会给出U和V坐标值，每个U坐标会映射顶点在视口中的最终位置到纹理中的沿着S轴的一个位置。V坐标映射到T轴
 
 ## 纹理的取样模式
 - 每个顶点的U和V坐标会附加到每个顶点在视口坐标中的最终位置。
 - GPU会根据计算出来的每个片元的U，V位置从绑定的纹理中选择纹素，这个选择过程叫做``采样``
 - 取样会把纹理的SheT坐标系与每个三角形的顶点U，V坐标匹配起来。如图，在S和T坐标中与{0, 0}位置最近的纹素会被映射到拥有{0, 0}的U、V坐标的顶点对应的片元上。
 - 每个随后的片元位置对应与一个沿着S和T周的与该片元在U、V坐标中的位置等比例位置。例如，一个U、V坐标为{0.5, 0.5}的片元会被当前绑定的纹理中最接近中间位置的纹素所着色
 - 渲染过程中的取样可能会导致纹理被拉伸，压缩，甚至翻转
 - OpenGL ES支持多个不同的取样模式：一个拥有大量纹素的纹理映射到帧缓存内的一个只覆盖几个像素的三角形中。或者，一个包含少量纹素的纹理可能会映射到一个帧缓存中产生很多个片元的三角形。程序会使用如下的 ``glTexParameteri()``函数来配置每个绑定的纹理，以便使OpenGL ES知道怎么处理可用纹素的数量与需要被着色的片元的数量之间的不匹配
 ```C++
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
 ```
 - 使用值``GL_LINEAR``来指定参数 ``GL_TEXTURE_MIN_FILTER``会告诉OpenGL ES无论何时出现多个纹素对应一个片元时，从相配的多个纹素中取样颜色，然后使用线性插值法来混合这些颜色以得到片元的颜色。产生的片元的颜色可能最终是一个纹理中不存在的颜色（线性插值）
 -  使用值``GL_NEAREST``来指定参数 ``GL_TEXTURE_MIN_FILTER``会告诉OpenGL，与片元的U、V坐标最接近的纹素的颜色会被取样（临近插值）
 - ``glTexParameteri()``的``GL_TEXTURE_MAG_FILTER``参数用于在没有足够的可用纹素唯一性地映射到一个或多个纹素到每个片元时配置取样。在这种情况下，``GL_LINEAR``值会有一个放大纹理的效果，并会让它模糊地出现在渲染的三角形上。
 - ``GL_TEXTURE_MAG_FILTER``的``GL_NEAREST``值仅仅会拾取与片元U、V位置接近的纹素的颜色，并放大纹理，这会使它有点像素化地出现在渲染的三角形上。
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



