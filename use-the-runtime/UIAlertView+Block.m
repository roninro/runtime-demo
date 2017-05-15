//
//  UIAlertView+Block.m
//  use-the-runtime
//
//  Created by mervin on 2017/5/15.
//  Copyright © 2017年 mervin. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

static const void *SelectBlock = &SelectBlock;

@interface UIAlertView()<UIAlertViewDelegate>

@end

@implementation UIAlertView (Block)

- (void)setSelectBlock:(UIAlertViewSelectBlock)selectBlock {
    objc_setAssociatedObject(self, SelectBlock, selectBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIAlertViewSelectBlock)selectBlock {
    return objc_getAssociatedObject(self, SelectBlock);
}

+ (instancetype) alertWithTitle:(NSString *)title
                        message:(NSString *)message
                    buttonIndex:(UIAlertViewSelectBlock)tapBlock
              cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitles,nil];
    
    va_list args;
    va_start(args, otherButtonTitles);
    
    NSString *otherString;
    while((otherString = va_arg(args, NSString *))){
        [alert addButtonWithTitle:otherString];
    }
    va_end(args);
    
    alert.selectBlock = tapBlock;
    
    alert.delegate = alert;
    
    return alert;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.selectBlock) {
        self.selectBlock(buttonIndex);
    }
}

//- (void)dealloc {
//    NSLog(@"delloc_block alert");
//}

@end
