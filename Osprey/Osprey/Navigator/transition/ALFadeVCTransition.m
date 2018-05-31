#import "ALFadeVCTransition.h"

@implementation ALFadeVCTransition
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView*)containerView fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    //STEP 1:Set my duration default is 1.0
    self.duration =.6f;
    // Add the two VC views to the container. Hide the to
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    toView.alpha = 0.0;
    //fromView.alpha = 1.0;
    //Perform the animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:0
                     animations:^{
                         toView.alpha = 1.f;
                         //fromView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         if ([transitionContext transitionWasCancelled]) {
                             [toView removeFromSuperview];
                             toView.alpha=0;
                         } else {
                             // reset from- view to its original state
                             [fromView removeFromSuperview];
                         }
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
}

@end
