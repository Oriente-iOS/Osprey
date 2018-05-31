#import <UIKit/UIKit.h>
#import "ALVCTransitionHelper.h"
@interface ALNavigationControllerDelegate:NSObject<UINavigationControllerDelegate>{
}
-(id)initWithTransitionType:(TRANSITION_TYPE)type;
-(id)initWithTransitionType:(TRANSITION_TYPE)type interactionType:(INTERACTION_TYPE)interType;
@end

