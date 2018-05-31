#import "ALBasicVCTransition.h"
@implementation ALBasicVCTransition

- (id)init {
    if (self = [super init]) {
        self.duration = 0.6f;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    __unused CGRect fromInitialFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect toFinalFrame = [transitionContext finalFrameForViewController:toVC];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    //fromView.frame = fromInitialFrame;
    toView.frame = toFinalFrame;
    UIView *containerView = [transitionContext containerView];
    [self animateTransition:transitionContext containerView:containerView fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView*)containerView fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}
@end
