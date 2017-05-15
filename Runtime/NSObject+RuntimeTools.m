//
//  NSObject+RuntimeTools.m
//  Runtime
//
//  Created by Johnson on 2017/5/15.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "NSObject+RuntimeTools.h"
#import <objc/runtime.h>

@implementation NSObject (RuntimeTools)
- (NSArray *)runtimeProperties;
{
    NSMutableArray *ay = [NSMutableArray array];
    
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
//        NSString *attribute = [NSString stringWithUTF8String:property_getAttributes(properties[i])];
        
        //获取属性描述对应的值 T=类型, V=字段名, C=copy, 自行测试  //参考ExampleCode
        const char *value = property_copyAttributeValue(class_getProperty([self class], [name UTF8String]), "T");
        NSLog(@"==  %s", value);
        
        /*
         
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
         
         */
        
        [ay addObject:name];
    }
    return ay;
}

- (NSArray *)runtimeIvars;
{
    NSMutableArray *ay = [NSMutableArray array];
    
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
//        NSString *encoding = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        [ay addObject:[NSString stringWithUTF8String:ivar_getName(ivars[i])]];
    }
    return ay;
}

- (NSArray *)runtimeInstanceMethodList;
{
    NSMutableArray *ay = [NSMutableArray array];
    
    unsigned int outCount = 0;
    Method *methds = class_copyMethodList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        [ay addObject:NSStringFromSelector(method_getName(methds[i]))];
    }
    return ay;
}

- (NSArray *)runtimeClassMethodList;
{
    NSMutableArray *ay = [NSMutableArray array];
    
    unsigned int outCount = 0;
    Method *methds = class_copyMethodList([objc_getMetaClass([[[self class] description] UTF8String]) class], &outCount);
    for (int i = 0; i < outCount; i++) {
        [ay addObject:NSStringFromSelector(method_getName(methds[i]))];
    }
    return ay;
}



- (NSArray *)runtimeGetProtocols;
{
    NSMutableArray *ay = [NSMutableArray array];
    
    unsigned int outCount = 0;
    Protocol * __unsafe_unretained *protocols = class_copyProtocolList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        Protocol *protocol = protocols[i];
//        NSString *name = [NSString stringWithUTF8String:protocol_getName(protocol)];
        [ay addObject:protocol];
    };
    return ay;
}

- (NSArray *)runtimeGetProtocolsWithProtocol:(Protocol *)protocol;
{
    NSMutableArray *ay = [NSMutableArray array];

    unsigned int outCount = 0;
    Protocol * __unsafe_unretained *protocols = protocol_copyProtocolList(protocol, &outCount);
    for (int i = 0; i < outCount; i++) {
        Protocol *protocol = protocols[i];
//        NSString *name = [NSString stringWithUTF8String:protocol_getName(protocol)];
        [ay addObject:protocol];
    }
    return ay;
}

- (NSArray *)runtimeGetPropertiesWithProtocol:(Protocol *)protocol;
{
    NSMutableArray *ay = [NSMutableArray array];
    
    unsigned int outCount = 0;
    objc_property_t *properties = protocol_copyPropertyList(protocol, &outCount);
    for (int i = 0; i < outCount; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
//        NSLog(@"protocol name:%@", name);
        [ay addObject:name];
    }
    return ay;
}

- (NSArray *)runtimeGetMethodsWithProtocol:(Protocol *)protocol
                          isRequiredMethod:(BOOL)isRequiredMethod
                          isInstanceMethod:(BOOL)isInstanceMethod;
{
    NSMutableArray *ay = [NSMutableArray array];
    
    unsigned int outCount = 0;
    struct objc_method_description *list = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &outCount);
    for (int i = 0; i < outCount; i++) {
        struct objc_method_description method = list[i];
//        NSLog(@"protocol name:%@", NSStringFromSelector(method.name));
        [ay addObject:NSStringFromSelector(method.name)];
    }
    return ay;
}



- (NSArray *)runtimeGetAllFrameworks;
{
    NSMutableArray *ay = [NSMutableArray array];
    
    unsigned int outCount = 0;
    const char **arr = objc_copyImageNames(&outCount);
    for (int i = 0; i < outCount; i++) {
        NSString *name = [NSString stringWithUTF8String:arr[i]];
//        NSLog(@"framework name: %s", arr[i]);
        [ay addObject:name];
    }
    return ay;
}

- (NSArray *)runtimeGetAllClassFromWithFrameworks:(const char *)image;
{
    NSMutableArray *ay = [NSMutableArray array];
    
    unsigned int outCount = 0;
    const char **arr_classes = objc_copyClassNamesForImage(image, &outCount);
    for (int i = 0; i < outCount; i++) {
        NSString *name = [NSString stringWithUTF8String:arr_classes[i]];
//        NSLog(@"framework name: %s", arr_classes[i]);
        [ay addObject:name];
    }
    return ay;
}


@end
