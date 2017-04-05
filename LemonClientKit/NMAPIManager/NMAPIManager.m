//
//  NMAPIManager.m
//  Demo
//
//  Created by 刘富波 on 2017/3/6.
//  Copyright © 2017年 mac1. All rights reserved.
//

#import "NMAPIManager.h"
@import UIKit;

@interface NMAPIManager ()

@property (nonatomic,copy) NSDictionary *requestHeaderFields;

@property (nonatomic,copy) NSString *domain;
@property (nonatomic,copy) NSString *URI;
@property (nonatomic,copy) NSString *serviceKey;

@property (nonatomic,strong) UIView *bgViewAtDebugWindow;
@property (nonatomic,strong) UITextField *domainTextField;
@property (nonatomic,strong) UITextField *uriTextField;

@end

@implementation NMAPIManager

+ (NMAPIManager *)manager {
    static dispatch_once_t onceToken;
    static NMAPIManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [NMAPIManager new];
    });
    return manager;
}

- (void)hideDebugWindow {
    [self.bgViewAtDebugWindow removeFromSuperview];
    self.bgViewAtDebugWindow = nil;
}

- (void)showDebugWindow {
#ifdef DEBUG
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:bgView];
    bgView.frame = window.frame;
    self.bgViewAtDebugWindow = bgView;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancelButton.frame = CGRectMake(20, 20, 60, 40);
    [bgView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(p_cancelDebugWindowAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setTitle:@"ok" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    okButton.frame = CGRectMake(120, 20, 60, 40);
    [bgView addSubview:okButton];
    [okButton addTarget:self action:@selector(p_confirmDebugWindowAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField *domainTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 200, 40)];
    domainTextField.text = self.domain;
    domainTextField.borderStyle = UITextBorderStyleRoundedRect;
    domainTextField.placeholder = @"请输入请求的域名";
    [bgView addSubview:domainTextField];
    self.domainTextField = domainTextField;
    
    UITextField *uriTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(domainTextField.frame) + 20, 200, 40)];
    uriTextField.text = self.URI;
    uriTextField.borderStyle = UITextBorderStyleRoundedRect;
    uriTextField.placeholder = @"请输入请求的URI";
    [bgView addSubview:uriTextField];
    self.uriTextField = uriTextField;
#endif
}

#pragma mark - private

- (void)p_cancelDebugWindowAction:(UIButton *)btn {
    [self hideDebugWindow];
}

- (void)p_confirmDebugWindowAction:(UIButton *)btn {
    self.configureDomain(self.domainTextField.text).configureURI(self.uriTextField.text);
    [self hideDebugWindow];
}

#pragma mark - getters

- (NSString *)requestURL {
    return [self.domain stringByAppendingString:self.URI?:@""];
}

- (NMAPIManager *(^)(NSString *))configureServiceKey {
    return ^ NMAPIManager *(NSString *serviceKey) {
        return ({
            self.serviceKey = serviceKey;
            self;
        });
    };
}

- (NMAPIManager *(^)(NSString *))configureDomain {
    return ^ NMAPIManager *(NSString *domain) {
        return ({
            self.domain = domain;
            self;
        });
    };
}

- (NMAPIManager *(^)(NSString *))configureURI {
    return ^ NMAPIManager *(NSString *URI) {
        return ({
            self.URI = URI;
            self;
        });
    };
}

- (NMAPIManager *(^)(NSString *))configureClientKey {
    return ^NMAPIManager *(NSString *clientKey) {
        return self.addRequestHeaderField(@"clientKey",clientKey);
    };
}

- (NMAPIManager *(^)(NSString *))configureAccessToken {
    return ^NMAPIManager *(NSString *accessToken) {
        return self.addRequestHeaderField(@"accessToken",accessToken);
    };
}

- (NMAPIManager *(^)(NSString *, NSString *))addRequestHeaderField {
    return ^NMAPIManager *(NSString *key,NSString *value) {
        return ({
            self.requestHeaderFields = ({
                NSAssert(key != nil, @"请求头里的key不能为空");
                NSAssert(value != nil, @"请求头里的value不能为空");
                
                NSMutableDictionary *headerFields = self.requestHeaderFields.mutableCopy;
                [headerFields setObject:value forKey:key];
                headerFields.copy;
            });
            self;
        });
    };
}

- (NSDictionary *)requestHeaderFields {
    if (_requestHeaderFields == nil) {
        
        NSMutableString *clientUserAgent = [NSMutableString string];
        [clientUserAgent appendString:[UIDevice currentDevice].systemName];
        [clientUserAgent appendFormat:@"+name:%@",[UIDevice currentDevice].name];
        [clientUserAgent appendFormat:@"+model:%@",[UIDevice currentDevice].model];
        [clientUserAgent appendFormat:@"+%@",[UIDevice currentDevice].systemVersion];
        
        NSDictionary<NSString *, id> *info = [NSBundle mainBundle].infoDictionary;
        NSString *currentVersion = info[@"CFBundleShortVersionString"];
        [clientUserAgent appendFormat:@"+APPVersion:%@",currentVersion];
        
        _requestHeaderFields = @{
                                 @"clientUserAgent":clientUserAgent.description,
                                 @"model":[UIDevice currentDevice].model,
#warning uuid unsafe,The late optimization
                                 @"phoneKey":[UIDevice currentDevice].identifierForVendor.UUIDString,
                                 };
    }
    return _requestHeaderFields;
}

@end
