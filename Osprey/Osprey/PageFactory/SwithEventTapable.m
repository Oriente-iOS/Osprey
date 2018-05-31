//
//  SwithEventTapable.m
//  OrienteBase
//
//  Created by mino on 2018/1/19.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "SwithEventTapable.h"
#import "TabController.h"
#import "BaseRouter.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PageFactory.h"
#import "UIViewController+PageParams.h"

@interface SwithEventTapable()
@property(nonatomic,strong) TabController *tabController;
@end

@implementation SwithEventTapable


-(instancetype)initWithTabController:(TabController*)tabController{
    if (self = [super init]) {
        self.tabController = tabController;
        @weakify(self);
        [[self.tabController.switchEventSignal takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id x) {
            @strongify(self);
            [self publish:x];
        }];
    }
    return self;
}


+(BaseTapable *)switchTabTapable{
    TabViewController* tabViewController = [[PageFactory defaultFactory]intialPageWithClassNameString:[[BaseRouter defaultRouter] routerToPageWithURL:[NSURL URLWithString:@"base://tabviewcontroller"]] withParams:@{PageInjectionForbidden:@(YES)}];
    if (tabViewController != nil) {
        return [[SwithEventTapable alloc]initWithTabController:tabViewController.tabController];
    }else{
        return nil;
    }
}


@end
