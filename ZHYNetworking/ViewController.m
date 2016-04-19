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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[ZHYAPIProxy sharedInstance] callGETWithParams:nil
                                  serviceIdentifier:NSStringFromClass([ZHYServiceTest class])
                                         methodName:@"stream/0/posts/stream/global"
                                  completionHandler:^(ZHYURLResponse *urlresponse, NSError *error) {
         
                                      NSLog(@"%@",urlresponse.content);
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
