//
//  YJNextViewController.m
//  use-the-runtime
//
//  Created by mervin on 2017/5/15.
//  Copyright © 2017年 mervin. All rights reserved.
//

#import "YJNextViewController.h"

@interface YJNextViewController ()

@end

@implementation YJNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(pushToNextViewController)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushToNextViewController {
    
    
}


@end
