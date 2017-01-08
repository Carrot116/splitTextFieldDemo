//
//  ViewController.m
//  splitTextFieldDemo
//
//  Created by 胡学礼 on 2017/1/5.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "ViewController.h"
#import "DXMSeparateTextField.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet DXMSeparateTextField *separateTextField;
@property (weak, nonatomic) IBOutlet UITextField *testTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.separateTextField.separator = ' ';
    self.separateTextField.formatTemplate = @[@(3),@(4),@(4)];
    self.separateTextField.delegate = self;
    
    self.separateTextField.text = @"13816254394";
    self.testTextField.text = @"13816254394";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField == self.separateTextField){
//        return (self.separateTextField.textWithSeparator.length < 12);
//    }
    return YES;
}
@end
