//
//  ViewController+Swizzling.m
//  use-the-runtime
//
//  Copyright © 2017年 mervin. All rights reserved.
//

#import "ViewController+Swizzling.h"
#import <objc/runtime.h>

@implementation ViewController (Swizzling)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSEL = @selector(viewWillDisappear:);
        SEL swizzledSEL = @selector(xxx_viewWillDisappear:);
        
        Method originMethod = class_getInstanceMethod(class, originalSEL);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
        
        BOOL addMethod = class_addMethod(class, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (addMethod) {
            class_replaceMethod(class, swizzledSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        }
        else {
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}


- (void)xxx_viewWillDisappear:(BOOL)animated {
    [self xxx_viewWillDisappear:animated];
    NSLog(@"xxx_viewWillDisappear: %@",self);
}

@end
