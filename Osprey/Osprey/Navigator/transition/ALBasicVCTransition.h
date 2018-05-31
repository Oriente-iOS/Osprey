#import <UIKit/UIKit.h>
@interface ALBasicVCTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic) BOOL                  reverse;    /*The direction of the animation.*/
@property (nonatomic) NSTimeInterval        duration;   /*The animation duration.*/
@property (nonatomic,weak) id               targetVC;
//@property (nonatomic) NSInteger             subType;    /*次类型*/

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext containerView:(UIView*)containerView fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView;
@end


