//
//  AppEventTapable.m
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "AppEventTapable.h"

@implementation AppEventTapable

+(BaseTapable *)appEventTapable{
    return [[AppEventTapable alloc]init];
}


-(id)init {
    if (self = [super init]) {
        @weakify(self);
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
            @strongify(self);
            
            [self publish: RACTuplePack([TapableEvent appEvent:AppFinishedLaunch])];
        }];
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self publish: RACTuplePack([TapableEvent appEvent:AppBecomeActive])];
        }];
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillResignActiveNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self publish: RACTuplePack([TapableEvent appEvent:AppResignActive])];
        }];
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self publish: RACTuplePack([TapableEvent appEvent:AppEnterForeground])];
        }];
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self publish: RACTuplePack([TapableEvent appEvent:AppEnterBackground])];
        }];
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillTerminateNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self publish: RACTuplePack([TapableEvent appEvent:AppTerminate])];
        }];
    }
    return self;
}
@end
