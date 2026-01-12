//
//  UITextField+Select.m
//  JKCategories (https://github.com/shaojiankui/JKCategories)
//
//  Created by Jakey on 15/6/1.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "UITextField+JKSelect.h"

@implementation UITextField (JKSelect)
/**
 *  @brief  当前选中的字符串范围
 *
 *  @return NSRange
 */
- (NSRange)jk_selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}
/**
 *  @brief  选中所有文字
 */
- (void)jk_selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}
/**
 *  @brief  选中指定范围的文字
 *
 *  @param range NSRange范围
 */
- (void)jk_setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
//        if (action == @selector(copy:) || action == @selector(paste:) || action == @selector(select:) || action == @selector(selectAll:)){
//            return YES;
//        }
    //密码处不可以复制粘贴等操作  登录、注册、忘记密码、修改密码
    if (self.tag == 100001 ||
        self.tag == 100002 || self.tag == 100003 ||
        self.tag == 100004 || self.tag == 100005 ||
        self.tag == 100006 || self.tag == 100007 || self.tag == 100008) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
