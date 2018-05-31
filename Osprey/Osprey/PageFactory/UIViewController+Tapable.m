//
//  UIViewController+Tapable.m
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "UIViewController+Tapable.h"
#import <objc/runtime.h>

@implementation UIViewController (Tapable)

-(void)setTapable:(BaseTapable *)tapable {
    objc_setAssociatedObject(self, @selector(tapable), tapable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BaseTapable *)tapable {
    return objc_getAssociatedObject(self, _cmd);
}

@end
