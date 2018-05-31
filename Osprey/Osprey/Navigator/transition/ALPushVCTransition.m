#import "ALPushVCTransition.h"

@implementation ALPushVCTransition
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView*)containerView fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    //STEP 1:Set my duration default is 1.0
    self.duration =.4f;
    // Add the two VC views to the container. Hide the to
    [containerView addSubview:toView];
    [self animateInToView:toView fromView:fromView];
    //Perform the animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self animateOutToView:toView fromView:fromView];
                     }
                     completion:^(BOOL finished) {
                         if ([transitionContext transitionWasCancelled]) {
                             [toView removeFromSuperview];
                             [self animateInToView:toView fromView:fromView];
                         } else {
                             // reset from- view to its original state
                             [fromView removeFromSuperview];
                         }
                         fromView.alpha = 1.0f;
                         toView.alpha = 1.0f;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];



}

-(void)animateInToView:(UIView*)toView fromView:(UIView*)fromView{
    if(!self.reverse){
        toView.alpha = 0.4;
        [self setViewLeft:[UIScreen mainScreen].bounds.size.width view:toView];
        fromView.alpha=1.0f;
        [self setViewLeft:0.0f view:fromView];
    }else{
        toView.alpha = .4f;
        [self setViewLeft:-1*[UIScreen mainScreen].bounds.size.width view:toView];
        fromView.alpha=1.0f;
        [self setViewLeft:0.0f view:fromView];
    }
    
}

-(void)animateOutToView:(UIView*)toView fromView:(UIView*)fromView{
    if(!self.reverse){
        toView.alpha= 1.0f;
        [self setViewLeft:0.0f view:toView];
        fromView.alpha=.4f;
        [self setViewLeft:-1*[UIScreen mainScreen].bounds.size.width view:fromView];
    }else{
        toView.alpha = 1.0f;
        [self setViewLeft:0.0f view:toView];
        fromView.alpha=.4f;
        [self setViewLeft:[UIScreen mainScreen].bounds.size.width view:fromView];
    }
}

-(void)setViewLeft:(CGFloat)left view:(UIView*)view{
    CGRect newframe = view.frame;
    newframe.origin.x = left;
    view.frame = newframe;
}

@end
