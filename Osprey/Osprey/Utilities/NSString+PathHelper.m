//
//  NSString+PathHelper.m
//  OrienteBase
//
//  Created by mino on 2018/1/2.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "NSString+PathHelper.h"

@implementation NSString (PathHelper)

-(NSDictionary*)queryComponents{
    if (self.length == 0) {
        return @{}.mutableCopy;
    }
    NSMutableDictionary* tmpDic = @{}.mutableCopy;
     NSArray *paramArr = [self componentsSeparatedByString:@"&"];
    [paramArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
         NSArray *paramPair = [obj componentsSeparatedByString:@"="];
        if (paramPair.count == 2) {
             NSString *key = [[paramPair firstObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
             NSString *value = [[paramPair lastObject]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [tmpDic setValue:value forKey:key];
        }
    }];
    return tmpDic;
}
@end
