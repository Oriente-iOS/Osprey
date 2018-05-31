//
//  NSString+formatInitInstanceMethods.m
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "NSString+formatInitInstanceMethods.h"


@implementation NSString (formatInitInstanceMethods)


-(NSString*)initialMethodStringFormatWithPrefix:(NSString*)prefix{
    NSMutableString* prefix1 = prefix.mutableCopy;
    NSArray *array = [self componentsSeparatedByString:@"_"];
    for (NSString* component in array) {
        NSString *head = [component substringToIndex:1];
        NSString *tails = [component substringFromIndex:1];
        [prefix1 appendFormat:@"%@%@",[head uppercaseString],tails ];
    }
    [prefix1 appendString:@":"];
    return prefix1.copy;
}
@end
