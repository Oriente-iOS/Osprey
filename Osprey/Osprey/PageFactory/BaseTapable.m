//
//  BaseTapable.m
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "BaseTapable.h"
#import "NSArray+Functional.h"
#import "WeakDualTupe.h"
@implementation BaseTapable

-(id)init {
    if (self = [super init]){};
    return self;
}

-(void)addSubscribe:(id<TapableEventObserverProtocol>) subscribe {
    [self.leadingTerminal subscribeNext:^(RACTuple *x) {
        TapableEvent* event = x.last;
         NSMutableArray* arguments = x.allObjects.mutableCopy;
        [arguments removeLastObject];
       NSArray* args = [arguments flattenMap:^NSArray *(id x) {
            if ([x isKindOfClass:[WeakDualTupe class]]) {
                id first = ((WeakDualTupe*)x).first;
                id second = ((WeakDualTupe*)x).second;
                NSMutableArray* tmp = @[].mutableCopy;
                if (first) {[tmp addObject:first];}
                if (second){[tmp addObject:second];}
                return tmp;
            }else{
                return @[x];
            }
        }];
        if ([subscribe respondsToSelector:@selector(receiveEvent:withArguments:)]) {
            [subscribe receiveEvent:event withArguments:args];
        }
    }];
}

-(void)publish:(id)x {
    [self.leadingTerminal sendNext:x];
}

@end
