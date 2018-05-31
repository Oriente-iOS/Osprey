#import "ALBounceDownVCTransition.h"
//#import "CAKeyframeAnimation+AHEasing.h"
@interface ALBounceDownVCTransition (){
}
@end

@implementation ALBounceDownVCTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView*)containerView fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    self.duration =1.0f;
    [containerView addSubview:toView];
    [self animateInToView:toView fromView:fromView];
    [UIView animateWithDuration:self.duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
         [self animateOutToView:toView fromView:fromView];
    } completion:^(BOOL finished) {
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
        [self setViewBottom: [UIScreen mainScreen].bounds.size.height view:toView];
        fromView.alpha=1.0f;
    }else{
        toView.alpha = .4f;
        fromView.alpha=1.0f;
        [self setViewBottom:0.0f view:fromView];
    }
    
}

-(void)animateOutToView:(UIView*)toView fromView:(UIView*)fromView{
    if(!self.reverse){
        toView.alpha= 1.0f;
        [self setViewBottom:0.0f view:toView];
        fromView.alpha=.4f;
    }else{
        toView.alpha = 1.0f;
        [self setViewBottom:0.0f view:toView];
        fromView.alpha=.4f;
        [self setViewBottom:[UIScreen mainScreen].bounds.size.width view:fromView];
    }
}

-(void)setViewBottom:(CGFloat)bottom view:(UIView*)view{
     CGRect newframe = view.frame;
    newframe.origin.y = bottom;
    view.frame = newframe;
}

@end
