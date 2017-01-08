//
//  DXMSeparateTextField.m
//  splitTextFieldDemo
//
//  Created by 胡学礼 on 2017/1/5.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "DXMSeparateTextField.h"

@interface DXMSeparateTextField ()
@property (nonatomic, copy) NSString* textWithSeparator;      // 去掉分隔符的字符串
@end

@implementation DXMSeparateTextField
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
    [self addTarget:self action:@selector(formatDisplayText:) forControlEvents:UIControlEventEditingChanged];
    _formatTemplate = nil;
    _separator = '-';
}

- (void)dealloc{
    [self removeTarget:self action:@selector(formatDisplayText:) forControlEvents:UIControlEventEditingChanged];
}

-(void)formatDisplayText:(UITextField *)textField {
    if (textField != self) {
        return;
    }
    [self formatText:super.text isInput:YES];
}

- (BOOL)isEnableFormat{
    BOOL bEnable = NO;
    for (NSNumber* obj in _formatTemplate) {
        NSInteger len = [obj integerValue];
        if (len > 0 ) {
            bEnable = YES;
            break;
        }
    }
    return bEnable;
}

- (void)formatText:(NSString*)text isInput:(BOOL)isInput{
    if (![self isEnableFormat]) {
        super.text = text;
        self.textWithSeparator = text;
        return ;
    }
    // 当前光标位置
    NSUInteger targetCursorPostion = [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
    
    NSUInteger newCursorPostion = targetCursorPostion;
    NSMutableString *textWithoutFormat = [NSMutableString new];
    for (NSUInteger i=0; i<text.length; i++) {
        unichar characterToAdd = [text characterAtIndex:i];
        if(isdigit(characterToAdd)) {
            [textWithoutFormat appendString:[NSString stringWithCharacters:&characterToAdd length:1]];
        } else {
            if(i<targetCursorPostion) {
                newCursorPostion--;
            }
        }
    }
    
    self.textWithSeparator = textWithoutFormat;
    NSMutableString* disPlayText = [NSMutableString string];
    if (textWithoutFormat && self.formatTemplate) {
        NSString* srcText = textWithoutFormat;
        NSInteger sectionLen = 0;
        for (NSNumber* numObj in self.formatTemplate ) {
            if ([numObj integerValue] <= 0) continue;
            sectionLen = [numObj integerValue];
            if (!srcText || [srcText isEqualToString:@""]) {
                break;
            }
            
            NSString* sectionText = [srcText substringToIndex:MIN(sectionLen, srcText.length)];
            srcText = [srcText substringFromIndex:sectionText.length];
            [disPlayText appendString:sectionText];
            if (srcText && ![srcText isEqualToString:@""]) {
                [disPlayText appendString:[NSString stringWithCharacters:&_separator length:1]];
                if (disPlayText.length <= targetCursorPostion) {
                    newCursorPostion ++;
                }
            }
        }
        
        if (srcText && ![srcText isEqualToString:@""] && sectionLen > 0) {
            [disPlayText appendString:srcText];
        }
    } else {
        disPlayText = textWithoutFormat;
    }
    super.text = disPlayText;
    
    // 计算新光标的位置
    UITextPosition *targetPostion = [self positionFromPosition:self.beginningOfDocument offset:newCursorPostion];
    [self setSelectedTextRange:[self textRangeFromPosition:targetPostion toPosition:targetPostion]];
}

- (void)setText:(NSString *)text{
    [self formatText:text isInput:NO];
}

@end
