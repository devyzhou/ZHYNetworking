//
//  ZHYAPIProxy.m
//  ZHYNetworking
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYAPIProxy.h"
#import "AFNetworking.h"
#import "ZHYRequestGenerator.h"
#import "ZHYURLResponse.h"

@interface ZHYAPIProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (strong, nonatomic) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) NSNumber *recordedRequestId;

@end

@implementation ZHYAPIProxy

#pragma mark - life cycle
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ZHYAPIProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZHYAPIProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName completionHandler:(void (^)(ZHYURLResponse *, NSError *))completionHandler{
    NSURLRequest *request = [[ZHYRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSLog(@"\n=================requestURL==================\n%@\n\n",request.URL);
    NSNumber *requestId = [self callApiWithRequest:request completionHandler:completionHandler];
    return [requestId integerValue];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID{
    NSURLSessionDataTask *urlSessionDataTask = self.dispatchTable[requestID];
    [urlSessionDataTask cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}
#pragma mark - private methods

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request completionHandler:(void (^)(ZHYURLResponse *, NSError *))completionHandler{
    // 之所以不用getter，是因为如果放到getter里面的话，每次调用self.recordedRequestId的时候值就都变了，违背了getter的初衷
    NSNumber *requestId = [self generateRequestId];
    
    NSURLSessionDataTask *urlSessionDataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:
    ^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!self.dispatchTable[requestId]) {
            return ;
        }else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        ZHYURLResponse *URLResponse = [[ZHYURLResponse alloc] initWithRequestId:requestId
                                                                   responseData:responseObject error:error];
        completionHandler?completionHandler(URLResponse,error):nil;
    }];
    self.dispatchTable[requestId] = urlSessionDataTask;
    [urlSessionDataTask resume];
    return requestId;
}



#pragma mark - get & set

- (AFURLSessionManager *)sessionManager{
    if (!_sessionManager) {
        _sessionManager = [[AFURLSessionManager alloc] init];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //_sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _sessionManager;
}

- (NSNumber *)generateRequestId{
    if (!_recordedRequestId) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

- (NSMutableDictionary *)dispatchTable{
    if (!_dispatchTable) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

@end
