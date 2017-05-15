//
//  TestMsgForward.m
//  Runtime
//
//  Created by Johnson on 2017/5/10.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "TestMsgForward.h"

@interface TT : NSObject

//- (void)xx;
//+ (void)xx;

@end

@implementation TT
//- (void)xx;
//{
//    
//}
//+ (void)xx;
//{
//
//}
@end


@interface BB : TT
@property (nonatomic, assign) int b;
@end

@implementation BB
- (int)b
{
    NSLog(@"调用AA的b实例方法失败, 进而对BB的实例方法b进行签名调用");
    return 55;
}

- (void)abc
{
    NSLog(@"随意输出");
}



+ (void)aa
{
//    [[super new] xx];
//    [super xx];
//    
//    [self xx];
//    [[self new] xx];
    
    [self methodSignatureForSelector:nil];
    
//    [super methodForSelector:nil];
    
    NSLog(@"调用AA的类方法aa失败, 进而对BB的类方法aa进行签名调用");
}

@end


@interface AA : NSObject
@property (nonatomic, assign) int a;
@property (nonatomic, assign) int b;

+ (void)aa;
@end

@implementation AA
@dynamic b;

+ (id)forwardingTargetForSelector:(SEL)aSelector;
{
    return [BB class];  //注意这个地方类方法的调用  返回class对象
}


+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (aSelector == @selector(aa)) {
        NSMethodSignature *signature = [NSObject methodSignatureForSelector:@selector(description)];
        
        return signature;
    }
    
    return [super methodSignatureForSelector:aSelector];
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation invokeWithTarget:[BB class]];
}

+ (void)doesNotRecognizeSelector:(SEL)aSelector
{
    [super doesNotRecognizeSelector:aSelector];
}




- (id)forwardingTargetForSelector:(SEL)aSelector;
{
//    return nil;  //继续后续转发. 等于没有实现该方法
//    return [NSObject new]; //报错, 因为NSObject并没有实例方法b
    return [BB new];  //不再进行后续的转发.
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (aSelector == @selector(b)) {
        
        //此处貌似只需要在异常的时候返回一个不为空的签名即可. 照样会执行转发方法.   如果类没有对应的selector, 会返回nil;
//        return [NSMethodSignature signatureWithObjCTypes:[@"v@:@" UTF8String]];
        NSMethodSignature *signature = [[BB new] methodSignatureForSelector:@selector(b)];
        NSInvocation *anInvocation = [NSInvocation invocationWithMethodSignature:signature];
        
        return signature;
    }
    
    return [super methodSignatureForSelector:aSelector] ;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    
    //此方法不重写, 及时上面的方法返回一个正常的签名, 也会执行doesNotRecognizeSelector;
    //重写之后执行[super forwardInvocation:]照样会执行doesNotRecognizeSelector;  其实和上面是一个问题, 不能调用super.
    
    //上面返回一个正常签名, 即时此方法不写任何内容, 也不会报错;
    //[anInvocation invokeWithTarget:instance]; 意思是在instance中调用anInvocation对应selector, 如果instance没有对应的selector会报错, 所以最好和上面的签名方法中的selector保持一致, 并且保证instance有对应的selector实现
    
    //anInvocation.selector 为最开始发送异常时的selector, 不是可以和上面签名selector不一致;
    
//    [super forwardInvocation:anInvocation];
    [anInvocation invokeWithTarget:[BB new]];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    [super doesNotRecognizeSelector:aSelector];
}

@end





@implementation TestMsgForward

/**
 消息转发 如果找不到IMP, 则调用下面第一个方法抛出异常, 而在第一个方法调用之前会先调用第二个方法
 methodSignatureForSelector能为另一个类添加方法签名, 并返回该签名. 
 如果签名为nil, 则执行doesNotRecognizeSelector抛出异常, 不为空则执行forwardInvocation.
 
 
 实例方法
 - (void)doesNotRecognizeSelector:(SEL)aSelector;
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
 - (void)forwardInvocation:(NSInvocation *)anInvocation;
 
 类方法  值得注意的是, NSObject好像没有公开这几个方法
 + (void)doesNotRecognizeSelector:(SEL)aSelector;
 + (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
 + (void)forwardInvocation:(NSInvocation *)anInvocation;
 + (id)forwardingTargetForSelector:(SEL)aSelector;
 
 
 下面这个函数会methodSignatureForSelector调用之前调用, 如果为nil继续后续处理, 不为空则直接终止. 需要注意的是此处返回的对象必须实现对应的selector, 否则报错. 也不能返回当前对象 否则进入死循环.
 - (id)forwardingTargetForSelector:(SEL)aSelector;
 */


- (void)test
{
    [[AA new] performSelector:@selector(a)];
    [[AA new] performSelector:@selector(b)];
    
    
    [AA aa];
}

@end
