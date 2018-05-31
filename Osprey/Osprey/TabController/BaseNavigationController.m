//
//  BaseNavigationController.m
//  OrienteBase
//
//  Created by mino on 2017/12/28.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "BaseNavigationController.h"
#import "NavigationBarConfigureProtocol.h"
#import "NavigationBarStyleManager.h"
#import "UINavigationController+NavigationBarStyle.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController


-(instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        if ([self conformsToProtocol:@protocol(NavigationBarConfigureProtocol)]) {
            id<NavigationBarConfigureProtocol> delegate = (id<NavigationBarConfigureProtocol>)self;
            if ([delegate respondsToSelector:@selector(navigationBarStyleManageClass)]) {
                Class  styleManangerClass =   [delegate navigationBarStyleManageClass];
                if ([styleManangerClass isSubclassOfClass:[NavigationBarStyleManager class]]) {
                    self.navigationBarStyleManager = [((NavigationBarStyleManager *)[styleManangerClass alloc]) initWithNavigation:self];
                }
            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
