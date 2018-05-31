//
//  PropertiesParserDelegate.m
//  OrienteBase
//
//  Created by mino on 2018/1/2.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "PropertiesParserDelegate.h"

@interface PropertiesParserDelegate()

@property(nonatomic,weak) id<PropertiesParserResultProtocol> delegate;
@end

@implementation PropertiesParserDelegate

-(id)initWithDelegate:(id<PropertiesParserResultProtocol>)delegte;
{
    if (self = [super init]) {
        self.delegate = delegte;
    }
    return self;
}

-(void)parserWithConfigurationPath:(NSString*)urlPath{
     NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
     NSError* error;
     NSString* configurationContent = [NSString stringWithContentsOfFile:urlPath encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
         NSArray *mappingItems = [configurationContent componentsSeparatedByString:@"\n"];
        for (NSString * item in mappingItems) {
            if ([item containsString:@"="]) {
                NSString *pattern = @"^[^#]*";
                NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
                NSTextCheckingResult * result = [regex firstMatchInString:item options:kNilOptions range:NSMakeRange(0, item.length)];
                NSString* subString = [item substringWithRange:[result range]];
                NSArray<NSString*>* pairArray = [subString componentsSeparatedByString:@"="];
                if (pairArray.count == 2) {
                    NSString* key = [pairArray[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    NSString* value = [pairArray[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    [tmpDict setValue:value forKey:key];
                }
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(parseSucceed:)]) {
            [self.delegate parseSucceed:tmpDict];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(parseFailed:)]) {
            [self.delegate parseFailed:error];
        }
    }
}



@end
















