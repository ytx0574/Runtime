//
//  Test.m
//  Runtime
//
//  Created by Johnson on 2017/5/10.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "Test.h"
#import <objc/runtime.h>

@interface A : NSObject

@end

@implementation A

+ (void)class_a
{
    NSLog(@"test class_a", NSStringFromSelector(_cmd));
}

- (void)instance_a
{
    NSLog(@"test instance_a");
}

@end


@interface B : NSObject
@property (nonatomic, assign) NSInteger b;
+ (void)classMethod;

@end

@implementation B

@dynamic b;

int customB(id self, SEL sel)
{
    NSLog(@"动态绑定实例方法, 添加属性b的get实现");
    return 33;
}

void customClassMethod(id self, SEL _cmd)
{
    NSLog(@"动态绑定类方法  添加classMethod的实现");
}

//+ (void)classMethod
//{
//    NSLog(@"类方法");
//    class_addMethod(objc_getMetaClass(class_getName([self class])), @selector(test), (IMP)customClassMethod, "v@:");
//    [[self class] test];
//}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    if (sel == @selector(classMethod))
    {
//        class_addMethod([self class], sel, (IMP)customClassMethod, "v@:");  错误
        
        //由于类方法是保存在类的MetaClass中的, 所以添加类方法时要使用MetaClass
        class_addMethod(objc_getMetaClass(class_getName([self class])), sel, (IMP)customClassMethod, "v@:");
    }
    
    return [super resolveClassMethod:sel];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(b))
    {
        //动态为对象添加 b的get方法
        class_addMethod([self class], sel, (IMP)customB, "i@:");
    }
    
    return [super resolveInstanceMethod:sel];
}



@end

@implementation Test

/**
 
 运行时动态决议
 
 针对没有实现的函数进行补救, 可自添加函数的实现;  如果已有实现, 则不在进行动态决议. (可在原有函数内容执行前后, 添加自定义代码执行, 参考上方25行)
 + (BOOL)resolveClassMethod:(SEL)sel
 + (BOOL)resolveInstanceMethod:(SEL)sel
 
 */

- (void)test;
{
    
    //class_getMethodImplementation 获取对象对应的函数指针并调用;  不同的class有对应不同的method_list,
    //类和它对应的MetaClass看似一样, 实则有不同method_list,  MetaClass对应的是类有关的数据(如类方法列表)
    
    IMP imp = class_getMethodImplementation([A class], @selector(instance_a));  //msg_send
    IMP imp1 = class_getMethodImplementation([A class], @selector(class_a));  //找不到类方法 调用msg_forward
    IMP imp2 = class_getMethodImplementation(objc_getMetaClass("A"), @selector(class_a));  //类方法 要从MetaClass中获取
    
    const char *name = class_getName([A class]); //objc_getMetaClass("A") == objc_getMetaClass(class_getName([A class]));
    NSLog(@"A->MetaClass [%@][%p], A->Class [%@][%p]", objc_getMetaClass("A"), objc_getMetaClass("A"), [A class], [A class]);
    
    imp();
//    imp1();
    imp2();
    
    
    
    
    int b = [B new].b;
//    [B classMethod];
    [[B class] classMethod];
}

@end
