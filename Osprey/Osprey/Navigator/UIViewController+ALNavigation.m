#import "UIViewController+ALNavigation.h"
#import "ALBasicVCTransition.h"
#import "ALBasicVCInteractiveTransition.h"
#import "ALVCTransitionHelper.h"
#import "ALNoneInteractiveTransition.h"
#import <objc/runtime.h>




@implementation UIViewController (ALNavigation)
- (void)setAlAnimationTransition:(ALBasicVCTransition*)__transition {
    objc_setAssociatedObject(self, @selector(alAnimationTransition), __transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(ALBasicVCTransition*)alAnimationTransition{
    ALBasicVCTransition* transition =  objc_getAssociatedObject(self, @selector(alAnimationTransition));
    if(!transition){
        transition = [ALVCTransitionHelper createVCTransitionAnimationByType:TRANSITION_TYPE_PUSH_IN];
        [self setAlAnimationTransition:transition];
    }
    return  transition;
}


- (void)setAlInteractiveTransition:(ALBasicVCInteractiveTransition*)__transition {
    objc_setAssociatedObject(self, @selector(alInteractiveTransition), __transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(ALBasicVCInteractiveTransition*)alInteractiveTransition{
    ALBasicVCInteractiveTransition* transition =  objc_getAssociatedObject(self, @selector(alInteractiveTransition));
    if(!transition) {
        transition = [ALVCTransitionHelper createVCInteractionTransitionAnimationByType:INTERACTION_SWIPE_HORIZONTAL];
        [self setAlInteractiveTransition:transition];
    }
    if ([transition isMemberOfClass:[ALNoneInteractiveTransition class]]) {
        return nil;
    }
    return  transition;
}


@end
