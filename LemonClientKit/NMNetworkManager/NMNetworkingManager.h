//
//  NMNetworkManager.h
//  NMSaleAPP
//
//  Created by 刘富波 on 2016/10/20.
//  Copyright © 2016年 mac1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NMNetworkingManager;
@protocol NMNetworkAPIDelegate <NSObject>

@required

///配置接口的请求地址
- (NSString *)networkURL:(NMNetworkingManager *)manager;

///调用某一个api的配置，底层会把这个配置包装在参数里
- (NSString *)networkAPIAtParamsConfigure:(NMNetworkingManager *)manager;

///配置服务器的serviceKey
- (NSString *)networkServiceKeyConfigure:(NMNetworkingManager *)manager;

@optional

/**
 配置请求的in参数，会自动在参数里加上in[]，比如username，内部自动就变成了in[username]
 所以在配置在参数的时候，不需要加上in[]，
 示例（直接按照以下格式配置即可）：
   return @{@"username":@"admin",@"password":@"123456"}
 在内部会自动变成:
    @{@"in[username]":@"admin",@"in[password]":@"123456"}
 */
- (NSDictionary *)networkInParameters:(NMNetworkingManager *)manager;

///baseurl的配置，用于调试后台的本地电脑
- (NSString *)networkBasePathConfigure:(NMNetworkingManager *)manager;

///配置请求头
- (NSDictionary *)networkHeaderFields:(NMNetworkingManager *)manager;

@end


@interface NMNetworkingManager : NSObject

+ (__kindof NMNetworkingManager *)manager;

/**
 post 请求

 @param url url地址
 @param timeoutInterval 超时时间，defaultTimeoutInterval属性在内部不生效。
 @param parameters parameters description
 @param finished call-back
 @return session data task
 */
+ (NSURLSessionDataTask *)postWithUrlString:(NSString *)url timeoutInterval:(NSTimeInterval)timeoutInterval parameters:(NSDictionary *)parameters finished:(void(^)(NSURLResponse *response,id responseObject,NSError *error))finished;

/**
 post 请求

 @param url url地址
 @param parameters 参数，会自动给参数加上in[],比如参数username则内部自动变成了in[username]
 @param finished call-back
 @return session data task
 */
+ (NSURLSessionDataTask *)postWithUrlString:(NSString *)url inParameters:(NSDictionary *)parameters finished:(void(^)(NSURLResponse *response,id responseObject,NSError *error))finished;

/**
 post 请求

 @param apiObject 需要NMNetworkAPIDelegate协议，信息在协议里配置
 @param finished call-back
 @return session data task
 */
+ (NSURLSessionDataTask *)postWithAPIObject:(id<NMNetworkAPIDelegate>)apiObject finished:(void(^)(NSURLResponse *response,id responseObject,NSError *error))finished;

///设置请求头
@property (nonatomic,readonly) NMNetworkingManager *(^setHeaderFields)(NSDictionary<NSString *,NSString *> *dict);

///全局超时时间
@property (nonatomic,readonly) NMNetworkingManager *(^setDefaultTimeoutInterval)(NSTimeInterval timeInterval);

///默认超时时间 is 0 ,可以通过setDefaultTimeoutInterval设置全局的默认超时时间
@property (nonatomic,readonly) NSTimeInterval defaultTimeoutInterval;

///请求头
@property (nonatomic,readonly) NSDictionary<NSString *,NSString *> *headerFields;

@end
