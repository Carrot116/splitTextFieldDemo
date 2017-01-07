//
//  DXMSeparateTextField.m
//  splitTextFieldDemo
//
//  Created by 胡学礼 on 2017/1/5.
//  Copyright © 2017年 dx. All rights reserved.
//

#import "DXMSeparateTextField.h"

@implementation DXMSeparateTextField{
    NSString* _mInnerText;
}
@synthesize text = _mInnerText;
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
    _separateLenArray = nil;
    _separatePlaceholder = @"";
}

- (void)dealloc{
    [self removeTarget:self action:@selector(formatDisplayText:) forControlEvents:UIControlEventEditingChanged];
}

-(void)formatDisplayText:(UITextField *)textField {
    if (textField != self) {
        return;
    }
    super.text = [self formatText:super.text isInput:YES];
}


/**
 *  除去非数字字符，确定光标正确位置
 *
 *  @param string         当前的string
 *  @param cursorPosition 光标位置
 *
 *  @return 处理过后的string
 */
- (NSString *)removeNonDigits:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition {
    NSUInteger originalCursorPosition =*cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    
    for (NSUInteger i=0; i<string.length; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        
        if(isdigit(characterToAdd)) {
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if(i<originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    return digitsOnlyString;
}

/**
 *  将空格插入我们现在的string 中，并确定我们光标的正确位置，防止在空格中
 *
 *  @param string         当前的string
 *  @param cursorPosition 光标位置
 *
 *  @return 处理后有空格的string
 */
- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    
    for (NSUInteger i=0; i<string.length; i++) {
        if(i>0)
        {
            if(i==3 || i==7) {
                [stringWithAddedSpaces appendString:@"-"];
                
                if(i<cursorPositionInSpacelessString) {
                    (*cursorPosition)++;
                }
            }
        }
        
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    return stringWithAddedSpaces;
}


- (NSString*)formatText:(NSString*)text isInput:(BOOL)isInput{
    /**
     *  判断正确的光标位置
     */
    NSUInteger targetCursorPostion = [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
    NSString *textWithoutFormat = [self removeNonDigits: isInput ? super.text : text andPreserveCursorPosition:&targetCursorPostion];
    
    
//    if([textWithoutFormat length]>11) {
//        /**
//         *  避免超过11位的输入
//         */
//        
//        //        [self setText:_previousTextFieldContent];
//        //        textField.selectedTextRange = _previousSelection;
//        
//        return;
//    }
  
    NSString* newText = textWithoutFormat;
    if (newText && self.separateLenArray
        && self.separatePlaceholder
        && ![self.separatePlaceholder isEqualToString:@""]) {
        NSMutableString* disPlayText = [NSMutableString string];
        NSString* srcText = newText;
        NSInteger sectionLen = 0;
        for (NSNumber* numObj in self.separateLenArray ) {
            sectionLen = [numObj integerValue];
            if (sectionLen <= 0) continue;
            if (!srcText || [srcText isEqualToString:@""]) {
                break;
            }
            
            NSString* sectionText = [srcText substringToIndex:MIN(sectionLen, srcText.length)];
            srcText = [srcText substringFromIndex:sectionText.length];
            [disPlayText appendString:sectionText];
            if (srcText && ![srcText isEqualToString:@""]) {
                [disPlayText appendString:self.separatePlaceholder];
                if (disPlayText.length < targetCursorPostion) {
                    targetCursorPostion += 1;
                }
            }
        }
        
        if (srcText && ![srcText isEqualToString:@""] && sectionLen > 0) {
            [disPlayText appendString:srcText];
        }
        
        
        newText = disPlayText;
    }
    UITextPosition *targetPostion = [self positionFromPosition:self.beginningOfDocument offset:targetCursorPostion];
    [self setSelectedTextRange:[self textRangeFromPosition:targetPostion toPosition:targetPostion]];
    
    return newText;
}

- (NSString*)unFormatText:(NSString*)formatText{
    if (formatText && self.separateLenArray && self.separatePlaceholder && ![self.separatePlaceholder isEqualToString:@""]) {
        return [formatText stringByReplacingOccurrencesOfString:self.separatePlaceholder withString:@""];
    }
    return formatText;
}

- (void)setText:(NSString *)text{
    _mInnerText = text;
    NSString* newText = [self formatText:text isInput:NO];
    [super setText:newText];
}

- (NSString*)text{
    _mInnerText = [self unFormatText:[super text]];
    return _mInnerText;
}

@end
