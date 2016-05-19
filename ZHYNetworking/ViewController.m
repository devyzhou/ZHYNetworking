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

@end

@implementation ViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.postApiManager loadDataWithParams:@{} CompleteHandle:^(ZHYAPIBaseManager *manager, id responseData, ZHYAPIManagerErrorType errorType) {
        NSLog(@"%@",responseData);
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get & set

- (PostAPIManager *)postApiManager{
    if (!_postApiManager) {
        _postApiManager = [[PostAPIManager alloc] init];
    }
    return _postApiManager;
}


@end
