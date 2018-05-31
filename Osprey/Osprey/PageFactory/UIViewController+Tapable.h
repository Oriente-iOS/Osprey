//
//  UIViewController+Tapable.h
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTapable.h"


/**
 UIViewController 的Category
 通过PageFactory构建的页面都会注入该分类对应的属性
 */
@interface UIViewController (Tapable)

/**
 实际为 CompoundTapable 类型的组合事件流实例
 包含了PageFactory 为每个页面默认配置的事件 一般包括:AppEventTapable,PageTapable
 如果添加自定义事件流，即可以通过覆盖tapable的setter 方法实现(不推荐) 也可以在viewDidload:中实现(推荐)
 */
@property(nonatomic,strong)BaseTapable* tapable;
@end
