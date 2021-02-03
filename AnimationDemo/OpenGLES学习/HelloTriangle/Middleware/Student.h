//
//  Student.h
//  AnimationDemo
//
//  Created by lieon on 2021/2/2.
//  Copyright © 2021 lieon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property (nonatomic, assign) NSInteger _age;
@end

@interface Student : Person
@property (nonatomic, assign) NSInteger _no;

@end

NS_ASSUME_NONNULL_END
