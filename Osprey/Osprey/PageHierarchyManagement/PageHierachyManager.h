//
//  PageHierachyManager.h
//  OrienteBase
//
//  Created by mino on 2018/1/3.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const MainPageWillDisplayNotification ;

@class PageHierachyManager;

@protocol PageHireachyManagerDelegate <NSObject>

@property(nonatomic,weak) PageHierachyManager* manager;


/**
  在启动的时候是否需要显示

 @return  返回Bool参数
 */
-(BOOL)shoudDisplayAtLaunch;

@optional;

/**
 自定义动画
 当页面dismiss 时候，实现该接口，可以完成动画的转场
 @param fromView 当前显示的页面视图
 @param toView  结束后要显示的视图
 */
-(void)dismissTransitionFromView:(UIView*)fromView toView:(UIView*)toView;
@end
/**
  用于做页面级别管理的类
 */
@interface PageHierachyManager : NSObject

/**
  baseViewContoller
 */
@property(nonatomic,strong,readonly) UIViewController* rootViewController;

@property(nonatomic,strong,readonly) NSMutableArray* hierachVCs;

/**
 初始化

 @param mainPage  用于承载业务展示的基础视图
 @return  PageHireachy实例
 */
-(instancetype)initWithMainPage:(UIViewController*)mainPage;


/**
 注册显示的栈，按照LIFO 显示传入的视图

 @param vc  传入的视图
 @param ... 传入的视图序列
 */
-(void)registerHierachViewController:(UIViewController<PageHireachyManagerDelegate>*)vc, ... NS_REQUIRES_NIL_TERMINATION;



/**
 从当前hireach 当中移除

 @param page  要移除的页面
 */
-(void)removeFromHierach:(UIViewController*)page;

@end
