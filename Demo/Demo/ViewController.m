//
//  ViewController.m
//  Demo
//
//  Created by 刘富波 on 2017/1/3.
//  Copyright © 2017年 mac1. All rights reserved.
//

#import "ViewController.h"
#import "NMHUDManager.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(20, 20, 100, 100);
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
}

- (void)test {
    
    [self.navigationController pushViewController:[TestViewController new] animated:YES];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
