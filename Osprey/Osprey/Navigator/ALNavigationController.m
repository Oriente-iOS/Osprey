#import "ALNavigationController.h"
#import "ALVCTransitionHelper.h"
#import "ALBasicVCInteractiveTransition.h"

#import "UIViewController+Navigator.h"
#import <objc/runtime.h>

@interface ALNavigationDelegate(){
    ALBasicVCTransition *mAnimatedTransition;
    ALBasicVCInteractiveTransition *mInteractiveTransition;
}

@end
@implementation ALNavigationDelegate
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                        interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
            id ret = mInteractiveTransition&&mInteractiveTransition.interactionInProgress ? mInteractiveTransition: nil;
            return ret;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    //push由toVC决定动画，返回的时候是fromVC(就是push时候的toVC做决定)
    UIViewController* targetVC = toVC;
    BOOL isReverse = operation == UINavigationControllerOperationPop;
    if(isReverse){
        targetVC = fromVC;
    }
    //设置动画
    ALBasicVCTransition* transitionAnim = targetVC.animationTransition;
    transitionAnim.reverse=isReverse;
    mAnimatedTransition=transitionAnim;
   
    return mAnimatedTransition;
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    mInteractiveTransition=viewController.interactiveTransition;
    if(mInteractiveTransition)
        [mInteractiveTransition wireToViewController:viewController forOperation:ALInteractionOperationPop];
}
@end

@interface ALNavigationController(){
    ALNavigationDelegate* retainAlNavigationDelegate;
}
@end

@implementation ALNavigationController
-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    //error级别限制无法使用关联对象保持
    retainAlNavigationDelegate = [[ALNavigationDelegate alloc]init] ;
    self.delegate = retainAlNavigationDelegate;
    return self;
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
  //  [self.navigationBar.topItem recordBarState:self.navigationBar];//保存导航栏状态
    [super pushViewController:viewController animated:animated];
}

-(UIViewController*)popViewControllerAnimated:(BOOL)animated{
    //恢复导航栏状态
  //  [self recoverNavigationBarAfterPop:(self.viewControllers.count - 2)];
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    //恢复导航栏状态
 //   [self recoverNavigationBarAfterPop:0];
    return [super popToRootViewControllerAnimated:animated];
}


- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
 //   [self recoverNavigationBarAfterPop:[self.viewControllers indexOfObject:viewController]];
    return [super popToViewController:viewController animated:animated];
}


//-(id<UINavigationControllerDelegate>) delegate {
//    return retainAlNavigationDelegate;
//}

#pragma mark --

- (void)recoverNavigationBarAfterPop:(NSInteger) index{
    //    index = (index >= 0)?index:0;
    //    //判断数组越界
    //    if (self.navigationBar.items.count > index) {
    //        UINavigationItem *lastItem = self.navigationBar.items[index];
    //        [lastItem recoverBarState:self.navigationBar];
    //    }
}

@end
