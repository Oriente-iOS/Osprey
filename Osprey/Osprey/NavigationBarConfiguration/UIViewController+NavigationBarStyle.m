//
//  UIViewController+NavigationBarStyle.m
//  OrienteBase
//
//  Created by mino on 2018/1/23.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "UIViewController+NavigationBarStyle.h"
#import <objc/runtime.h>
#import "UINavigationController+NavigationBarStyle.h"
#import "NavigationBarStyleManager.h"

@implementation UIViewController (NavigationBarStyle)





-(void)setNavigationBarStyleName:(NSString *)navigationBarStyleName{
    if (self.navigationController != nil) {
        [self.navigationController.navigationBarStyleManager navigationBarStyle:navigationBarStyleName];
    }
    objc_setAssociatedObject(self, @selector(navigationBarStyleName), navigationBarStyleName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)navigationBarStyleName{
    return objc_getAssociatedObject(self, _cmd);
}

@end
