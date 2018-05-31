//
//  UINavigationController+NavigationBarStyle.m
//  OrienteBase
//
//  Created by mino on 2018/1/22.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "UINavigationController+NavigationBarStyle.h"
#import "NavigationBarStyleManager.h"
#import <objc/runtime.h>
@implementation UINavigationController (NavigationBarStyle)


-(NavigationBarStyleManager*)navigationBarStyleManager{
    return objc_getAssociatedObject(self, _cmd);
}


-(void)setNavigationBarStyleManager:(NavigationBarStyleManager *)navigationBarStyleManager{
    objc_setAssociatedObject(self, @selector(navigationBarStyleManager), navigationBarStyleManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
