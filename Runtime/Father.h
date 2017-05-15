//
//  Father.h
//  Runtime
//
//  Created by Johnson on 2017/5/15.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Father : NSObject


@property (nonatomic, assign) float weight;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong, readonly) NSArray *datasourse;


+ (void)classMethod;

@end


@interface Father ()  //Son类中还有一个datasours4
@property (nonatomic, strong, readonly) NSArray *datasourse3;
@end


@interface Father (Tools)

@property (nonatomic, strong) NSArray *datasourse;

@property (nonatomic, strong) NSArray *datasourse2;

@property (nonatomic, strong) NSArray *datasourse6;

@end
