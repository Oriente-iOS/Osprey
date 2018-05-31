#import "ALCoverVCTransition.h"

@implementation ALCoverVCTransition
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView*)containerView fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    //STEP 1:Set my duration default is 1.0
    self.duration =.4f;
    // Add the two VC views to the container. Hide the to
    if(!self.reverse){
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
    }else{
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
    }
    [self animateInToView:toView fromView:fromView];
    //Perform the animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self animateOutToView:toView fromView:fromView];
                     }
                     completion:^(BOOL finished) {
                         if ([transitionContext transitionWasCancelled]) {
                             [self animateInToView:toView fromView:fromView];
                         } else {
                             if(!self.reverse){
//                                 [fromView removeFromSuperview];
                             }else{
                                 [fromView removeFromSuperview];
                             }
                         }
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
}

-(void)animateInToView:(UIView*)toView fromView:(UIView*)fromView{
    if(!self.reverse){
//        toView.frame = CGRectMake(toView.x, toView.y, toView.frame.origin, <#CGFloat height#>)
        CGRect newframe = toView.frame;
        newframe.origin.x = [UIScreen mainScreen].bounds.size.width;
        toView.frame = newframe;
    }else{
        CGRect newframe = fromView.frame;
        newframe.origin.x = 0.0f;
        fromView.frame = newframe;
    }
    
}

-(void)animateOutToView:(UIView*)toView fromView:(UIView*)fromView{
    if(!self.reverse){
        //        toView.frame = CGRectMake(toView.x, toView.y, toView.frame.origin, <#CGFloat height#>)
        CGRect newframe = toView.frame;
        newframe.origin.x = 0.0f;
        toView.frame = newframe;
    }else{
        CGRect newframe = fromView.frame;
        newframe.origin.x = [UIScreen mainScreen].bounds.size.width;
        fromView.frame = newframe;
    }
    
}

@end
