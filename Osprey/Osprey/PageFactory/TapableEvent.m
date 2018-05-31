//
//  TapableEvent.m
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "TapableEvent.h"

@interface PageTapableEvent:TapableEvent
@end
@implementation PageTapableEvent
@end

@interface SwitchTabTapableEvent:TapableEvent
@end
@implementation SwitchTabTapableEvent
@end

@interface AppTapableEvent:TapableEvent
@end
@implementation AppTapableEvent
@end


@interface DisplayTapableEvent:TapableEvent
@end
@implementation DisplayTapableEvent
@end

@interface TapableEvent()
@property(nonatomic,assign,readwrite)NSInteger event;
@property(nonatomic,assign) NSUInteger identifier;
@end

@implementation TapableEvent
static NSUInteger generateIdentifer(NSUInteger hash){
    static NSUInteger seed;
    static NSMutableDictionary* dictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        seed = 0;
        dictionary = @{}.mutableCopy;
    });
    NSUInteger ret = 0;
    @synchronized (dictionary) {
        if (!dictionary[@(hash)]) {
            dictionary[@(hash)] = @(seed ++);
        }
        ret = [dictionary[@(hash)] integerValue];
    }
    return ret;
}


-(id)initWithEvent:(NSInteger)event {
    if (self =[super init]) {
        self.event = event;
    }
    return self;
}

- (NSUInteger)hash
{
    // 支持8个互斥事件的缘由
    return  (generateIdentifer([[self class]hash]) << 3) + _event;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![other isMemberOfClass:[self class]]) {
        return NO;
    } else {
        return self.event == ((TapableEvent *) other).event;
    }
}
-(id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone]initWithEvent:self.event];
}


#pragma mark -- Tapable Factory Methods

+(TapableEvent *)pageEvent:(PageEvent)pageEvent {
    return [[PageTapableEvent alloc]initWithEvent:pageEvent];
}

+(TapableEvent *)switchEvent:(SwitchEvent)switchEvent{
    return [[SwitchTabTapableEvent alloc]initWithEvent: switchEvent];
}

+(TapableEvent *)appEvent:(AppEvent)appEvent {
    return [[AppTapableEvent alloc]initWithEvent:appEvent];
}
+(TapableEvent *)displayEvent:(DisplayEvent)displayEvent{
    return [[DisplayTapableEvent alloc]initWithEvent:displayEvent];
}

@end
