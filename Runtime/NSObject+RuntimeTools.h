//
//  NSObject+RuntimeTools.h
//  Runtime
//
//  Created by Johnson on 2017/5/15.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RuntimeTools)
- (NSArray *)runtimeProperties;

- (NSArray *)runtimeIvars;

- (NSArray *)runtimeInstanceMethodList;

- (NSArray *)runtimeClassMethodList;


- (NSArray *)runtimeGetProtocols;

- (NSArray *)runtimeGetProtocolsWithProtocol:(Protocol *)protocol;

- (NSArray *)runtimeGetPropertiesWithProtocol:(Protocol *)protocol;

- (NSArray *)runtimeGetMethodsWithProtocol:(Protocol *)protocol
                          isRequiredMethod:(BOOL)isRequiredMethod
                          isInstanceMethod:(BOOL)isInstanceMethod;


- (NSArray *)runtimeGetAllFrameworks;

- (NSArray *)runtimeGetAllClassFromWithFrameworks:(const char *)image;



@end
