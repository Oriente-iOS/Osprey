#import <UIKit/UIKit.h>
@class ALBasicVCTransition;
@class ALBasicVCInteractiveTransition;
@interface UIViewController (ALNavigation)
@property (nonatomic, strong) ALBasicVCTransition *alAnimationTransition;
@property (nonatomic, strong) ALBasicVCInteractiveTransition *alInteractiveTransition;

@end

