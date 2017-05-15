//
//  Father.m
//  Runtime
//
//  Created by Johnson on 2017/5/15.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "Father.h"
#import <objc/runtime.h>

@interface Father ()
{
    NSString *_age;
    int _sex;
}
@property (nonatomic, strong) NSArray *datasourse;
//@property (nonatomic, strong) NSArray *datasourse3;
@property (nonatomic, strong) NSArray *datasourse5;
@end

@implementation Father

+ (void)classMethod;
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

//- (NSArray *)datasourse
//{
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//-(void)setDatasourse:(NSArray *)datasourse
//{
//    objc_setAssociatedObject(self, _cmd, datasourse, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//- (NSArray *)datasourse4
//{
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//-(void)setDatasourse4:(NSArray *)datasourse
//{
//    objc_setAssociatedObject(self, _cmd, datasourse, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}


@end


//@interface Father (Tools)
//
//@property (nonatomic, strong) NSArray *datasourse6;
//
//@end

@implementation Father (Tools)

//- (NSArray *)datasourse
//{
//    return objc_getAssociatedObject(self, _cmd);
//}
//
//-(void)setDatasourse:(NSArray *)datasourse
//{
//    objc_setAssociatedObject(self, _cmd, datasourse, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}



- (NSArray *)datasourse2
{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setDatasourse2:(NSArray *)datasourse
{
    objc_setAssociatedObject(self, _cmd, datasourse, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
