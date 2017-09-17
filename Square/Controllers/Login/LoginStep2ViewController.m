//
//  LoginStep2ViewController.m
//  Square
//
//  Created by Nine on 2017/3/19.
//  Copyright © 2017年 Nine. All rights reserved.
//

#import "LoginStep2ViewController.h"
#import "TFHpple.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "RMStepsController.h"
@interface LoginStep2ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UtfUserName;
@property (weak, nonatomic) IBOutlet UITextField *UtfPassWord;
@property (weak, nonatomic) IBOutlet UITextField *UtfSecCode;
@property (weak, nonatomic) IBOutlet UIImageView *UivSecCode;

@property (strong, nonatomic) AFHTTPRequestOperationManager *AFHROM;

@end

@implementation LoginStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshSecCode];
    if ([Config getUserName]) {
        _UtfUserName.text=[Config getUserName];
    }
    if ([Config getPassWord]) {
        _UtfPassWord.text=[Config getPassWord];
    }
    // Do any additional setup after loading the view.
}

#pragma mark - 按钮
- (IBAction)nextStepTapped:(id)sender {
    self.userName=_UtfUserName.text;
    self.passWorld=_UtfPassWord.text;
    self.secCode=_UtfSecCode.text;
    
    [Config saveUserName:_UtfUserName.text];
    [Config savePassWord:_UtfPassWord.text];
    
    [self acquireViewStare];
}

- (IBAction)previousStepTapped:(id)sender {
    [self.stepsController showPreviousStep];
}
- (IBAction)refresh:(id)sender {
    [self refreshSecCode];
}
/**刷新验证码*/
-(void)refreshSecCode{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *UrlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",[Config getUrl],@"/CheckCode.aspx?"]]];
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
    //    NSString *image_urls=[NSString stringWithFormat:@"%@%@",[Config getUrl],@"/CheckCode.aspx"];
    //    NSURL *url                   = [NSURL URLWithString: image_urls];//接口地址
    //    [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    //    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
    //        self.UivSecCode.image = image;
    //    }];
}

-(void)acquireViewStare{
    [self.AFHROM GET:[NSString stringWithFormat:@"%@%@",[Config getUrl],@"/default2.aspx"] parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                 NSData *data=responseObject;
                 NSString *transStr=[[NSString alloc]initWithData:data encoding:enc];
                 NSString *utf8HtmlStr = [transStr stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
                 NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
                 TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlDataUTF8];
                 NSArray *elements  = [xpathParser searchWithXPathQuery:@"//input[@name='__VIEWSTATE']"];
                 
                 NSUInteger count=[elements count];
                 for (int i=0; i<count; i++) {
                     TFHppleElement *element = [elements objectAtIndex:i];
                     self.viewState=[element objectForKey:@"value"];
                     NSLog(@"1提取到得viewstate为%@",self.viewState);
                     [self logins];
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"Error: %@", [error debugDescription]);
             }];
}
-(void)logins{
    //[self.view showHUDWithText:@"登录中" hudType:kXHHUDLoading animationType:kXHHUDFade delay:0];
    NSDictionary *parameters = @{@"__VIEWSTATE":self.viewState,@"txtUserName": _userName,@"TextBox2":_passWorld,@"txtSecretCode":_secCode,@"RadioButtonList1":@"学生",@"Button1":@""};
    [self.AFHROM POST:[NSString stringWithFormat:@"%@%@",[Config getUrl],@"/default2.aspx"] parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSURL *denglu=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[Config getUrl],@"/default2.aspx"]];
                  if ([operation.response.URL isEqual:denglu]) {
                      //  [self miMaCuoWu];
                      [self refreshSecCode];
                      [MBProgressHUD showError:@"登录错误，账号/密码/验证码错误"];
                  }else{
                      [MBProgressHUD showError:@"登录成功"];
                      NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                      
                      NSData *data=responseObject;
                      NSString *tansData=[[NSString alloc]initWithData:data encoding:enc];
                      NSLog(@"biaodantijiaochenggong:%ld，%@",(long)operation.response.statusCode,operation.responseString);//提交表单
                      NSString *utf8HtmlStr = [tansData stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
                      NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
                      [self anayseLoginData:htmlDataUTF8];
                        [self.stepsController showNextStep];
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self refreshSecCode];
                  [MBProgressHUD showError:@"登录错误，网络无法连接"];
              }];
}
-(void)anayseLoginData:(NSData*)data{
    TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:data];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//span[@id='xhxm']"];
    // Access the first cell
    NSUInteger count=[elements count];
    for (int i=0; i<count; i++) {
        TFHppleElement *element = [elements objectAtIndex:i];
        // Get the text within the cell tag
        NSString *content = [element text];
        NSString *ta=[element tagName];
        NSLog(@"学号姓名为%@%@%@",content,ta,[content substringToIndex:[content length]-2]);
    }
    // [self acquireData];
}

-(void)acquireData{
    AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
    //  MainInterfaceAppDelegate *mainDele=[[UIApplication sharedApplication]delegate];
    if(_userName!=nil&&_passWorld!=nil){
        NSDictionary *parameters2 = @{@"xh":_userName,@"xm":_passWorld,@"gnmkdm":@"N121603"};
        manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
        [self.AFHROM GET:[NSString stringWithFormat:@"%@%@",[Config getUrl],@"/xskbcx.aspx?"] parameters:parameters2
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                     
                     NSData *data=responseObject;
                     NSString *transStr=[[NSString alloc]initWithData:data encoding:enc];
                     
                     NSLog(@"huoqushuju: %ld",(long)operation.response.statusCode);
                     NSLog(@"课表数据：%@",transStr);
                     NSString *utf8HtmlStr = [transStr stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
                     NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
                     TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlDataUTF8];
                     NSArray *elements  = [xpathParser searchWithXPathQuery:@"//table[@id='Table1']/tr/td/child::text()"];
                     
                     // Access the first cell
                     NSUInteger count=[elements count];
                     NSMutableArray *allContents=[NSMutableArray array];
                     for (int i=0; i<count; i++) {
                         
                         TFHppleElement *element = [elements objectAtIndex:i];
                         
                         // Get the text within the cell tag
                         NSString *nodeContent=[element content];
                         //NSLog(@"课程为%@%@",nodeContent,ta);
                         NSLog(@"%@",nodeContent);
                         [allContents addObject:nodeContent];
                     }
                     
                     [self sortData:allContents];
                     NSLog(@"---------整理后---------------");
                     //              for(NSString *a in allContents){
                     //                  NSLog(@"%@",a);
                     //              }
                     __block int i=0;
                     [allContents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                         i++;
                         NSLog(@"%@",obj);
                         if (i%4==0) {
                             NSLog(@"------------");
                         }
                     }];
                     
                     
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"Error: %@", [error debugDescription]);
                 }];//获取登陆后的网页
    }
}
-(void)sortData:(NSMutableArray*)arrayData{
    __block NSMutableIndexSet* indexSet=[NSMutableIndexSet indexSet];
    [arrayData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *string=obj;
        if([string isEqualToString:@" "]||[string hasPrefix:@"星期"]||[string isEqualToString:@"上午"]||[string isEqualToString:@"下午"]||[string isEqualToString:@"早晨"]||[string isEqualToString:@"晚上"]){
            [indexSet addIndex:idx];
        }
        if([string hasPrefix:@"第"]&&[string hasSuffix:@"节"]){
            [indexSet addIndex:idx];
        }
        if([string isEqualToString:@"时间"]){
            [indexSet addIndex:idx];
        }
        if ([string hasPrefix:@"2014年"]) {
            [indexSet addIndex:idx];
            [indexSet addIndex:idx+1];
        }
        
    }];
    [arrayData removeObjectsAtIndexes:indexSet];
}


-(AFHTTPRequestOperationManager*)AFHROM{
    if (!_AFHROM) {
        _AFHROM=[AFHTTPRequestOperationManager manager];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        _AFHROM.responseSerializer.stringEncoding=enc;
        _AFHROM.requestSerializer.stringEncoding = enc;
        _AFHROM.responseSerializer=[AFHTTPResponseSerializer serializer];
        _AFHROM.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _AFHROM;
}

@end
