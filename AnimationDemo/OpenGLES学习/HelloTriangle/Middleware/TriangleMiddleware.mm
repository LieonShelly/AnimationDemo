//
//  TriangleMiddleware.m
//  AnimationDemo
//
//  Created by lieon on 2021/1/13.
//  Copyright © 2021 lieon. All rights reserved.
//

#import "TriangleMiddleware.h"
#import "Texture.hpp"
#import "esUtil.h"

@implementation TriangleMiddleware
{
    ESContext _esContext;
    SimpleTexture2D * _sm;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sm = new SimpleTexture2D();
    }
    return self;
}

- (void)dealloc {
    delete _sm;
}

- (void)drawInRect:(CGRect)rect {
    _esContext.width = rect.size.width;
    _esContext.height = rect.size.height;
    if (_esContext.drawFunc) {
        _esContext.drawFunc(&_esContext);
    }
    _sm->draw(&_esContext);
}


- (void)tearDownGL {
    
}

- (void)setupGL {
    memset( &_esContext, 0, sizeof( _esContext ) );
    _esContext.userData = malloc ( sizeof ( UserData ) );
    esCreateWindow ( &_esContext, "Simple Texture 2D", 320, 240, ES_WINDOW_RGB );
    if (!_sm->init( &_esContext) ) {
        return;
    }
}
@end
