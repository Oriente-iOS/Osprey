//
//  UIViewController+Navigator.m
//  OrienteBase
//
//  Created by mino on 2018/1/2.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "UIViewController+Navigator.h"
#import <objc/runtime.h>
#import "ALBasicVCTransition.h"
#import "ALNoneInteractiveTransition.h"
#import "ALVCTransitionHelper.h"
#import "PageFactory.h"
#import "UIViewController+PageParams.h"

NSString* const kPageReuseFlag = @"Oriente_Base_kPageReuseFlag";
NSString* const kPageReuseAssociateKey = @"Oriente_Base_kPageReuseFlag";
NSString* const kPagePushAnimated = @"Oriente_Base_kPagePushAnimated";

@implementation UIViewController (Navigator)

-(void)setAnimationTransition:(ALBasicVCTransition *)animationTransition {
    objc_setAssociatedObject(self, @selector(animationTransition), animationTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(ALBasicVCTransition *)animationTransition {
    ALBasicVCTransition* transition = objc_getAssociatedObject(self, _cmd);
    if (!transition) {
        transition = [ALVCTransitionHelper createVCTransitionAnimationByType:TRANSITION_TYPE_PUSH_IN];
        [self setAnimationTransition:transition];
    }
    return transition;
}

-(void)setInteractiveTransition:(ALBasicVCTransition *)interactiveTransition{
    objc_setAssociatedObject(self, @selector(interactiveTransition), interactiveTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(ALBasicVCInteractiveTransition *)interactiveTransition {
    ALBasicVCInteractiveTransition* interactiveTransition = objc_getAssociatedObject(self, _cmd);
    if (!interactiveTransition) {
        if ([ALVCTransitionHelper aniamtionTransitionType:self.animationTransition] == TRANSITION_TYPE_PUSH_IN) {
            interactiveTransition = [ALVCTransitionHelper createVCInteractionTransitionAnimationByType:INTERACTION_SWIPE_HORIZONTAL];
            [self setInteractiveTransition:interactiveTransition];
        }else{
            return nil;
        }
    }
    return interactiveTransition;
}


-(BOOL)customizeNaivgatorImplement:(UINavigationController *)navigatorViewController tabController:(TabController *)tabController params:(NSDictionary *)params{
    // 子类在需要的情况下复写
    return NO;
}


+(UIViewController *)findPageWhenReuse:(UINavigationController *)navigatorViewController tabController:(TabController *)tabController params:(NSDictionary *)params{
    // 默认行为在当前navigationViewController 查找栈中存在于navigation名字相同的ViewController
    NSArray* currentPageStack =  [navigatorViewController viewControllers];
    NSInteger count = currentPageStack.count;
    if (count > 0) {
        UIViewController* vc = nil;
        for (NSInteger i = count -1;  i >= 0; i--) {
            if ([currentPageStack[i] isMemberOfClass:[self class]]) {
                vc = currentPageStack[i];
                [vc settersInjection:params];
                break;
            }
        }
        return vc?:[[PageFactory defaultFactory] intialPageWithClassNameString:NSStringFromClass([self class]) withParams:params];
        
    }else{
        return [[PageFactory defaultFactory] intialPageWithClassNameString:NSStringFromClass([self class]) withParams:params];
    }
    
}
@end
