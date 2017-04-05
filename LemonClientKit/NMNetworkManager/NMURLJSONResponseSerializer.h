//
//  NMFailHTTPResponseSerializer.h
//  NMSaleAPP
//
//  Created by 刘富波 on 2016/10/20.
//  Copyright © 2016年 mac1. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface NMURLJSONResponseSerializer : AFJSONResponseSerializer

@property (nonatomic,copy,readonly) id responseObject;

@end
