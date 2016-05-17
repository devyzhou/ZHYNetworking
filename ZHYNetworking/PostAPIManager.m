//
//  PostAPIManager.m
//  ZHYNetworking
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "PostAPIManager.h"
#import "ZHYServiceTest.h"

@implementation PostAPIManager

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}


- (NSString *)serviceType{
    return NSStringFromClass([ZHYServiceTest class]);
}

- (NSString *)methodName{
    return @"stream/0/posts/stream/global";
}

- (ZHYAPIManagerRequestType)requestType{
    return ZHYAPIManagerRequestTypeGet;
}


@end
