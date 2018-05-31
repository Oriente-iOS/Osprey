#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ALInteractionOperation) {
    /*
     Indicates that the interaction controller should start a navigation controller 'pop' navigation.
     */
    ALInteractionOperationPop,
    /**
     Indicates that the interaction controller should initiate a modal 'dismiss'.
     */
    ALInteractionOperationDismiss
};
@interface ALBasicVCInteractiveTransition : UIPercentDrivenInteractiveTransition
@property (nonatomic, assign) BOOL interactionInProgress;
- (void)wireToViewController:(UIViewController*)viewController forOperation:(ALInteractionOperation)operation;
@end
