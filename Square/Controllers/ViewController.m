//
//  ViewController.m
//  Square
//
//  Created by Nine on 2017/3/18.
//  Copyright © 2017年 Nine. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "UserModel.h"
#import "CourseModelController.h"
#import "ClassViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UtfUserName;
@property (weak, nonatomic) IBOutlet UITextField *UtfPassWord;
@property (weak, nonatomic) IBOutlet UITextField *UtfSecCode;
@property (weak, nonatomic) IBOutlet UIImageView *UivSecCode;
@property (strong,nonatomic) NSString *userName;
@property(strong,nonatomic)NSString *passWorld;
@property (strong, nonatomic) AFHTTPRequestOperationManager *AFHROM;

@property (copy,nonatomic) NSString *viewState;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshSecCode];
    if ([Config getUserName]) {
        _UtfUserName.text=[Config getUserName];
    }
    if ([Config getPassWord]) {
        _UtfPassWord.text=[Config getPassWord];
    }
}


- (IBAction)login:(id)sender {
    [Config saveUserName:_UtfUserName.text];
    [Config savePassWord:_UtfPassWord.text];
    
    UserModel *user=[[UserModel alloc]init];
    [user acquireViewStare:_UtfUserName.text passWord:_UtfPassWord.text code:_UtfSecCode.text];

}
- (IBAction)course:(id)sender {
    CourseModelController *course=[[CourseModelController alloc]init];
    [course acquireData:[Config getUserName] with:[Config getPassWord]];
}

- (IBAction)a:(id)sender {
    [self refreshSecCode];
}
- (IBAction)buuton:(id)sender {
//    //[Config pushViewController:@"Class"];
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    //将第二个控制器实例化，"SecondViewController"为我们设置的控制器的ID
//    ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
//    NSLog(@"123");
//    //跳转事件
//    [self.navigationController pushViewController:secondViewController animated:YES];
}

/**刷新验证码*/
-(void)refreshSecCode{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *UrlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"http://218.75.197.124:83/CheckCode.aspx?"]];
        //提交Cookie，上一行的NSURLRequest被改为NSMutableURLRequest
       if(self.AFHROM.cookieDictionary) {
            [UrlRequest setHTTPShouldHandleCookies:NO];
            [UrlRequest setAllHTTPHeaderFields:self.AFHROM.cookieDictionary];
        }
        //end
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:UrlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
           dispatch_async(dispatch_get_main_queue(), ^{
                self.UivSecCode.image = responseObject;
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络连接错误"];
        }];
       [requestOperation start];
       // 显示验证码
   });
    
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    NSString *image_urls=@"http://218.75.197.124:83/CheckCode.aspx";
//    NSURL *url                   = [NSURL URLWithString: image_urls];//接口地址
//    [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        self.UivSecCode.image = image;
//    }];
}





@end
