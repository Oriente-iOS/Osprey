#import "ALBasicVCInteractiveTransition.h"

@interface ALHorizontalSwipeInteractionTransition : ALBasicVCInteractiveTransition

/**
 Indicates whether a navigation controller 'pop' should occur on a right-to-left, or a left-to-right
 swipe. This property does not affect tab controller or modal interactions.
 */
@property (nonatomic) BOOL popOnRightToLeft;
@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic, strong) UIViewController *presentingVC;
@end
