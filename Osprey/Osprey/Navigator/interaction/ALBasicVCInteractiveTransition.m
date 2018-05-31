#import "ALBasicVCInteractiveTransition.h"

@implementation ALBasicVCInteractiveTransition

- (void)wireToViewController:(UIViewController *)viewController forOperation:(ALInteractionOperation)operation {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
}
@end
