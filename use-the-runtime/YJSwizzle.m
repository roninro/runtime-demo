//
//  YJSwizzle.m
//  use-the-runtime
//
//  Created by mervin on 2017/5/16.
//  Copyright © 2017年 mervin. All rights reserved.
//

#import "YJSwizzle.h"
#import <objc/runtime.h>

void YJSwizzleMethod(Class cls, SEL originalSeletor, SEL swizzledSeletor) {
    
    Method originalMethod = class_getInstanceMethod(cls, originalSeletor);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSeletor);
    
    BOOL didAddMethod = class_addMethod(cls,
                                        originalSeletor,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls,
                            swizzledSeletor,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
