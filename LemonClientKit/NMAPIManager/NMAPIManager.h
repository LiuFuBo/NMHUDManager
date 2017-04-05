//
//  NMAPIManager.h
//  Demo
//
//  Created by  刘富波 on 2017/3/6.
//  Copyright © 2017年 mac1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMAPIManager : NSObject

+ (__kindof NMAPIManager *)manager;

/// debug才会显示的调试窗口
- (void)showDebugWindow;
/// 隐藏debug调试窗口
- (void)hideDebugWindow;

///配置请求的域名
@property (nonatomic,readonly) NMAPIManager *(^configureDomain)(NSString *domain);

/**
 配置请求的地址（域名后面的。
 */
@property (nonatomic,readonly) NMAPIManager *(^configureURI)(NSString *uri);

///配置调用的serviceKey
@property (nonatomic,readonly) NMAPIManager *(^configureServiceKey)(NSString *serviceKey);

///设置clientKey，会自动添加到requestHeaderFields属性里
@property (nonatomic,readonly) NMAPIManager *(^configureClientKey)(NSString *clientKey);
///设置accessToken，会自动添加到requestHeaderFields属性里
@property (nonatomic,readonly) NMAPIManager *(^configureAccessToken)(NSString *accessToken);

///往requestHeaderFields添加值，第一个参数key（请求头的key），第二个参数value（请求头的value）
@property (nonatomic,readonly) NMAPIManager *(^addRequestHeaderField)(NSString *key,NSString *value);

///获取请求头
@property (nonatomic,readonly) NSDictionary *requestHeaderFields;

/**
 URL:domian+URI
 domian域名通过调用configureDomain函数配置，URI通过调用configureURI函数配置
 示例：
    URI：/api/test/login
    域名为：www.baidu.com
 URL return：www.baidu.com/api/test/login
 */
@property (nonatomic,readonly) NSString *requestURL;

///获取当前的serviceKey
@property (nonatomic,readonly) NSString *serviceKey;

@end
