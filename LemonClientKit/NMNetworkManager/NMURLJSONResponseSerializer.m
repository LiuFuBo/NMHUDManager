//
//  NMFailHTTPResponseSerializer.m
//  NMSaleAPP
//
//  Created by 刘富波 on 2016/10/20.
//  Copyright © 2016年 mac1. All rights reserved.
//

#import "NMURLJSONResponseSerializer.h"

@implementation NMURLJSONResponseSerializer

- (BOOL)validateResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error {
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _responseObject = responseObject;
    return [super validateResponse:response data:data error:error];
}

@end
