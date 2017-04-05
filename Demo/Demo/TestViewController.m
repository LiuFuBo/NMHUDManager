//
//  TestViewController.m
//  Demo
//
//  Created by  刘富波 on 2017/2/22.
//  Copyright © 2017年 mac1. All rights reserved.
//

#import "TestViewController.h"
#import "LemonClientKit.h"
#import "ViewController.h"
#import "NMLoginParamsModel.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(20, 20, 100, 100);
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:btn2];
    btn2.frame = CGRectMake(20, 120, 100, 100);
    [btn2 addTarget:self action:@selector(test2) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc {
    
}

- (void)test {
    [NMHUDManager showProgressWithView:self.view progress:0.6 text:@"haha"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [NMHUDManager showSuccessWithView:self.view text:@"success" dismissDelay:2];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
}

- (void)test2 {
    NMLoginParamsModel *loginParamsModel = [NMLoginParamsModel new];
    loginParamsModel.phoneKey = @"tstst";
    loginParamsModel.phone = @"15281087434";
    loginParamsModel.password = @"123456";
    
    [NMHUDManager showWithView:self.view text:@"正在请求中"];
    __weak typeof(self) weak_self = self;
    [NMNetworkingManager postWithAPIObject:loginParamsModel finished:^(NSURLResponse *response, id responseObject, NSError *error) {
        [NMHUDManager showSuccessWithView:weak_self.view text:@"请求成功" dismissDelay:2];
        NSLog(@"响应:%@",responseObject);
        [[NMAPIManager manager] showDebugWindow];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
