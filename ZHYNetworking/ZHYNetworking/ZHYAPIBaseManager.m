
//
//  ZHYAPIBaseManager.m
//  ZHYNetworking
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "ZHYAPIBaseManager.h"
#import "ZHYNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "ZHYAPIProxy.h"

@interface ZHYAPIBaseManager ()

@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, readwrite) ZHYAPIManagerErrorType errorType;

@end

@implementation ZHYAPIBaseManager

#pragma mark - life cycle

- (instancetype)init{
    self = [super init];
    if (self) {
        _paramSource = nil;
    
        if ([self conformsToProtocol:@protocol(ZHYAPIManager)]) {
            self.child = (id <ZHYAPIManager>)self;
        }
    }
    return self;
}

- (void)dealloc{
    [self cancelAllRequests];
    self.requestIdList = nil;
}


#pragma mark - public methods

- (void)cancelAllRequests{
    [[ZHYAPIProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID{
    [self removeRequestIdWithRequestID:requestID];
    [[ZHYAPIProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (NSInteger)loadDataCompleteHandle:(void (^)(ZHYAPIBaseManager *,id ,ZHYAPIManagerErrorType ))completeHandle{
    return [self loadDataWithParams:[self.paramSource paramsForApi:self] CompleteHandle:completeHandle];
}

#pragma mark - private methods

- (void)removeRequestIdWithRequestID:(NSInteger)requestId{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

#pragma mark - calling api

- (NSInteger)loadDataWithParams:(NSDictionary *)params
                 CompleteHandle:(void (^)(ZHYAPIBaseManager *, id, ZHYAPIManagerErrorType))completeHandle{
    NSInteger requestId = 0;
    
    if ([self isReachable]) {
        switch ([self.child requestType]) {
            case ZHYAPIManagerRequestTypeGet:{
                requestId = [[ZHYAPIProxy sharedInstance] callGETWithParams:params serviceIdentifier:self.child.serviceType methodName:self.child.methodName completionHandler:^(ZHYURLResponse *response, NSError *error) {
                    [self removeRequestIdWithRequestID:response.requestId];
                    if (!error) {
                          if (completeHandle){
                              completeHandle(self, response.content, ZHYAPIManagerErrorTypeSuccess);
                          }
                      }else{
                          if (completeHandle){
                            completeHandle(self, nil, ZHYAPIManagerErrorTypeNoNetWork);
                          }
                      }
                  }];
                break;
            }
            case ZHYAPIManagerRequestTypePost:{
                
                break;
            }
            default:{
                break;
            }
        }
    }else{
        if (completeHandle){
            completeHandle(self,nil,ZHYAPIManagerErrorTypeNoNetWork);
        }
    }
    
    [self.requestIdList addObject:@(requestId)];
    return requestId;
}


#pragma mark - get & set

- (BOOL)isReachable{
    BOOL isReachability;
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        isReachability = YES;
    } else {
        isReachability = [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
    if (!isReachability) {
        self.errorType = ZHYAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (NSMutableArray *)requestIdList{
    if (!_requestIdList) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isLoading{
    return [self.requestIdList count] > 0;
}


@end
