//
//  MBLRBaseViewController.m
//  MB
//
//  Created by Tongtong Xu on 14/11/12.
//  Copyright (c) 2014年 xxx Innovation Co. Ltd. All rights reserved.
//

#import "MBLRBaseViewController.h"
#import "MBSortViewController.h"

@interface MBLRBaseViewController ()
@end

@implementation MBLRBaseViewController

- (UIView *)userNameBackView
{
    if (!_userNameBackView) {
        _userNameBackView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _userNameBackView;
}

- (UIView *)passwordBackView
{
    if (!_passwordBackView) {
        _passwordBackView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _passwordBackView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:[self.navigationController.viewControllers indexOfObject:self]%2==0 animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userNameBackView.frame = CGRectMake(0, 64, self.view.width, 44);
    self.passwordBackView.frame = CGRectMake(0, self.userNameBackView.bottom + 1, self.view.width, 44);
    [self.mbView addSubview:self.userNameBackView];
    [self.mbView addSubview:self.passwordBackView];
    [self buildUserNameView];
    [self buildPasswordView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [self.view addGestureRecognizer:tapGes];
    

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardShow:(NSNotification *)sender
{

}

- (void)keyboardHide:(NSNotification *)sender
{
    
}

- (void)buildUserNameView
{
//    UILabel *label = [UILabel userNameLabel];
//    label.frame = CGRectMake(20, 11, 52, 22);
//    [self.userNameBackView addSubview:label];
    
    self.userNameTextField = ({
        UITextField *textField = [UITextField userNameTextFieldWithDelegate:self];
        textField.frame = CGRectZero;
        textField;
    });
    [self.mbView addSubview:self.userNameTextField];
}

- (void)buildPasswordView
{
//    UILabel *label = [UILabel passwordLabel];
//    label.frame = CGRectMake(20, 11, 52, 22);
//    [self.passwordBackView addSubview:label];
    
    self.passwordTextField = ({
        UITextField *textField = [UITextField passwordTextFieldWithDelegate:self];
        textField.frame = CGRectZero;
        textField;
    });
    [self.mbView addSubview:self.passwordTextField];
}

#pragma mark - textfielddelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark - tapGestureAction

- (void)hideKeyBoard:(UITapGestureRecognizer *)sender
{
    
}

- (void)dealWithLoginResult:(MBApiError *)error
{
    [self hideProgressHUD];
    if (error.code == MBApiCodeSuccess) {
        [self postUserLoginNotification];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self showAlertTitle:@"" message:error.message];
    }
}

- (void)postUserLoginNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMBMODELUSERDIDLOGIN object:nil];
    MMDrawerController *menu = [[UIApplication sharedApplication] keyWindow].rootViewController;
    MBSortViewController *left = menu.leftDrawerViewController;
    [left reloadUserName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
