//
//  ViewController.m
//  use-the-runtime
//
//  Copyright © 2017年 mervin. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import "YJPerson.h"
#import "YJAlertViewController.h"
#import "YJNextViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *methodArray;

@end

@implementation ViewController

-(instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _titleArray = [[NSMutableArray alloc] init];
    _methodArray = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"runtime的使用";
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    _tableView.frame = self.view.bounds;
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _tableView.scrollIndicatorInsets = self.tableView.contentInset;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
    
    [self addCellWithTitle:@"Method Swizzling" Method:@"swizzling"];
    [self addCellWithTitle:@"properties-ivars-methods" Method:@"attributes"];
    [self addCellWithTitle:@"encodeObjc" Method:@"encodeObjc"];
    [self addCellWithTitle:@"Associate Demo" Method:@"showAlert"];
    
    
}

- (void) addCellWithTitle:(NSString *)title Method:(NSString *)method {
    [_titleArray addObject:title];
    [_methodArray addObject:method];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SEL method = NSSelectorFromString(_methodArray[indexPath.row]);
    if ([self respondsToSelector:method]) {
        ((void (*)(id, SEL))objc_msgSend)(self, method);
    }
}

#pragma mark - Methods

- (void)swizzling {
    NSLog(@"see ViewController+Swizzling load Method");
    [self.navigationController pushViewController:[YJNextViewController new] animated:YES];
}

- (void)attributes {
    YJPerson *person = [[YJPerson alloc] initWithName:@"Nacy" Age:24];
    [person setValue:@"private_nano--" forKey:@"private_nano"];

    NSDictionary *pIvars = [person allIvars];
    NSDictionary *pProperties =[person allProperties];
    NSDictionary *pMethods = [person allMethods];
    NSLog(@"%@", pIvars);
    NSLog(@"%@", pProperties);
    NSLog(@"%@", pMethods);
}

- (void)encodeObjc {
    NSString *archivePath = ArchivePath();
    YJPerson *aP = [[YJPerson alloc] initWithName:@"Lily" Age:23];
    
    [NSKeyedArchiver archiveRootObject:aP toFile:archivePath];
    id person = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    NSLog(@"%@\ncode in Person.m",person);
}

- (void)showAlert {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    YJAlertViewController *altVC = [sb instantiateViewControllerWithIdentifier:@"alertViewController"];
    [self.navigationController pushViewController:altVC animated:YES];
}


@end
