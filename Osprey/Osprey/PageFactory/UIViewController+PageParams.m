//
//  UIViewController+PageParams.m
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "UIViewController+PageParams.h"
#import <objc/runtime.h>
#import <RegExCategories/RegExCategories.h>
#import "NSString+formatInitInstanceMethods.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

NSString* const  PageInjectionForbidden = @"PageInjectionForbidden";

@implementation UIViewController (PageParams)

-(void)setRequestParams:(NSDictionary *)requestParams {
    objc_setAssociatedObject(self, @selector(requestParams), requestParams, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSDictionary*) requestParams {
    return objc_getAssociatedObject(self, _cmd);
}

-(void)settersInjection:(NSDictionary*)params{
    BOOL prohibitInjection = [params[PageInjectionForbidden] boolValue];
    if (prohibitInjection) {
        return ;
    }
    NSMutableDictionary * posthookedPrams = @{}.mutableCopy;
    [params enumerateKeysAndObjectsUsingBlock:^(NSString* k, id v, BOOL *stop) {
        objc_property_t prop = class_getProperty([self class], k.UTF8String);
        if(!prop) {posthookedPrams[k] = v; return;};
        const char *attrs = property_getAttributes(prop);
        NSString* propertyAttributes = @(attrs);
        RxMatch* match = [RX(@",S([\\w:]+)") firstMatchWithDetails:propertyAttributes];
        RxMatchGroup* matchgroup = match.groups[1];
        NSString *customSetter = matchgroup.value;
        if(customSetter == nil) customSetter = [k initialMethodStringFormatWithPrefix:@"set"]; //如果customSetter 没有配置采用set这种方式注入
        if (customSetter) {
            SEL customSetterSEL = NSSelectorFromString(customSetter);
            if ( [[self class] instancesRespondToSelector:customSetterSEL]) {
                NSMethodSignature *signature = [self methodSignatureForSelector:customSetterSEL];
                NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
                [invocation setSelector:customSetterSEL];
                RxMatch* match = [RX(@"^T([^,]+),") firstMatchWithDetails:propertyAttributes];
                RxMatchGroup* matchgroup = match.groups[1];
                NSString *typeString = matchgroup.value;
                const char * argType = typeString.UTF8String;
                if (strcmp(argType, @encode(void (^)(void))) == 0){
                    id block = nil;
                    block = [v copy];
                    [invocation setArgument:&block atIndex:2];
                } else if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0|| [typeString hasPrefix:@"@"]){
                    [invocation setArgument:&v atIndex:2];
                }else if (strcmp(argType, @encode(char)) == 0||strcmp(argType, @encode(int)) == 0
                          ||strcmp(argType, @encode(short)) == 0||strcmp(argType, @encode(long)) == 0
                          ||strcmp(argType, @encode(long long)) == 0||strcmp(argType, @encode(unsigned char)) == 0
                          ||strcmp(argType, @encode(unsigned int)) == 0
                          ||strcmp(argType, @encode(unsigned short)) == 0
                          ||strcmp(argType, @encode(unsigned long)) == 0
                          ||strcmp(argType, @encode(unsigned long long)) == 0
                          ||strcmp(argType, @encode(float)) == 0
                          ||strcmp(argType, @encode(double)) == 0
                          ||strcmp(argType, @encode(BOOL)) == 0
                          ||strcmp(argType, @encode(char *)) == 0
                          || [typeString hasPrefix:@"{"]){
                    NSUInteger valueSize = 0;
                    NSGetSizeAndAlignment(argType, &valueSize, NULL);
                    unsigned char valueBytes[valueSize];
                    [v getValue:valueBytes];
                    [invocation setArgument:valueBytes atIndex:2];
                }else{
                    id arg = nil;
                    [invocation setArgument:&arg atIndex:2];
                }
                [invocation invokeWithTarget:self];
            }
        }else{
            [self setValue:v forKey:k];
        }
    }];
    self.requestParams = posthookedPrams;
}


@end
