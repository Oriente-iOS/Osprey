//
//  NSString+formatInitInstanceMethods.h
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 将以"_"连接的命名方式转换为以prefix为前缀的小驼峰命名方式
 */
@interface NSString (formatInitInstanceMethods)

/**
 @brief 将以下划线相连的方法命名格式转换为以给定前缀的小驼峰方法命名方式
 @param prefix 给定的前缀字符串值
 @return 返回小驼峰命名方法的字符串
 */
-(NSString*)initialMethodStringFormatWithPrefix:(NSString*)prefix;
@end
