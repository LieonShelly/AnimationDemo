//
//  TriangleMiddleware.h
//  AnimationDemo
//
//  Created by lieon on 2021/1/13.
//  Copyright © 2021 lieon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TriangleMiddleware : NSObject
- (void)drawInRect:(CGRect)rect;
- (void)tearDownGL;
- (void)setupGL;
@end

NS_ASSUME_NONNULL_END
