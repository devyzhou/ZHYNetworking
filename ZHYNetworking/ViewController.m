//
//  ViewController.m
//  ZHYNetworking
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ViewController.h"
#import "ZHYAPIProxy.h"
#import "ZHYServiceTest.h"
#import "PostAPIManager.h"

@interface ViewController ()

@property (strong, nonatomic) PostAPIManager *postApiManager;

@property (strong, nonatomic) UIButton *refreshButton;

@end

@implementation ViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.refreshButton];
    [self loadData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - even response

- (void)refresh{
    if ([self.postApiManager isLoading]) {
        NSLog(@"ok");
        return;
    }
    [self loadData];
}

- (void)loadData{
    self.postApiManager = [[PostAPIManager alloc] init];
    [self.postApiManager loadDataCompleteHandle:^(ZHYAPIBaseManager *manager, id responseData, ZHYAPIManagerErrorType errorType) {
        
    }];
//    [self.postApiManager loadDataWithParams:@{} CompleteHandle:^(ZHYAPIBaseManager *manager, id responseData, ZHYAPIManagerErrorType errorType) {
//        //NSLog(@"%@",responseData);
//    }];
}

#pragma mark - get & set

- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_refreshButton setFrame:CGRectMake(200, 200, 100, 40)];
        [_refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
        [_refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

@end
