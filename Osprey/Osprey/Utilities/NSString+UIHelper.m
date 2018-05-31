//
//  NSString+UIHelper.m
//  OrienteBase
//
//  Created by mino on 2018/1/8.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "NSString+UIHelper.h"

@implementation NSString (UIHelper)


-(UIColor*)hexStringtoColorWithAlpha:(CGFloat)alpha{
    NSString* cString = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]uppercaseString];
    if ([cString length] < 6) {
        return  [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f)     blue:((float) b / 255.0f) alpha:alpha];
}

-(UIColor*)hexStringtoColor{
    return [self hexStringtoColorWithAlpha:1.0f];
}


-(NSAttributedString*)attributesWithFontSize:(CGFloat)fontSize fontColor:( nonnull UIColor*)fontColor{
  return  [self attributesWithFontSize:fontSize fontColor:fontColor customizeParaStyle:nil];
}

-(NSAttributedString*)attributesWithFontSize:(CGFloat)fontSize fontColor:( nonnull UIColor *)fontColor  customizeParaStyle:(void(^)(NSMutableParagraphStyle* paragraph))block{
    if (self == nil) {
        return nil;
    }
    NSMutableParagraphStyle * paragraph = [NSMutableParagraphStyle new];
    if (fontSize >11.999 && fontSize < 12.001) {
        paragraph.lineSpacing = 6.f;
    }else if (fontSize > 13.999 && fontSize < 14.001){
        paragraph.lineSpacing = 8.f;
    }else if (fontSize > 15.999 && fontSize < 16.001){
        paragraph.lineSpacing = 8.f;
    }
    if (block) {
        block(paragraph);
    }
    NSDictionary* attributes = @{NSParagraphStyleAttributeName:paragraph,
                                 NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                 NSForegroundColorAttributeName: fontColor
                                 };
    return [[NSAttributedString alloc]initWithString:self attributes:attributes];
}


@end
