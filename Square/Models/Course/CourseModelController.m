//
//  CourseModelController.m
//  Square
//
//  Created by Nine on 2017/3/19.
//  Copyright © 2017年 Nine. All rights reserved.
//

#import "CourseModelController.h"
#import "TFHpple.h"
#import "AFNetworking.h"
AFHTTPRequestOperationManager *AFHROMs;
@implementation CourseModelController
-(void)acquireData:(NSString*)userName with:(NSString*)passWord{
    AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
    //  MainInterfaceAppDelegate *mainDele=[[UIApplication sharedApplication]delegate];
    if(userName!=nil&&passWord!=nil){
        NSDictionary *parameters2 = @{@"xh":userName,@"xm":passWord,@"gnmkdm":@"N121603"};
        manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
        [self.AFHROM GET:@"http://218.75.197.124:83/xskbcx.aspx?" parameters:parameters2
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
                         NSString *content = [element text];
                         NSString *ta=[element tagName];
                         NSDictionary *dic=[element attributes];
                         NSString *nodeContent=[element content];
                         //NSLog(@"课程为%@%@",nodeContent,ta);
                         NSLog(@"%@",nodeContent);
                         [allContents addObject:nodeContent];
                     }
                     
                     [self sortData:allContents];
                     NSLog(@"---------整理后---------------");
                     
                     NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                     NSMutableArray *arry=[[NSMutableArray alloc]init];
                     int j=0;
                     for(int i=0;j<allContents.count;i++){
                         NSString *str =allContents[j];
                         if(i%4==0) {
                             dic[@"name"]=str;
                         }
                         if(i%4==1) {
                             {
                                 if ([str rangeOfString:@"周一"].location!=NSNotFound){
                                     dic[@"xqj"] = @"1";
                                 }else if ([str rangeOfString:@"周二"].location!=NSNotFound){
                                     dic[@"xqj"] = @"2";
                                 }else if ([str rangeOfString:@"周三"].location!=NSNotFound){
                                     dic[@"xqj"] = @"3";
                                 }else if ([str rangeOfString:@"周四"].location!=NSNotFound){
                                     dic[@"xqj"] = @"4";
                                 }else if ([str rangeOfString:@"周五"].location!=NSNotFound){
                                     dic[@"xqj"] = @"5";
                                 }else if ([str rangeOfString:@"周六"].location!=NSNotFound){
                                     dic[@"xqj"] = @"6";
                                 }else if ([str rangeOfString:@"周日"].location!=NSNotFound){
                                     dic[@"xqj"] = @"7";
                                 }
                             }
                             
                             //取开始周
                             NSRange testRange = [str rangeOfString:@"{"];
                             NSRange test2 = testRange;
                             test2.location = test2.location + 3;;
                             if ([[str substringWithRange:test2]isEqualToString:@"-" ]) {
                                 testRange.location = testRange.location + 2;
                                 dic[@"qsz"] = [str substringWithRange:testRange];
                             }
                             else{
                                 testRange.location = testRange.location +2;
                                 testRange.length = testRange.length +1;
                                 dic[@"qsz"] = [str substringWithRange:testRange];
                             }
                             
                             //取结束周
                             testRange = [str rangeOfString:@"-"];
                             test2 = testRange;
                             test2.location = test2.location + 2;;
                             if ([[str substringWithRange:test2]isEqualToString:@"周" ]) {
                                 testRange.location = testRange.location + 1;
                                 dic[@"jsz"] = [str substringWithRange:testRange];
                             }
                             else{
                                 testRange.location = testRange.location +1;
                                 testRange.length = testRange.length +1;
                                 dic[@"jsz"] = [str substringWithRange:testRange];
                             }
                             
                             //是否单双周
                             if ([str rangeOfString:@"单周"].location!=NSNotFound) {
                                 dic[@"dsz"]  = @"单";
                             }else if ([str rangeOfString:@"双周"].location!=NSNotFound){
                                 dic[@"dsz"]  = @"双";
                             }else{
                                 dic[@"dsz"] = @"";
                             }
                             
                             //第几节
                             if ([str rangeOfString:@"第1,2节"].location!=NSNotFound){
                                 dic[@"djj"] = @"1";
                             }else if ([str rangeOfString:@"第3,4节"].location!=NSNotFound){
                                 dic[@"djj"] = @"3";
                             }else if ([str rangeOfString:@"第5,6节"].location!=NSNotFound){
                                 dic[@"djj"] = @"5";
                             }else if ([str rangeOfString:@"第7,8节"].location!=NSNotFound){
                                 dic[@"djj"] = @"7";
                             }else if ([str rangeOfString:@"第9,10节"].location!=NSNotFound){
                                 dic[@"djj"] = @"9";
                             }else if ([str rangeOfString:@"第11,12节"].location!=NSNotFound){
                                 dic[@"djj"] = @"11";
                             }
                         }
                         if (i%4==2) {
                             dic[@"teacher"]=str;
                         }
                         if (i%4==3) {
                             // NSLog(@"%ld",results.count);
                             NSString *pattern = @"[0-9]";
                             // 1.1将正则表达式设置为OC规则
                             NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
                             // 2.利用规则测试字符串获取匹配结果
                             NSArray *results = [regular matchesInString:str options:0 range:NSMakeRange(0,str.length)];
                             if (results.count!=3) {
                                 //NSLog(@"非正常情况%d",i);
                                 dic[@"room"]=@"";
                                 str=@"";
                                 j--;
                             }
                             dic[@"room"] = str;
                             NSDictionary *dics = [NSDictionary dictionaryWithDictionary:dic];
                             [arry addObject:dics];
                             [dic removeAllObjects];
                         }
                         
                         NSLog(@"%@",str);
                         if (i%4==3) {
                             NSLog(@"---------");
                         }
                         j++;
                     }
                     NSArray *myArray = [arry copy];
                     [Config saveCourse:myArray];
                     
                     //                     [allContents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                     //                         i++;
                     //                         NSLog(@"%@",obj);
                     //                         if (i%4==0) {
                     //                             NSLog(@"------------");
                     //                         }
                     //                     }];
                     
                     
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
    if (!AFHROMs) {
        AFHROMs=[AFHTTPRequestOperationManager manager];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        AFHROMs.responseSerializer.stringEncoding=enc;
        AFHROMs.requestSerializer.stringEncoding = enc;
        AFHROMs.responseSerializer=[AFHTTPResponseSerializer serializer];
        AFHROMs.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return AFHROMs;
}

@end
