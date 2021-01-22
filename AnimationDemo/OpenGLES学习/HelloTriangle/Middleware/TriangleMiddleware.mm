//
//  TriangleMiddleware.m
//  AnimationDemo
//
//  Created by lieon on 2021/1/13.
//  Copyright © 2021 lieon. All rights reserved.
//

#import "TriangleMiddleware.h"
#import "VertexArrayObjects.hpp"
#import "esUtil.h"

@implementation TriangleMiddleware
{
    ESContext _esContext;
}

- (void)drawInRect:(CGRect)rect {
    _esContext.width = rect.size.width;
    _esContext.height = rect.size.height;
    if (_esContext.drawFunc) {
        _esContext.drawFunc(&_esContext);
    }
}


- (void)tearDownGL {
    if (_esContext.shutdownFunc ) {
        _esContext.shutdownFunc( &_esContext );
    }
}

- (void)setupGL {
    memset( &_esContext, 0, sizeof( _esContext ) );
    esMainWithVAO( &_esContext );
}
@end
