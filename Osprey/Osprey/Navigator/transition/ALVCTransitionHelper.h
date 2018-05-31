#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TRANSITION_TYPE) {
    TRANSITION_TYPE_DEFAULT=-1,
    TRANSITION_TYPE_PUSH_IN,
    TRANSITION_TYPE_FADE_IN,
    TRANSITION_TYPE_COVER,
    TRANSITION_TYPE_BOUNCE_DOWN
};

typedef NS_ENUM(NSInteger,INTERACTION_TYPE) {
    INTERACTION_TYPE_DEFAULT=-1,
    INTERACTION_SWIPE_HORIZONTAL=0,
    INTERACTION_SWIPE_VERTICAL=1,
    INTERACTION_PINCH=2
};

@class ALBasicVCInteractiveTransition;
@class ALBasicVCTransition;
@interface ALVCTransitionHelper : NSObject<UIViewControllerTransitioningDelegate>
-(id)initWithTransitionType:(TRANSITION_TYPE)type;
-(id)initWithTransitionType:(TRANSITION_TYPE)type interactionType:(INTERACTION_TYPE)interType;

+(id<UIViewControllerAnimatedTransitioning>)createVCTransitionAnimationByType:(TRANSITION_TYPE)type;
+(TRANSITION_TYPE)aniamtionTransitionType:(ALBasicVCTransition *)tranistion;

+(ALBasicVCInteractiveTransition*)createVCInteractionTransitionAnimationByType:(INTERACTION_TYPE)type;
@end
