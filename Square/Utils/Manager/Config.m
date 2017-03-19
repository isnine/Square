//
//  Config.m
//  Square
//
//  Created by Nine on 2017/3/19.
//  Copyright © 2017年 Nine. All rights reserved.
//

#import "Config.h"
#import "AppDelegate.h"
@implementation Config
#pragma mark - 持续化存储
+(void)saveUserName:(NSString*)userName{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:@"kUserName"];
    [defaults synchronize];
}
+(void)savePassWord:(NSString*)passWord{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:passWord forKey:@"kPassWord"];
    [defaults synchronize];
}
+(void)saveCourse:(NSArray*)data{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"kCourse"];
    [defaults synchronize];
}
+(void)saveUrl:(NSString*)url{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:url forKey:@"kUrl"];
    [defaults synchronize];
}
+(void)saveSchool:(NSString*)school{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:school forKey:@"kSchool"];
    [defaults synchronize];
}
#pragma mark - 获得存储数据
+(NSString*)getUserName{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kUserName"];
}
+(NSString*)getPassWord{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kPassWord"];
}
+(NSArray*)getCourse{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kCourse"];
}
+(NSString*)getUrl{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kUrl"];
}
+(NSString*)getSchool{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"kSchool"];
}

#pragma mark - 界面
+(void)pushViewController:(NSString*)controller{
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:controller];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
}
@end
