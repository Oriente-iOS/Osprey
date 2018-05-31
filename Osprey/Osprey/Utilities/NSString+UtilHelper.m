//
//  NSString+UtilHelper.m
//  OrienteBase
//
//  Created by mino on 2018/1/8.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "NSString+UtilHelper.h"
#import <CommonCrypto/CommonCrypto.h>

NSUInteger  const MD5_DIGEST_LENGTH = 16 ;
@implementation NSString (UtilHelper)


-(NSString*)toMD5String {
    if (self.length == 0) {
        return nil;
    }
      const char* original_str = (const char *)[[self dataUsingEncoding:NSUTF8StringEncoding] bytes];
      unsigned  char digist[MD5_DIGEST_LENGTH];
      CC_MD5(original_str, (uint)strlen(original_str), digist);
      NSMutableString* outPutStr = [NSMutableString new];
      for(int  i =0; i<MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x",digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
      }
     return outPutStr;
}
@end
