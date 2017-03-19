//
//  LoginViewController.m
//  Square
//
//  Created by Nine on 2017/3/19.
//  Copyright © 2017年 Nine. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
- (NSArray *)stepViewControllers {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *firstStep = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SomeStep"];
    firstStep.step.title = @"选择你的学校";
    
    UIViewController *secondStep = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SomeStep2"];
    secondStep.step.title = @"输入教务系统账号密码";
    
    UIViewController *thirdStep = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SomeStep3"];
    thirdStep.step.title = @"确认课表";
    
    
    return @[firstStep, secondStep, thirdStep];
}

- (void)finishedAllSteps {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)canceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"导入课表";
    
}

- (void)viewWillAppear:(BOOL)animated {

//    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
   // self.navigationController.navigationBarHidden = NO;
}
@end
