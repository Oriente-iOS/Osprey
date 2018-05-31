//
//  BasePageFilter.m
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "BasePageFilter.h"
#import <objc/runtime.h>

@interface BasePageFilter()
@property(nonatomic,strong)NSMutableDictionary* eventHandlers;
@end

@implementation BasePageFilter
-(instancetype)init {
    if (self = [super init]) {
        self.eventHandlers = @{}.mutableCopy;
    }
    return self;
}

-(void)registerEvent:(TapableEvent *)event withSel:(SEL)selector{
    [self.eventHandlers setObject: NSStringFromSelector(selector)  forKey:event];
}

+(BOOL)isSingleton{
    return NO;
}

#pragma mark -- protocols
-(void)receiveEvent:(TapableEvent *)event withArguments:(NSArray *)arguments {
    NSString* selString = self.eventHandlers[event];
    if (selString == nil) return;
    SEL selector = NSSelectorFromString(selString);
    if (![self respondsToSelector:selector]) return;
    NSMethodSignature* signature =  [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    NSInteger numberOfArguments  = signature.numberOfArguments;
    for (int i = 2; i < numberOfArguments; i++) {
        const char *argType = [signature getArgumentTypeAtIndex:i];
        if(i - 2 > arguments.count ) break;
        id eventArgument = arguments[i-2];
        if (strcmp(argType, @encode(void (^)(void))) == 0){
            id block = nil;
            block = [eventArgument copy];
            [invocation setArgument:&block atIndex:i];
        } else if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0|| [@(argType) hasPrefix:@"@"]){
            [invocation setArgument:&eventArgument atIndex:i];
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
                  || [@(argType) hasPrefix:@"{"]){
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(argType, &valueSize, NULL);
            unsigned char valueBytes[valueSize];
            [eventArgument getValue:valueBytes];
            [invocation setArgument:valueBytes atIndex:i];
        }
    }
    [invocation invokeWithTarget:self];
}

@end
