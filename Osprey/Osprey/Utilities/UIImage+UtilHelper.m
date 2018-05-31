//
//  UIImage+UtilHelper.m
//  OrienteBase
//
//  Created by mino on 2018/1/23.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "UIImage+UtilHelper.h"

@implementation UIImage (UtilHelper)

+(UIImage*)imageWithUIColor:(UIColor*)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    //开始
    UIGraphicsBeginImageContext(rect.size);
    //获取画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //清空
    UIGraphicsEndImageContext();
    
    return image;
}


+(UIImage*)imageWithUIColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    //开始
    UIGraphicsBeginImageContext(rect.size);
    //获取画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //清空
    UIGraphicsEndImageContext();
    
    return image;
}

@end
