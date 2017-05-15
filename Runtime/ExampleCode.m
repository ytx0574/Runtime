//
//  ExampleCode.m
//  Runtime
//
//  Created by Johnson on 2017/5/15.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "ExampleCode.h"
#import <objc/runtime.h>

@implementation ExampleCode

- (void)test
{
    /*  类相关
    
    // 获取类实例成员变量，只能取到本类的，父类的访问不到
    Ivar aInstanceIvar = class_getInstanceVariable([A class], "strA");
    NSLog(@"%s", ivar_getName(aInstanceIvar));    // a
    // 获取类成员变量，相当于class_getInstanceVariable(cls->isa, name)，感觉除非给metaClass添加成员，否则不会获取到东西
    Ivar aClassIvar = class_getClassVariable([A class], "strA");
    NSLog(@"%s", ivar_getName(aClassIvar));    // b
    // 往A类添加成员变量不会成功的。因为class_addIvar不能给现有的类添加成员变量，也不能给metaClass添加成员变量，那怎么添加，且往后看
    if (class_addIvar([A class], "intA", sizeof(int), log2(sizeof(int)), @encode(int))) {
        NSLog(@"绑定成员变量成功");    // c
    }
    // 获取类中的ivar列表，count为ivar总数
    unsigned int count;
    Ivar *ivars = class_copyIvarList([A class], &count);
    NSLog(@"%i", count);    // d
    // 获取某个名为"uIntA"的属性
    objc_property_t aPro = class_getProperty([A class], "uintA");
    NSLog(@"%s", property_getName(aPro));    // e
    // 获取类的全部属性
    class_copyPropertyList([A class], &count);
    NSLog(@"%i", count);    // f
    // 创建objc_property_attribute_t，然后动态添加属性
    objc_property_attribute_t type = { "T", [[NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([NSString class])] UTF8String] }; //type
    objc_property_attribute_t ownership0 = { "C", "" }; // C = copy
    objc_property_attribute_t ownership = { "N", "" }; //N = nonatomic
    objc_property_attribute_t backingivar  = { "V", [[NSString stringWithFormat:@"_%@", @"aNewProperty"] UTF8String] };  //variable name
    objc_property_attribute_t attrs[] = { type, ownership0, ownership, backingivar };
    if(class_addProperty([A class], "aNewProperty", attrs, 4)) {
        // 只会增加属性，不会自动生成set，get方法
        NSLog(@"绑定属性成功");    // g
    }
    // 创建objc_property_attribute_t，然后替换属性
    objc_property_attribute_t typeNew = { "T", [[NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([NSString class])] UTF8String] }; //type
    objc_property_attribute_t ownership0New = { "C", "" }; // C = copy
    objc_property_attribute_t ownershipNew = { "N", "" }; //N = nonatomic
    objc_property_attribute_t backingivarNew  = { "V", [[NSString stringWithFormat:@"_%@", @"uintA"] UTF8String] };  //variable name
    objc_property_attribute_t attrsNew[] = { typeNew, ownership0New, ownershipNew, backingivarNew };
    class_replaceProperty([A class], "uintA", attrsNew, 4);
    // 这有个很大的坑。替换属性指的是替换objc_property_attribute_t，而不是替换name。如果替换的属性class里面不存在，则会动态添加这个属性
    objc_property_t pro = class_getProperty([A class], "uintA");
    NSLog(@"123456   %s", property_getAttributes(pro));    // h
    // class_getIvarLayout、class_setIvarLayout、class_getWeakIvarLayout、class_setWeakIvarLayout用来设定和获取成员变量的weak、strong。参见http://blog.sunnyxx.com/2015/09/13/class-ivar-layout/
    
    // 输出
    2017-01-21 12:44:32.377 block[5103:1948802] strA    // a
    2017-01-21 12:44:32.377 block[5103:1948802] (null)    // b
    2017-01-21 12:44:32.377 block[5103:1948802] 2    // d
    2017-01-21 12:44:32.377 block[5103:1948802] uintA    // e
    2017-01-21 12:44:32.378 block[5103:1948802] 1    // f
    2017-01-21 12:44:32.378 block[5103:1948802] 绑定属性成功    // g
    2017-01-21 12:44:32.379 block[5103:1948802] 123456   T@"NSString",C,N,V_uintA    // h
     
     */
    
    
    
    
    /*  method相关
     // 调用一个object的method
     // method_invoke_stret(testMethod, method); 参照void method_invoke_stret(void *stretAddr, id theReceiver, SEL theSelector, ....) stretAddr为返回的数据结构
     // 若报错，project里面设定Enable Strict Checking of objc_msgSend Calls为NO
     A *testMethod = [A new];
     testMethod.uintA = 100;
     unsigned int outCount;
     Method *methods = class_copyMethodList([A class], &outCount);
     Method method = methods[0];
     method_invoke(testMethod, method);  // a
     // 将某个method指向一个新的IMP
     method_setImplementation(method, (IMP)aNewMethod);
     method_invoke(testMethod, method);  // b
     // 获取method的SEL
     SEL methodSel = method_getName(method);
     NSLog(@"%s", methodSel);    // c
     // 获取method的IMP
     // 随意传两个参数，无所谓的
     IMP methodImp = method_getImplementation(method);
     methodImp(0,0); // d
     // 获取method的类型编码，包含返回值和参数
     const char *methodEncoding = method_getTypeEncoding(method);
     NSLog(@"%s", methodEncoding);   // e
     // 获取method的返回值类型
     const char *returnType = method_copyReturnType(method);
     NSLog(@"%s", returnType);   // f
     // 获取method的某个参数类型
     const char *oneArgumentType = method_copyArgumentType(method, 0);
     NSLog(@"%s", oneArgumentType);  // g
     // 获取method的返回值类型
     char dst[256];
     method_getReturnType(method, dst, 256);
     NSLog(@"%s", dst);  // h
     // 获取method的参数个数
     unsigned int numOfArgu = method_getNumberOfArguments(method);
     NSLog(@"%d" ,numOfArgu);    // i
     // 获取method的某个参数的类型
     method_getArgumentType(method, 0, dst, 256);
     NSLog(@"%s", dst);  // j
     // 获取method的描述
     objc_method_description des = *method_getDescription(method);
     NSLog(@"%s", des);  // k
     // 更换method method_exchangeImplementations
     method_exchangeImplementations(methods[0], methods[1]);
     method_invoke(testMethod, methods[1]);  // l
     */
    
    
    /* protocol相关
     
     // 根据char *获取Protocol
     Protocol *protocol = objc_getProtocol("AProtocol");
     NSLog(@"%s", protocol_getName(protocol));   // a
     // 获取项目所有的protocol列表
     unsigned int protocolCount;
     Protocol * __unsafe_unretained *protocols = objc_copyProtocolList(&protocolCount);
     NSLog(@"%d", protocolCount);    // b
     // 动态创建一个protocol
     Protocol *bProtocol = objc_allocateProtocol("BProtocol");
     // 动态为protocol添加一个实例方法
     protocol_addMethodDescription(bProtocol, NSSelectorFromString(@"bProtocolMethod"), "v@:", NO, YES);
     // 动态为protocol添加property
     // 添加属性必须两个参数都是YES，因为属性的方法必须是实例和requried
     objc_property_attribute_t attributes[] = { { "T", "@\"NSString\"" }, { "&", "N" }, { "V", "" } };
     protocol_addProperty(bProtocol, "bProtocolProperty", attributes, 3, YES, YES);
     // 为protocol添加其需要遵循的protocol
     protocol_addProtocol(bProtocol, @protocol(NSObject));
     // 注册这个protocol
     objc_registerProtocol(bProtocol);
     // 获取protocol的所有可选的实例方法
     class_addProtocol([A class], bProtocol);
     class_addMethod([A class], NSSelectorFromString(@"bProtocolMethod"), (IMP)aNewMethod, "v@:");
     unsigned int protocolOutCount;
     protocol_copyMethodDescriptionList(bProtocol, NO, YES, &protocolOutCount);
     NSLog(@"%d", protocolOutCount); // c
     // 获取protocol中某个方法的描述
     objc_method_description desc = protocol_getMethodDescription(bProtocol, NSSelectorFromString(@"bProtocolMethod"), NO, YES);
     NSLog(@"%s", desc); // d
     // 获取protocol的属性列表
     protocol_copyPropertyList(bProtocol, &protocolOutCount);
     NSLog(@"%d", protocolOutCount); // e
     // 获取protocol中某个属性
     objc_property_t proNewPro = protocol_getProperty(bProtocol, "bProtocolProperty", YES, YES);
     NSLog(@"%s", proNewPro);    // f
     // 获取protocol遵循的protocol列表
     protocol_copyProtocolList(bProtocol, &protocolOutCount);
     NSLog(@"%d", protocolOutCount); // g
     // 判断某个protocol是否遵循另一个protocol
     if (protocol_conformsToProtocol(bProtocol, @protocol(NSObject))) {
     NSLog(@"bProtocol遵循NSObject");  // h
     }
     // 判断两个protocol是否相同
     if(!protocol_isEqual(bProtocol, @protocol(AProtocol))) {
     NSLog(@"bProtocol和Aprotocol不同");    // i
     }
     
     */
}

@end
