//
//  YJSwizzle.h
//  use-the-runtime
//
//  Created by mervin on 2017/5/16.
//  Copyright © 2017年 mervin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void YJSwizzleMethod(Class cls, SEL originalSeletor, SEL swizzledSeletor);
