//
//  Runtime.m
//  Runtime
//
//  Created by Johnson on 6/8/15.
//  Copyright (c) 2015 Johnson. All rights reserved.
//

#import "Runtime.h"
#import <objc/message.h>
#import <objc/runtime.h>

NSString * testInstanceMethod(id self, SEL _cmd, NSString *string)
{
    NSLog(@"[%@ %s] -> instance method", self, _cmd);
    return @"===========";
}

void classMethod(id self, SEL _cmd)
{
    NSLog(@"[%@ %s] -> Class method",[self class], _cmd);
}

static char key;
@implementation Runtime

- (void)test
{
    NSString *test = @"test";
    
    Class classTest = objc_allocateClassPair([NSObject class], [test UTF8String], 0);
    //添加实例方法
    class_addMethod(classTest, @selector(testInstanceMethod), (IMP)testInstanceMethod, "@@:@");
    
    //动态绑定property,跟class_addProperty有本质的区别, 并没有出现在propertyList中
    objc_setAssociatedObject(classTest, &key, @"----------", OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_getAssociatedObject(@"-----", &key);
    
    //添加成员变量(必须在类注册到runtime之前定义)
    //添加一个NSString的变量，第四个参数是对其方式，第五个参数是参数类型(add_Method的Type Encodings)
    class_addIvar(classTest, "IvarName", sizeof(NSString *), 0, "@");
    //注册这个类到runtime系统中就可以使用它了
    objc_registerClassPair(classTest);
    
    //添加类方法(必须在类注册到runtime之后定义)
    class_addMethod(objc_getMetaClass([test UTF8String]), @selector(classMethod), (IMP)classMethod, "v@:v");
    
    //添加属性
    objc_property_attribute_t type = { "T", "@\"NSString\"" };
    objc_property_attribute_t ownership = { "C", "" }; // C = copy (readonly编码为R，copy编码为C，retain编码为&等)
    objc_property_attribute_t backingivar  = { "V", "_privateName" };
    objc_property_attribute_t attrs[] = { type, ownership, backingivar };
    /**并且添加get set 方法  class_addMethod  PropertyName setPropertyName*/
    class_addProperty(classTest, "PropertyName", attrs, 3);
    
    Class xxx =  NSClassFromString(test);
    id testInstance = [[xxx alloc] init];
    //实例方法调用
    //    id value = objc_msgSend(testInstance, @selector(testInstanceMethod), @"objc_msgSend");
    id value = ((id (*)(id, SEL, NSString *))objc_msgSend)(testInstance, @selector(testInstanceMethod), @"objc_msgSend");
    [testInstance performSelector:@selector(testInstanceMethod) withObject:@"performSelector"];
    
    
    
    //类方法调用
    Class class = objc_getClass([test UTF8String]);
    ((id (*)(id, SEL))objc_msgSend)(class, @selector(alloc));
    //    objc_msgSend(class, @selector(alloc));
    
//    ((id (*)(id, SEL))objc_msgSend)(class, @selector(classMethod));
//        objc_msgSend(class, @selector(classMethod));
    
    
//    NSLog(@"instanceMethodList:%@\npropertyList:%@\nivarList:%@",[self instanceMethodList:classTest], [self ivarList:classTest], [self propertyList:classTest]);
    
}
@end
