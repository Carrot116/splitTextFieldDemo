//
//  DXMSeparateTextField.h
//  splitTextFieldDemo
//
//  Created by 胡学礼 on 2017/1/5.
//  Copyright © 2017年 dx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXMSeparateTextField : UITextField
@property (nonatomic, strong) NSArray<NSNumber*>* separateLenArray;     // 分隔数组
@property (nonatomic, copy) NSString* separatePlaceholder;              // 分隔符
@end
