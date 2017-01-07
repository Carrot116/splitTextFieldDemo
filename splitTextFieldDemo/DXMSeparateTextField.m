//
//  DXMSeparateTextField.m
//  splitTextFieldDemo
//
//  Created by 胡学礼 on 2017/1/5.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "DXMSeparateTextField.h"

@implementation DXMSeparateTextField
@synthesize text = _text;
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupSeparateAttributes];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSeparateAttributes];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupSeparateAttributes];
    }
    return self;
}

- (void)setupSeparateAttributes{
    [self addTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    _separateLenArray = nil;
    _separatePlaceholder = @"";
}

- (void)textEditingChanged:(UITextField*)textField{
    NSLog(@"编辑中的数据:%@", textField.text);
    [self setText:textField.text];
}

- (NSString*)separateText:(NSString*)text{
    NSString* newText = text;
    if (newText && self.separateLenArray
        && self.separatePlaceholder
        && ![self.separatePlaceholder isEqualToString:@""]) {
        __block NSString* destText = @"";
        __block NSString* srcText = newText;
        [self.separateLenArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            int len = [obj intValue];
            if (len > 0) {
                NSString* subText = [srcText substringToIndex: MIN(len,srcText.length)];
                destText = [NSString stringWithFormat:@"%@%@%@", destText, idx == 0 ? @"" : self.separatePlaceholder, subText];
                if ([subText isEqualToString:srcText]) {
                    *stop = YES;
                    srcText = nil;
                } else {
                    srcText = [srcText substringFromIndex:len];
                }
            }
        }];
        NSInteger lastLen = [self.separateLenArray.lastObject integerValue];
        while (lastLen > 0 && srcText.length > 0) {
            NSString* subText = [srcText substringToIndex: MIN(lastLen,srcText.length)];
            destText = [NSString stringWithFormat:@"%@%@%@", destText, self.separatePlaceholder, subText];
            srcText = [srcText substringFromIndex:subText.length];
        }
        newText = destText;
    }
    NSLog(@"分隔数据-->%@  => %@", text, newText);
    return newText;
}

- (NSString*)unSeparateText:(NSString*)separateText{
    if (separateText && self.separateLenArray && self.separatePlaceholder && ![self.separatePlaceholder isEqualToString:@""]) {
        return [separateText stringByReplacingOccurrencesOfString:self.separatePlaceholder withString:@""];
    }
    return separateText;
}

- (void)dealloc{
    [self removeTarget:self action:@selector(textEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setText:(NSString *)text{
    NSString* newText = [self separateText:text];
    [super setText:newText];
}

- (NSString*)text{
    _text = [self unSeparateText:[super text]];
    return _text;
}

@end
