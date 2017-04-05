//
//  NMLoginModel.h
//  Demo
//
//  Created by 刘富波 on 2017/3/6.
//  Copyright © 2017年 mac1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LemonClientKit.h"

@interface NMLoginParamsModel : NSObject <NMNetworkAPIDelegate>

@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *phoneKey;

@end
