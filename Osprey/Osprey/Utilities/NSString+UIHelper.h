//
//  NSString+UIHelper.h
//  OrienteBase
//
//  Created by mino on 2018/1/8.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 跟UI相关的help
 */
@interface NSString (UIHelper)


-(UIColor*)hexStringtoColorWithAlpha:(CGFloat)alpha;

-(UIColor*)hexStringtoColor;


-(NSAttributedString*)attributesWithFontSize:(CGFloat)fontSize fontColor:( nonnull UIColor*)fontColor;

-(NSAttributedString*)attributesWithFontSize:(CGFloat)fontSize fontColor:(nonnull UIColor *)fontColor  customizeParaStyle:(void(^)(NSMutableParagraphStyle* paragraph))block;
@end
