//
//  Config.h
//  Square
//
//  Created by Nine on 2017/3/19.
//  Copyright © 2017年 Nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
+(void)saveUserName:(NSString*)userName;
+(void)savePassWord:(NSString*)passWord;
+(void)saveCourse:(NSArray*)data;
+(void)saveUrl:(NSString*)url;
+(void)saveSchool:(NSString*)school;

+(NSString*)getUserName;
+(NSString*)getPassWord;
+(NSArray*)getCourse;
+(NSString*)getUrl;
+(NSString*)getSchool;
+(void)pushViewController:(NSString*)controller;
@end
