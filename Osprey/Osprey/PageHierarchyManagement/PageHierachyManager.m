//
//  PageHierachyManager.m
//  OrienteBase
//
//  Created by mino on 2018/1/3.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "PageHierachyManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

NSString* const MainPageWillDisplayNotification = @"Oriente_Base_MainPageWillDisplayNotification";

@interface PageHierachyManager()
@property(nonatomic,strong,readwrite)UIViewController* rootViewController;
@property(nonatomic,strong) NSMutableArray* hierachVCs;
@end

@implementation PageHierachyManager



-(instancetype)initWithMainPage:(UIViewController*)mainPage {
    if (self = [super init]) {
        self.rootViewController = [[UIViewController alloc]init];
        self.rootViewController.view.backgroundColor = [UIColor whiteColor];
        [self addPage:mainPage];
        self.hierachVCs = @[].mutableCopy;
        
    }
    
    return self;
}



-(void)registerHierachViewController:(UIViewController<PageHireachyManagerDelegate>*)vc, ... NS_REQUIRES_NIL_TERMINATION {
      va_list args;
      va_start(args, vc);
    for (UIViewController<PageHireachyManagerDelegate>* currentVC = vc;
         currentVC != nil; currentVC = va_arg(args, UIViewController<PageHireachyManagerDelegate>*)){
         currentVC.manager = self;
        if([currentVC shoudDisplayAtLaunch]){
            [self addPage:currentVC];
        }
    }
    va_end(args);
    //增加一个事件
    [[[self.rootViewController rac_signalForSelector:@selector(viewDidAppear:)] zipWith:[RACObserve(self, hierachVCs) filter:^BOOL(NSArray* value) {
        return value.count == 0;
    }]]subscribeNext:^(id x) {
        [[NSNotificationCenter defaultCenter] postNotificationName: MainPageWillDisplayNotification object:nil userInfo:nil];
    }] ;
    
}

-(void)removeFromHierach:(UIViewController*)page{
    [self removePage:page];
}

#pragma mark -- privateMethods

-(UIViewController*)prePage:(UIViewController*)page {
    NSInteger idx =  [self.hierachVCs indexOfObject:page];
    return (idx - 1 > 0)?self.hierachVCs[idx -1]:[self.rootViewController.childViewControllers firstObject];
}

-(void)addPage:(UIViewController*)page {
    if (page == nil) {
        return;
    }
    [self.rootViewController addChildViewController:page];
    [page didMoveToParentViewController:self.rootViewController];
    [self.rootViewController.view addSubview:page.view];
    [self.hierachVCs addObject:page];
}

-(void)removePage:(UIViewController*)page {
    if (page == nil) {
        return;
    }
    if ([self.rootViewController.childViewControllers lastObject] == page) {
        [page willMoveToParentViewController:nil];
        __weak PageHierachyManager* weakSelf = self;
        UIViewController* preViewController = [self prePage:page];
        [UIView animateWithDuration:1 animations:^{
            if ([page conformsToProtocol:@protocol(PageHireachyManagerDelegate) ]){
                if([((id<PageHireachyManagerDelegate>) page) respondsToSelector:@selector(dismissTransitionFromView:toView:)]){
                    [((id<PageHireachyManagerDelegate>) page)dismissTransitionFromView:page.view toView:preViewController.view];
                }
            }
        } completion:^(BOOL finished) {
            [page.view removeFromSuperview];
            [page removeFromParentViewController];
            page.view.transform = CGAffineTransformIdentity;
            page.view.alpha = 1;
            NSIndexSet *indexes = [self.hierachVCs indexesOfObjectsPassingTest:^BOOL(id  obj, NSUInteger idx, BOOL *dstop) {
                return obj == page;
            }];
            if (indexes.count == 0) {
                return ;
            }
            [weakSelf willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@keypath(weakSelf.hierachVCs)];
            [weakSelf.hierachVCs removeObject:page];
             [weakSelf didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@keypath(weakSelf.hierachVCs)];
        }];
    }
    
    
}


@end
