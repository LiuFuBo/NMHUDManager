//
//  NMLoginModel.m
//  Demo
//
//  Created by 刘富波 on 2017/3/6.
//  Copyright © 2017年 mac1. All rights reserved.
//

#import "NMLoginParamsModel.h"

@implementation NMLoginParamsModel

- (NSString *)networkURL:(NMNetworkingManager *)manager {
    return [NMAPIManager manager].requestURL;
}

- (NSString *)networkServiceKeyConfigure:(NMNetworkingManager *)manager {
    return [NMAPIManager manager].serviceKey;
}

- (NSDictionary *)networkHeaderFields:(NMNetworkingManager *)manager {
    return [NMAPIManager manager].requestHeaderFields;
}

- (NSString *)networkAPIAtParamsConfigure:(NMNetworkingManager *)manager {
    return @"api/login/v2";
}

- (NSDictionary *)networkInParameters:(NMNetworkingManager *)manager {
    return @{@"phone":self.phone,@"password":self.password,@"phoneKey":self.phoneKey};
}

@end
