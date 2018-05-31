//
//  TabViewController.h
//  OrienteBase
//
//  Created by mino on 2017/12/28.
//  Copyright © 2017年 mino. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabController;

/**
  抽象类
  相当于系统的TabbarViewController
  用于NavigationViewControllers的容器
 */
@interface TabViewController : UIViewController

/**
  持有的TabController的对象
 */
@property(nonatomic,strong,readonly) TabController *tabController;


/**
  切换Tab 触发页面切换的回调

 @param viewController 当前TabItem对应的默认NavigationController
 */
-(void)defaultNavigationViewController:(UINavigationController*)viewController;


/**
  用于子类实现，根据传入的Tabbar原始视图，可以定制化Tabbar展示样式

 @param tabContainerView  tabbar 原始视图
 */
-(void)customizeTabContainerView:(UIView*)tabContainerView;


/**
  子类实现，返回配置的tabController对象

 @param tabController 当前的TabViewController 使用，作为构造TabController实例的参数
 @return 返回对应TabController的实例对象
 */
+(TabController*)defaultTabControllerWithTabViewController:(__kindof TabViewController*)tabController;

@end
