//
//  DisplayEventTapable.m
//  OrienteBase
//
//  Created by mino on 2018/1/16.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "DisplayEventTapable.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PageHierachyManager.h"
#import "TapableEvent.h"

@implementation DisplayEventTapable

+(BaseTapable *) displayEventTapable {
    return [[DisplayEventTapable alloc]init];
}



-(id)init{
    if (self = [super init]) {
         @weakify(self);
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:MainPageWillDisplayNotification object:nil]
          takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification* x) {
            @strongify(self);
            [self publish:RACTuplePack([TapableEvent displayEvent:DisplayMain])];
        }];
    }
    return self;
}
@end
