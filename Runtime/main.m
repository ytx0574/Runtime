//
//  main.m
//  Runtime
//
//  Created by Johnson on 5/18/15.
//  Copyright (c) 2015 Johnson. All rights reserved.
//

#import "Runtime.h"
#import "Test.h"
#import "TestMsgForward.h"

int main(int argc, char * argv[]) {
    
    [[Runtime new] test];
    [[Test new] test];
    [[TestMsgForward new] test];
    
    return 0;
}
