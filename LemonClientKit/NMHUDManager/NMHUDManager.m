//
//  NMHUDManager.m
//  LemonLoan
//
//  Created by 刘富波 on 16/5/16.
//  Copyright © 2016年 mac1. All rights reserved.
//

#import "NMHUDManager.h"
#import "MBProgressHUD.h"
#import "ZXPAutoLayout.h"

#import <objc/runtime.h>

@import UIKit;

#pragma mark - private categories

@interface UIButton (P_NMAdd_HUDManager)


@property (nonatomic,strong) UIView *nm_hudManager_view;

@end


@implementation UIButton (P_NMAdd_HUDManager)

- (void)setNm_hudManager_view:(UIView *)nm_hudManager_view {
    objc_setAssociatedObject(self, @selector(nm_hudManager_view), nm_hudManager_view, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)nm_hudManager_view {
    return objc_getAssociatedObject(self, _cmd);
}

@end


#pragma mark - private class

@interface P_NMHUDLoadView : UIView
+ (instancetype)viewWithText:(NSString *)text;
@end

#pragma mark - HUD

@interface NMHUDManager ()

@property (nonatomic,copy) void(^reloadBtnActionBlock)(UIButton *sender);
@property (nonatomic,strong) UIView *reloadBgView;


@end

static const void * kNMTargetObjectForFailureView = &kNMTargetObjectForFailureView;
static const void * kNMKeyForLoadViewAndDissmissView = &kNMKeyForLoadViewAndDissmissView;
static const void * kNMMBPProgresskey = &kNMMBPProgresskey;

@implementation NMHUDManager

+ (void)showWithDefaultText {
    [self showWithText:@"正在努力加载中"];
    
}
+ (void)showWithText:(NSString *)text {
    [self showWithText:text mode:MBProgressHUDModeIndeterminate];
}

+ (void)showWithView:(UIView *)view text:(NSString *)text {
    view.userInteractionEnabled = NO;
    [self showWithText:text view:view mode:MBProgressHUDModeIndeterminate progress:0 customImageName:nil afterDelay:0.0f];
}

+ (void)showWithText:(NSString *)text dismissDelay:(NSTimeInterval)delay{
    [self showWithText:text view:nil mode:MBProgressHUDModeIndeterminate progress:0 customImageName:nil afterDelay:0.0f];
    [self dismissWithDelay:delay];
}

+(void)showWithText:(NSString *)text mode:(MBProgressHUDMode)mode{
    [self showWithText:text view:nil mode:mode progress:0 customImageName:nil afterDelay:0.0f];
}

+ (void)dismiss {
    [self dismissWithView:[UIApplication sharedApplication].keyWindow];
}

+ (void)dismissWithView:(UIView *)view {
    view.userInteractionEnabled = YES;
    [MBProgressHUD hideHUDForView:view animated:YES];
    [self isLoadingHUD];
}

+ (void)showSuccessWithText:(NSString *)text {
    [self showWithText:text view:nil mode:MBProgressHUDModeCustomView progress:0 customImageName:@"success" afterDelay:3.0f];
}

+ (void)showSuccessWithText:(NSString *)text dismissDelay:(NSTimeInterval)delay{
    [self showWithText:text view:nil mode:MBProgressHUDModeCustomView progress:0 customImageName:@"success" afterDelay:delay];
}

+ (void)showSuccessWithView:(UIView *)view text:(NSString *)text dismissDelay:(NSTimeInterval)delay{
    [self dismissWithView:view];
    [self showWithText:text view:view mode:MBProgressHUDModeCustomView progress:0 customImageName:@"success" afterDelay:delay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissWithView:view];
    });
}

+ (void)showSuccessWithView:(UIView *)view text:(NSString *)text dismissDelay:(NSTimeInterval)delay finished:(void(^)(void))finishedBlock {
    [self showSuccessWithView:view text:text dismissDelay:delay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (finishedBlock) {
            finishedBlock();
        }
    });
}

+ (void)showErrorWithText:(NSString *)text {
    [self showWithText:text view:nil mode:MBProgressHUDModeCustomView progress:0 customImageName:@"error" afterDelay:3.0f];
}

+ (void)showInfoWithText:(NSString *)text dismissDelay:(NSTimeInterval)delay {
    [self showWithText:text view:nil mode:MBProgressHUDModeCustomView progress:0 customImageName:@"info" afterDelay:delay];
}

+ (void)showErrorWithText:(NSString *)text dismissDelay:(NSTimeInterval)delay {
    [self showWithText:text view:nil mode:MBProgressHUDModeCustomView progress:0 customImageName:@"error" afterDelay:delay];
}

+ (void)showErrorWithView:(UIView *)view text:(NSString *)text dismissDelay:(NSTimeInterval)delay {
    [self showWithText:text view:view mode:MBProgressHUDModeCustomView progress:0 customImageName:@"error" afterDelay:0.0f];
    view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view.userInteractionEnabled = YES;
        [MBProgressHUD hideHUDForView:view animated:YES];
        [self isLoadingHUD];
    });
}

+ (void)showDefaultTextForLoadViewWithView:(UIView *)view {
    [self showLoadViewWithView:view text:@"正在努力加载中"];
}

+ (void)showProgress:(float)pro text:(NSString *)text {
    [self showWithText:text view:nil mode:MBProgressHUDModeAnnularDeterminate progress:pro customImageName:nil afterDelay:0.0f];
}

+ (void)showProgress:(float)pro {
    [self showWithText:nil view:nil mode:MBProgressHUDModeAnnularDeterminate progress:pro customImageName:nil afterDelay:0.0f];
}

+ (void)showProgressWithView:(UIView *)view progress:(float)pro text:(NSString *)text {
     [self showWithText:text view:view mode:MBProgressHUDModeAnnularDeterminate progress:pro customImageName:nil afterDelay:0.0f];
     view.userInteractionEnabled = NO;
}

+ (void)showLoadViewWithView:(UIView *)view text:(NSString *)text {
    P_NMHUDLoadView *loadView = [P_NMHUDLoadView viewWithText:text];
    [view addSubview:loadView];
    loadView.backgroundColor = [UIColor whiteColor];
    [loadView zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.edgeInsets(UIEdgeInsetsZero);
    }];
    
    objc_setAssociatedObject(view, _cmd, loadView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)dismissLoadViewWithView:(UIView *)view {
    UIView *bgView = objc_getAssociatedObject(view, @selector(showLoadViewWithView:text:));
    [UIView animateWithDuration:0.5 animations:^{
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        objc_setAssociatedObject(view, @selector(showLoadViewWithView:text:), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
}

+ (void)showFailureViewWithView:(UIView *)view buttonActionBlock:(void(^)(UIButton *sender))block {
    [self showFailureViewWithView:view text:@"客官，您的网络貌似有点小问题哦~！" buttonActionBlock:block];
}

+ (void)showFailureViewWithView:(UIView *)view text:(NSString *)text buttonActionBlock:(void(^)(UIButton *sender))block {
    
    if (!view) {
        return;
    }
    
    UIView *bgView = [UIView new];
    [view addSubview:bgView];
    
    bgView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    [bgView zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.edgeInsets(UIEdgeInsetsZero);
    }];
    
    //button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:btn];
    
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"重新加载" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 20;
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.nm_hudManager_view = view;
    
    NMHUDManager *targetObject = [NMHUDManager new];
    targetObject.reloadBtnActionBlock = [block copy];
    targetObject.reloadBgView = bgView;
    
    // retain self
    objc_setAssociatedObject(view, @selector(p_reloadBtnAction:), targetObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [btn addTarget:targetObject action:@selector(p_reloadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.centerByView(bgView,0);
        layout.widthValue(100);
        layout.heightValue(40);
    }];
    
    // label
    UILabel *label = [UILabel new];
    [bgView addSubview:label];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    label.adjustsFontSizeToFitWidth = YES;
    [label zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.bottomSpaceByView(btn,20);
        layout.leftSpace(0);
        layout.rightSpace(0);
        layout.heightValue(30);
    }];
    
    // animation
    bgView.hidden = YES;
    [UIView transitionWithView:view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        bgView.hidden = NO;
    } completion:nil];
}

+ (void)dismissWithDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = objc_getAssociatedObject(self,kNMMBPProgresskey);
    [hud hideAnimated:YES afterDelay:delay];   hud = nil;
    // release hud
    objc_setAssociatedObject(self, kNMMBPProgresskey, nil, OBJC_ASSOCIATION_ASSIGN);
}


+(void)showWithText:(NSString *)text view:(UIView *)view mode:(MBProgressHUDMode)mode  progress:(CGFloat)progress customImageName:(NSString *)customImageName afterDelay:(NSTimeInterval)afterDelay{

    //创建MBProgressHUD实例，并配置参数
    MBProgressHUD *hud = nil;
    if (!view) {
      hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }else {
      hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.mode = mode;
    hud.label.text = text;
    hud.removeFromSuperViewOnHide = YES;
    
    if (hud.mode == MBProgressHUDModeCustomView) {
        hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:customImageName]];
        //展示的hud视图的颜色为透明
        hud.bezelView.backgroundColor = [UIColor clearColor];
    }else if (hud.mode == MBProgressHUDModeAnnularDeterminate){
        //展示的hud视图的颜色为透明
        hud.bezelView.backgroundColor = [UIColor clearColor];
        hud.progress = progress;
    }else {
        //展示的hud视图的颜色
        hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    
   //向分类中添加该MBProgressHUD属性，并使用懒加载调用，保证当前主视图上只有一个HUD
    objc_setAssociatedObject(self, kNMMBPProgresskey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (afterDelay > 0) {
        //如果提示信息时间大于0, 则在afterDelay时间后自动隐藏
        [hud hideAnimated:YES afterDelay:afterDelay];
        [self isLoadingHUD];
    }
}

+(void)isLoadingHUD{

    MBProgressHUD *hud = objc_getAssociatedObject(self, kNMMBPProgresskey);
    hud = nil;
    // release hud
    objc_setAssociatedObject(self, kNMMBPProgresskey, nil, OBJC_ASSOCIATION_ASSIGN);
    
}



#pragma mark - private

- (void)p_reloadBtnAction:(UIButton *)sender {
    
    [UIView transitionWithView:self.reloadBgView.superview duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.reloadBgView.hidden = YES;
    } completion:nil];
    
    NMHUDManager *targetObject = objc_getAssociatedObject(sender.nm_hudManager_view, @selector(p_reloadBtnAction:));
    [targetObject.reloadBgView removeFromSuperview];
    targetObject.reloadBgView = nil;
    
    // release self
    objc_setAssociatedObject(sender.nm_hudManager_view, @selector(p_reloadBtnAction:), nil, OBJC_ASSOCIATION_ASSIGN);
    
    if (self.reloadBtnActionBlock) {
        self.reloadBtnActionBlock(sender);
    }
}

@end

#pragma mark - private class implementation

@implementation P_NMHUDLoadView

+ (instancetype)viewWithText:(NSString *)text {
    P_NMHUDLoadView *loadView = [P_NMHUDLoadView new];
    [loadView p_setupSubviewsWithText:text];
    return loadView;
}

- (void)p_setupSubviewsWithText:(NSString *)text {
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:activityView];
    [activityView zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.edgeInsets(UIEdgeInsetsZero);
    }];
    [activityView startAnimating];
    
    UILabel *label      = [UILabel new];
    [self addSubview:label];
    
    label.text          = text;
    label.textColor     = [UIColor grayColor];
    label.font          = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [label zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.yCenterByView(self,30);
        layout.widthEqualTo(self,0).multiplier(0.5);
        layout.xCenterByView(self,0);
        layout.autoHeight();
    }];
}

@end
