#import "ALHorizontalSwipeInteractionTransition.h"
//UIViewController默认有个转场动画设置

@implementation ALHorizontalSwipeInteractionTransition {
    BOOL _shouldCompleteTransition;
    __weak UIViewController *_viewController;/*不weak可能造成memory leak*/
    UIPanGestureRecognizer *_gesture;
    ALInteractionOperation _operation;
}

-(void)dealloc {
    [_gesture.view removeGestureRecognizer:_gesture];
}

- (void)wireToViewController:(UIViewController *)viewController forOperation:(ALInteractionOperation)operation{
    self.popOnRightToLeft = NO;
    _operation = operation;
    _viewController = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}


- (void)prepareGestureRecognizerInView:(UIView*)view {
//    _gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    [view addGestureRecognizer:_gesture];
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    //设置从什么边界滑入
    edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:edgePanGestureRecognizer];
}

- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer {
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGPoint vel = [gestureRecognizer velocityInView:gestureRecognizer.view];
    
    CGFloat progress = [gestureRecognizer translationInView:_viewController.view].x / (_viewController.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));//把这个百分比限制在0~1之间
    
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            BOOL rightToLeftSwipe = vel.x < 0;
            
            if (_operation == ALInteractionOperationPop) {
                if ((self.popOnRightToLeft && rightToLeftSwipe) ||
                    (!self.popOnRightToLeft && !rightToLeftSwipe)) {
                    self.interactionInProgress = YES;
                    [_viewController.navigationController popViewControllerAnimated:YES];
                }
            } else {
                // for dismiss, fire regardless of the translation direction
                self.interactionInProgress = YES;
                [_viewController dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (self.interactionInProgress) {
                CGFloat fraction = fabs(translation.x / 200.0);
                fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                _shouldCompleteTransition = (fraction > 0.5);
                if (progress >= 1.0)
                    progress = 0.99;
                
                [self updateInteractiveTransition:progress];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (self.interactionInProgress) {
                self.interactionInProgress = NO;
                if (!_shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                    [self cancelInteractiveTransition];
                  
                }
                else {
                    [_viewController.navigationController popViewControllerAnimated:YES];
                    [self finishInteractiveTransition];
                  
                }
            }
            break;
        default:
            break;
    }
}


@end
