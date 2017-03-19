//
//  UserModel.h
//  Square
//
//  Created by Nine on 2017/3/19.
//  Copyright © 2017年 Nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *passWorld;
@property(nonatomic,strong) NSString *secCode;
@property (copy,nonatomic) NSString *viewState;
-(void)acquireViewStare:(NSString *)userName passWord:(NSString *)passWord code:(NSString *)secCode;
@end
