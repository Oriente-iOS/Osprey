#import "ALVCTransitionHelper.h"
/*动画效果*/
#import "ALFadeVCTransition.h"
#import "ALPushVCTransition.h"
#import "ALCoverVCTransition.h"
#import "ALBounceDownVCTransition.h"

/*手势效果*/
#import "ALHorizontalSwipeInteractionTransition.h"
#import "ALVerticalSwipeInteractionTransition.h"
#import "ALPinchInteractionTransition.h"

@interface ALVCTransitionHelper(){
    TRANSITION_TYPE                                 transitionType;
    ALBasicVCTransition*                            transitionAnim;
    INTERACTION_TYPE                                interactionType;
    ALBasicVCInteractiveTransition*                 interactiveTransitionAnim;
}
@end

NSMutableDictionary* animationTransitionDic;
NSMutableDictionary* interationTransitionDic;


@implementation ALVCTransitionHelper

+(void)initialize{
    animationTransitionDic =[NSMutableDictionary new];
    interationTransitionDic =[NSMutableDictionary new];
}

-(id)initWithTransitionType:(TRANSITION_TYPE)type{
    self = [super init];
    if (self) {
        transitionType=type;
        interactionType=INTERACTION_TYPE_DEFAULT;
        [self initParam];
    }
    return self;
}

-(id)initWithTransitionType:(TRANSITION_TYPE)type interactionType:(INTERACTION_TYPE)interType{
    self = [super init];
    if (self) {
        transitionType=type;
        interactionType=interType;
        [self initParam];
    }
    return self;
}


-(void)initParam{
    transitionAnim=[ALVCTransitionHelper createVCTransitionAnimationByType:transitionType];
    interactiveTransitionAnim=[ALVCTransitionHelper createVCInteractionTransitionAnimationByType:interactionType];
}


//for present view controller
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source{
    if(interactiveTransitionAnim){
         [interactiveTransitionAnim wireToViewController:presented forOperation:ALInteractionOperationDismiss];
    }
    
    if(transitionAnim){
        transitionAnim.reverse=NO;
    }
    return transitionAnim;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if(transitionAnim){
        transitionAnim.reverse=YES;
    }
    return transitionAnim;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return interactiveTransitionAnim && interactiveTransitionAnim.interactionInProgress ? interactiveTransitionAnim : nil;
}

+(id<UIViewControllerAnimatedTransitioning>)createVCTransitionAnimationByType:(TRANSITION_TYPE)type{
    id __transitionAnim;
#define anim_create(TRANSITION_TYPE_ENUM,TRANSITION_CLASS) {\
    __transitionAnim=animationTransitionDic[@(TRANSITION_TYPE_ENUM)];\
    if(!__transitionAnim){\
    __transitionAnim = [TRANSITION_CLASS new];\
    [animationTransitionDic setObject:__transitionAnim forKey:@(TRANSITION_TYPE_ENUM)];\
}}
    switch (type) {
        case TRANSITION_TYPE_PUSH_IN:anim_create(type,ALPushVCTransition)
            break;
        case TRANSITION_TYPE_FADE_IN:anim_create(type,ALFadeVCTransition)
            break;
        case TRANSITION_TYPE_COVER:anim_create(type,ALCoverVCTransition)
            break;
        case TRANSITION_TYPE_BOUNCE_DOWN:anim_create(type,ALBounceDownVCTransition)
            break;
        default:
            __transitionAnim=nil;
            break;
    }
    return __transitionAnim;
}

+(ALBasicVCInteractiveTransition*)createVCInteractionTransitionAnimationByType:(INTERACTION_TYPE)type{
    id __transitionAnim;
#define anim_create_interact(TRANSITION_TYPE_ENUM,TRANSITION_CLASS)  {\
    __transitionAnim=interationTransitionDic[@(TRANSITION_TYPE_ENUM)];\
    if(!__transitionAnim){\
    __transitionAnim = [TRANSITION_CLASS new];\
    [interationTransitionDic setObject:__transitionAnim forKey:@(TRANSITION_TYPE_ENUM)];\
}}
    switch (type) {
        case INTERACTION_SWIPE_HORIZONTAL:anim_create_interact(type,ALHorizontalSwipeInteractionTransition);
            break;
        case INTERACTION_SWIPE_VERTICAL:anim_create_interact(type,ALVerticalSwipeInteractionTransition);
            break;
        case INTERACTION_PINCH:anim_create_interact(type,ALPinchInteractionTransition);
            break;
        default:
            __transitionAnim=nil;
            break;
    }
    return __transitionAnim;
}

+(TRANSITION_TYPE)aniamtionTransitionType:(ALBasicVCTransition *)tranistion {
    if ([tranistion isMemberOfClass:[ALPushVCTransition class]]) {
        return TRANSITION_TYPE_PUSH_IN;
    }else if([tranistion isMemberOfClass:[ALFadeVCTransition class]]){
        return TRANSITION_TYPE_FADE_IN;
    }else if ([tranistion isMemberOfClass:[ALCoverVCTransition class]]){
        return TRANSITION_TYPE_COVER;
    }else if ([tranistion isMemberOfClass:[ALBounceDownVCTransition class]]){
        return TRANSITION_TYPE_BOUNCE_DOWN;
    }else{
        return TRANSITION_TYPE_DEFAULT;
    }
}


@end
