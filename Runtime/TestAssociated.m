//
//  TestAssociated.m
//  Runtime
//
//  Created by Johnson on 2017/5/15.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "TestAssociated.h"
#import "Father.h"
#import "Son.h"
#import "NSObject+RuntimeTools.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation TestAssociated
- (void)test;
{
    Father *f = [Father new];
    Son *s = [Son new];
    
    f.name = @"father";
    f.datasourse = @[@"father_ay"];
    f.datasourse2 = f.datasourse;
    
//    f.datasourse4 = f.datasourse;
    
    
    
    s.name = @"son";
    s.datasourse = @[@"son_ay"];
    
//    objc_category;
//    objc_object;
//    objc_class;
//    size_t;
    

    
    
    //暂时搁置, 会报错
//    unsigned int outCount = 0;
//    int count = objc_getClassList(NULL, outCount);
//    
//    Class *classes = objc_copyClassList(&outCount);
//    for (int i = 0; i < outCount; i++) {
//        NSLog(@"===== %@", classes[i]);
//    }
//    free(classes);
    
    

//    objc_property_attribute_t *attrs = property_copyAttributeList(class_getProperty([f class], "uintA"), &attriCount);
//    NSLog(@"%s", attrs[0]); // d
    
    
    NSLog(@"f %@ %@ %@", [f runtimeProperties], [f runtimeIvars], [f runtimeInstanceMethodList]);
    
    
    NSLog(@"%@  %@", [[NSObject new] runtimeInstanceMethodList], [[NSObject new] runtimeClassMethodList]);
    
    
    
    
    
    
    //实例方法调用  [self name];
    id name = ((id (*)(id, SEL))objc_msgSend)(s, @selector(name));
    
    
    //实例中调用super.  [super name]
    struct objc_super superClass = {s, [Son superclass]};
    id super_name = ((id (*)(id, SEL))objc_msgSendSuper)((__bridge id)(&superClass), @selector(name));
    
    //类方法调用 [Son classMethod];  伴随随机崩溃
//    ((id (*)(id, SEL))objc_msgSend)([s class], @selector(classMethod));
//    ((id (*)(id, SEL))objc_msgSend)([Son class], @selector(classMethod));
    
    
    
    NSLog(@"allframeworks:%@\n%@allclass:%@", [s runtimeGetAllFrameworks], s, [s runtimeGetAllClassFromWithFrameworks:[[[s runtimeGetAllFrameworks] firstObject] UTF8String]]);
    
    //获取类所在库名称
    NSLog(@"%@属于%s", [CBManager class], class_getImageName([CBManager class]));
    
    
    
    
    // 声明属性如果不在本类中声明(到其他的.m .h中声明), 那么是不会自动产生get set方法的, 如datasourse4
    
    // .h readonly属性在.m覆盖时, 只能是声明类可以重写, 多extention声明, 如datasourse3,是不能复写的(不能在extention中写多个一样的属性!!!), 并且.m中复写属性也是不会自动产生get set方法的
    
    // Category 属性需要手动实现get set, 并且不会有对应的_property的ivar 参考objc_category.
    
    // 有时我们不明白为什么类方法可以直接调用实例方法, 其实是系统分别实现了类/实例方法, 如methodSignatureForSelector: 它有对应的+ -方法. 只是系统头文件屏蔽了+, 只展示-方法给我们.
    
    // valueForKey:property == valueForKey:_property
}



@end
