//
//  DXMSeparateTextField.h
//  splitTextFieldDemo
//
//  Created by 胡学礼 on 2017/1/5.
//  Copyright © 2017年 dx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXMSeparateTextField : UITextField
@property (nonatomic, strong) NSArray<NSNumber*>* formatTemplate;       // 分隔数组
@property (nonatomic, assign) unichar separator;                        // 分隔符
@property (nonatomic, copy, readonly) NSString* textWithSeparator;      // 去掉分隔符的字符串
@end
