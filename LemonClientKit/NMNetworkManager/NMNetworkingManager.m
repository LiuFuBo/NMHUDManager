//
//  NMNetworkManager.m
//  NMSaleAPP
//
//  Created by 刘富波 on 2016/10/20.
//  Copyright © 2016年 mac1. All rights reserved.
//

#import "NMNetworkingManager.h"
#import "AFNetworking.h"
#import "NMURLJSONResponseSerializer.h"

#define NMNetworkingManagerReturn(_property,_value) autoreleasepool { } \
return ({ \
NMNetworkingManager *manager = [NMNetworkingManager manager]; \
manager->_property = _value; \
manager; \
});

@interface NMNetworkingManager ()

@end

@implementation NMNetworkingManager
@synthesize defaultTimeoutInterval = _defaultTimeoutInterval,
headerFields = _headerFields;

#pragma mark public -> class method

+ (NMNetworkingManager *)manager {
    static dispatch_once_t onceToken;
    static NMNetworkingManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [NMNetworkingManager new];
    });
    return manager;
}

+ (NSURLSessionDataTask *)postWithUrlString:(NSString *)urlString timeoutInterval:(NSTimeInterval)timeoutInterval parameters:(NSDictionary *)parameters finished:(void (^)(NSURLResponse *, id, NSError *))finished {
    
    AFHTTPRequestSerializer *request = [AFHTTPRequestSerializer serializer];
    request.timeoutInterval = timeoutInterval;
    [[self manager].headerFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    NMURLJSONResponseSerializer *response = [NMURLJSONResponseSerializer serializer];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    sessionManager.requestSerializer = request;
    sessionManager.responseSerializer = response;
    
    __weak typeof(response) weak_response = response;
    return [sessionManager POST:urlString parameters:[parameters copy] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finished?finished(task.response,responseObject,nil):NULL;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong typeof(weak_response) strong_response = weak_response;
        finished?finished(task.response,strong_response.responseObject,error):NULL;
    }];
}

+ (NSURLSessionDataTask *)postWithAPIObject:(id<NMNetworkAPIDelegate>)apiObject finished:(void (^)(NSURLResponse *, id, NSError *))finished {
    
    NSAssert([apiObject conformsToProtocol:@protocol(NMNetworkAPIDelegate)],@"%@未实现NMNetworkAPIDelegate协议",[apiObject class]);
    
    NSArray<NSString *> *selectors = @[
                                       NSStringFromSelector(@selector(networkURL:)),
                                       NSStringFromSelector(@selector(networkAPIAtParamsConfigure:)),
                                       NSStringFromSelector(@selector(networkServiceKeyConfigure:)),
                                       ];
    [selectors enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert([apiObject respondsToSelector:NSSelectorFromString(obj)],@"%@未实现%@方法",[apiObject class],obj);
    }];
    
    NMNetworkingManager *manager = [NMNetworkingManager manager];
    
    //参数-----------
    
    //必须
    NSString *url = [apiObject networkURL:manager];
    NSString *apiConfigure = [apiObject networkAPIAtParamsConfigure:manager];
    NSString *serviceKey = [apiObject networkServiceKeyConfigure:manager];
    
    //可选
    NSString *basePath = @"";
    if ([apiObject respondsToSelector:@selector(networkBasePathConfigure:)]) {
        basePath = [apiObject networkBasePathConfigure:manager];
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([apiObject respondsToSelector:@selector(networkInParameters:)]) {
        parameters = [[apiObject networkInParameters:manager] mutableCopy];
    }
    
#ifdef DEBUG
    if (basePath.length) {
        NSLog(@"%@-basePath:%@",[apiObject class],basePath);
        [parameters setObject:basePath forKey:@"basePath"];
    }
#endif
    
    [parameters setObject:apiConfigure forKey:@"api"];
    [parameters setObject:serviceKey forKey:@"serviceKey"];
    
    //请求头-------------
    manager.setHeaderFields([apiObject networkHeaderFields:manager]);
    
    return [self postWithUrlString:url inParameters:parameters finished:finished];
}

+ (NSURLSessionDataTask *)postWithUrlString:(NSString *)url inParameters:(NSDictionary *)parameters finished:(void (^)(NSURLResponse *, id, NSError *))finished {
    NSMutableDictionary *inParameters = [NSMutableDictionary dictionary];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [inParameters setObject:obj forKey:[NSString stringWithFormat:@"in[%@]",key]];
    }];
    return [self postWithUrlString:url timeoutInterval:[self manager].defaultTimeoutInterval parameters:[inParameters copy] finished:finished];
}

#pragma mark getters

- (NMNetworkingManager *(^)(NSTimeInterval))setDefaultTimeoutInterval {
    return ^NMNetworkingManager *(NSTimeInterval timeInterval) {
        return ({
            _defaultTimeoutInterval = timeInterval;
            self;
        });
    };
}

- (NMNetworkingManager *(^)(NSDictionary<NSString *,NSString *> *))setHeaderFields {
    return ^NMNetworkingManager *(NSDictionary<NSString *,NSString *> *dict) {
        return ({
            _headerFields = dict;
            self;
        });
    };
}

@end

