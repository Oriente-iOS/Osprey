//
//  UIViewController+Navigator.h
//  OrienteBase
//
//  Created by mino on 2018/1/2.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageNavigatorProtocol.h"

@class ALBasicVCTransition;
@class ALBasicVCInteractiveTransition;

@interface UIViewController (Navigator)<PageNavigatorProtocol>


/**
  页面切换的转场动画
 */
@property(nonatomic,strong)ALBasicVCTransition* animationTransition;

/**
  页面切换的转场手势
 */
@property(nonatomic,strong)ALBasicVCInteractiveTransition* interactiveTransition;




@end
