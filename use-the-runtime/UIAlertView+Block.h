//
//  UIAlertView+Block.h
//  use-the-runtime
//
//  Created by mervin on 2017/5/15.
//  Copyright © 2017年 mervin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewSelectBlock) (NSInteger index);

@interface UIAlertView (Block)

+ (instancetype) alertWithTitle:(NSString *)title
                        message:(NSString *)message
                    buttonIndex:(UIAlertViewSelectBlock)tapBlock
              cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
