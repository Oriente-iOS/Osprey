//
//  TabController.h
//  OrienteBase
//
//  Created by mino on 2017/12/28.
//  Copyright © 2017年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TabItem.h"
#import "TabViewController.h"
#import "SparrowMacro.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


extern CGFloat tabBarHeight;

/**
 TabController 插件要遵循的协议
 */
@protocol TabControllerTabSwitchProtocol <NSObject>
@required

/**
 对于tabController 会注册遵循LuTabControllerTabSwitchProtocol 的plugin
 该协议为plugin 要实现的回调函数
 @param tabController tabContoller 的句柄
 @param fromIndex  切换动作发生时from的Index
 @param toIndex  切换动作发生时要到的index
 @param continuation  回调函数，传入YES 表示可以切换，传入NO表示不进行切换,不调用则不进行切换
 */
-(void)processTabAction:(TabController*) tabController fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex  withContinuation:(void(^)(BOOL)) continuation;
@end


/**
  TabBar的控制器
 */
@interface TabController : NSObject

/**
 TabItem 的集合
 */
@property(nonatomic,strong,readonly) NSMutableArray* items;

/**
  当前Tab下对应的TabItem实例
 */
@property(nonatomic,strong,readonly) TabItem *currentTabItem;

/**
  对应的TabViewController容器
 */
@property (nonatomic,weak,readonly) TabViewController* tabViewController;


/**
 构造方法

 @param tabViewController  传入TabViewController 实例
 @return  返回实例对象
 */
-(id)initWithTabViewController:(TabViewController *)tabViewController;


/**
 添加TabItem

 @param item  TabItem 实例
 */
-(void)addTabItem:(TabItem *)item;

/**
 移除对应Index 的TabItem 对象

 @param index  要移除的TabItem的索引
 */
-(void)removeTabItemAtIndex:(NSInteger)index;

/**
 切换Tabbar的Index

 @param index 要切换的索引
 */
-(void)switchToTabItemIndex:(NSInteger)index;


/**
 为TabController增加插件

 @param firstPlugin   第一个参数
 @param ... 多参数
 */
-(void)tabControllerAddPlugins:(id<TabControllerTabSwitchProtocol>)firstPlugin, ... NS_REQUIRES_NIL_TERMINATION;


/**
 切换事件的信号

 @return  返回切换RACSignal信号，可以用于订阅该信号
 */
-(RACSignal *)switchEventSignal;

+(TabController*)appTabController;
@end
