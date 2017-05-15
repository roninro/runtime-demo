
#import "YJAlertViewController.h"
#import <objc/runtime.h>
#import "UIAlertView+Block.h"

static const void *AlertBlock = &AlertBlock;

@interface YJAlertViewController ()<UIAlertViewDelegate>

@end

@implementation YJAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}


- (IBAction)alertUseDelegate:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"talk is cheap" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"butn0",@"butn1", nil];
    alert.tag = 101;
    void (^block)(NSInteger index) = ^(NSInteger index){
        NSLog(@"associated block index:: %ld", index);
    };
    
    objc_setAssociatedObject(alert, AlertBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [alert show];
}
// ----->>>>>>>>

- (IBAction)alertUseBlock:(id)sender {
    
    [[UIAlertView alertWithTitle:@"+Block" message:@"show me the code" buttonIndex:^(NSInteger index) {
        NSLog(@"block++:: %ld", index);
    } cancelButtonTitle:@"取消" otherButtonTitles:@"B1",@"B2",nil] show];
}

#pragma mark - UIAlertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 101) {
        
        void (^block)(NSInteger index) = objc_getAssociatedObject(alertView, AlertBlock);
        
        block(buttonIndex);
        
    }
}



@end
