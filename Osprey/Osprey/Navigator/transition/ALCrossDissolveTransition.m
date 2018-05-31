//
//  ALCrossDissolveTransition.m
//  OrienteBase
//
//  Created by mino on 2018/1/17.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "ALCrossDissolveTransition.h"

@interface ALCrossDissolveTransition()
@property(nonatomic,assign)  BOOL isClockWise;
@end

@implementation ALCrossDissolveTransition

-(instancetype)initWithClockwise:(BOOL)clockwise{
    if (self = [super init]) {
        self.isClockWise = clockwise;
    }
    return self;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView*)containerView fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    //STEP 1:Set my duration default is 1.0
    self.duration =0.62f;
    // Add the two VC views to the container. Hide the to
    [containerView addSubview:toView];
    UIViewAnimationOptions option = kNilOptions;
    if (self.isClockWise) {
        option = self.reverse?UIViewAnimationOptionTransitionFlipFromRight:UIViewAnimationOptionTransitionFlipFromLeft;
    }else{
        option = self.reverse?UIViewAnimationOptionTransitionFlipFromLeft:UIViewAnimationOptionTransitionFlipFromRight;
    }
    [UIView transitionFromView:fromView toView:toView duration:[self transitionDuration:transitionContext] options:option completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [toView removeFromSuperview];
        } else {
            // reset from- view to its original state
            [fromView removeFromSuperview];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
    //Perform the animation

    
}

@end
