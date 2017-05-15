//
//  Son.h
//  Runtime
//
//  Created by Johnson on 2017/5/15.
//  Copyright © 2017年 Johnson. All rights reserved.
//

#import "Father.h"
#import <UIKit/UIKit.h>

@protocol TestDelegate;

@interface Father() <TestDelegate>
@property (nonatomic, strong) NSArray *datasourse4;
@end

@interface Son : Father <NSObject, UITableViewDataSource, TestDelegate>

@end



@protocol TestDelegate <NSObject, UITextFieldDelegate>

@required

@property (nonatomic, copy) NSDictionary *dictionary;

+ (void)classHello;
- (void)instanceHello;

@optional

@property (nonatomic, copy) NSDictionary *dictionaryOptional;

+ (void)classHelloOptional;
- (void)instanceHelloOptional;


@end
