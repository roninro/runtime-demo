//
//  ViewController+Swizzling.m
//  use-the-runtime
//
//  Copyright © 2017年 mervin. All rights reserved.
//

#import "ViewController+Swizzling.h"
#import "YJSwizzle.h"

@implementation ViewController (Swizzling)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        YJSwizzleMethod([self class],
                        @selector(viewWillDisappear:),
                        @selector(xxx_viewWillDisappear:));
    });
}


- (void)xxx_viewWillDisappear:(BOOL)animated {
    [self xxx_viewWillDisappear:animated];
    NSLog(@"xxx_viewWillDisappear: %@",self);
}

@end
