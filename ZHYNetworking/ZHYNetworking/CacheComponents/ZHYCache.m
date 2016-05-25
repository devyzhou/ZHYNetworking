//
//  ZHYCache.m
//  ZHYNetworking
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYCache.h"
#import "ZHYNetworkingConfiguration.h"

@interface ZHYCache()

@property (strong, nonatomic) NSCache *cache;

@end


@implementation ZHYCache

#pragma mark - life cycle

+ (instancetype)sharedInstance{
    static ZHYCache *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZHYCache alloc] init];
    });
    return sharedInstance;
}


#pragma mark - get & set

- (NSCache *)cache{
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = kZHYCacheCountLimit;
    }
    return _cache;
}

@end
