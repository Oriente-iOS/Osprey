#import "ALNavigationControllerDelegate.h"
#import "ALBasicVCInteractiveTransition.h"
#import "ALBasicVCTransition.h"
@interface ALNavigationControllerDelegate(){
    TRANSITION_TYPE                     transitionType;
    ALBasicVCTransition*                transitionAnim;
    INTERACTION_TYPE                    interactionType;
    ALBasicVCInteractiveTransition*     interactiveTransitionAnim;
}

@end

@implementation ALNavigationControllerDelegate
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


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if(interactiveTransitionAnim){
        [interactiveTransitionAnim wireToViewController:toVC forOperation:ALInteractionOperationPop];
    }
    
    if(transitionAnim){
        transitionAnim.reverse= (operation == UINavigationControllerOperationPop);
    }
    return transitionAnim;
}
// must return not nil from navigationController:animationControllerForOperation:fromViewController:
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                        interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    
    id ret = interactiveTransitionAnim &&interactiveTransitionAnim.interactionInProgress ? interactiveTransitionAnim: nil;
    return ret;
}



@end
