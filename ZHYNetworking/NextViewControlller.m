//
//  NextViewControlller.m
//  ZHYNetworking
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "NextViewControlller.h"
#import "PostAPIManager.h"

@interface NextViewControlller ()

@property (strong, nonatomic) PostAPIManager *postApiManager;

@end

@implementation NextViewControlller

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.postApiManager loadDataWithParams:@{} CompleteHandle:^(ZHYAPIBaseManager *manager, id responseData, ZHYAPIManagerErrorType errorType) {
        NSLog(@"%@",responseData);
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.postApiManager cancelAllRequests];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - get & set

- (PostAPIManager *)postApiManager{
    if (!_postApiManager) {
        _postApiManager = [[PostAPIManager alloc] init];
    }
    return _postApiManager;
}

@end
