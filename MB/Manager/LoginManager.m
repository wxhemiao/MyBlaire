//
//  GuideViewManager.m
//  MB
//
//  Created by Tongtong Xu on 14/11/11.
//  Copyright (c) 2014年 xxx Innovation Co. Ltd. All rights reserved.
//

#import "LoginManager.h"
#import "MBGuideViewController.h"
#import "TTXBaseNavigationController.h"
#import "MBLoginViewController.h"
#import "MBRegisterViewController.h"
#import "TTXLoginManager.h"

@implementation LoginManager

+ (void)showLoginView
{
    UIViewController *controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    MBLoginViewController *loginViewController = [[MBLoginViewController alloc] init];
    [controller presentViewController:[[TTXBaseNavigationController alloc] initWithRootViewController:loginViewController] animated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MB_ShouldHideLaunchView() object:nil];
    }];
}

+ (void)configGuideViewAction:(MBGuideViewController *)guideView
{
    @weakify(guideView);
    guideView.loginActionBlock = ^(){
        @strongify(guideView);
        MBLoginViewController *loginViewController = [[MBLoginViewController alloc] init];
        [guideView.navigationController pushViewController:loginViewController animated:YES];
        [LoginManager configLoginViewAction:loginViewController];
    };
    guideView.registActionBlock = ^(){
        @strongify(guideView);
        MBRegisterViewController *registerViewController = [[MBRegisterViewController alloc] init];
        [guideView.navigationController pushViewController:registerViewController animated:YES];
        [LoginManager configRegisterViewAction:registerViewController];;
    };
}

+ (void)configLoginViewAction:(MBLoginViewController *)loginView
{
    @weakify(loginView);
    loginView.sinaLoginActionBlock = ^(){
        @strongify(loginView);
        [[TTXLoginManager shared] sinaLoginWithViewController:loginView];
    };
    loginView.qqLoginActionBlock = ^(){
        @strongify(loginView);
        [[TTXLoginManager shared] qqLoginWithViewController:loginView];
    };
}

+ (void)configRegisterViewAction:(MBRegisterViewController *)registerView
{
    @weakify(registerView);
    registerView.sinaLoginActionBlock = ^(){
        @strongify(registerView);
        [[TTXLoginManager shared] sinaLoginWithViewController:registerView];
    };
    registerView.qqLoginActionBlock = ^(){
        @strongify(registerView);
        [[TTXLoginManager shared] qqLoginWithViewController:registerView];
    };
    registerView.registerActionBlock = ^(NSString *userName,NSString *password,NSString *mail){
      [MBApi registerNewUserWithUserName:userName password:password email:mail handle:^(MBApiError *error) {
          @strongify (registerView);
          registerView.loginAfterRegisterBlock (userName,password,error);
      }];
    };
    registerView.loginActionBlock = ^(NSString *userName,NSString *password){
        @strongify (registerView);
        [MBApi loginWithType:MBLoginTypeNormal userName:userName password:password token:nil handle:^(MBApiError *error) {
            [registerView dealWithLoginResult:error];
        }];
    };
}

@end
