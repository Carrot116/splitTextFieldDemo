//
//  ViewController.m
//  splitTextFieldDemo
//
//  Created by 胡学礼 on 2017/1/5.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "ViewController.h"
#import "DXMSeparateTextField.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet DXMSeparateTextField *separateTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.separateTextField.separatePlaceholder = @" ";
    self.separateTextField.separateLenArray = @[@(3),@(4),@(4)];
    
    self.separateTextField.text = @"13816254394";
    NSLog(@"%@",self.separateTextField.text);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
