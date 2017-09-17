//
//  LoginStepViewController.m
//  Square
//
//  Created by Nine on 2017/3/19.
//  Copyright © 2017年 Nine. All rights reserved.
//

#import "LoginStepViewController.h"
#import "RMStepsController.h"
#import "zySheetPickerView.h"
@interface LoginStepViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextStep;
@property (nonatomic, strong) UILabel *showLabel;
@end

@implementation LoginStepViewController

#pragma mark - Actions
- (IBAction)nextStepTapped:(id)sender {
    if ([_showLabel.text isEqualToString:@"湖南工业大学"]) {
        [Config saveUrl:@"http://218.75.197.124:83"];
    }else if([_showLabel.text isEqualToString:@"江苏理工学院"]){
        [Config saveUrl:@"http://jwgl.jsut.edu.cn/(kerprnqgqy20pwmimmbrn3ax)"];
    }
    [self.stepsController showNextStep];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.showLabel];
    _nextStep.hidden=true;
    UIButton *btn = [UIButton buttonWithType:1];
    btn.frame  = CGRectMake(SYReal(150), SYReal(500), SYReal(100), SYReal(100));
    [btn setTitle:@"选择你的学校" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickIt) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)clickIt
{
    NSArray * str  = @[@"湖南工业大学",@"江苏理工学院",@"没有我的学校"];
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:str andHeadTitle:@"测试选择" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
        if (![choiceString isEqualToString:@"没有我的学校"]) {
            _nextStep.hidden=false;
        }else{
            _nextStep.hidden=true;
        }
        _showLabel.text = choiceString;
        [pickerView dismissPicker];
    }];
    [pickerView show];
}

-(UILabel *)showLabel
{
    if(!_showLabel)
    {
        _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 200, self.view.frame.size.width-10, 50)];
        _showLabel.textColor = [UIColor yellowColor];
        _showLabel.layer.cornerRadius = 10;
        _showLabel.layer.masksToBounds = YES;
        _showLabel.textAlignment = NSTextAlignmentCenter;
        _showLabel.font = [UIFont systemFontOfSize:24];
        _showLabel.backgroundColor = [UIColor blackColor];
    }
    return _showLabel;
}

@end
