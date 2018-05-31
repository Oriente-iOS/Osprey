//
//  TabItem.h
//  OrienteBase
//
//  Created by mino on 2017/12/28.
//  Copyright © 2017年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TabItemConfiguration.h"

@class TabController;


/**
 配置Tabbar 子项的控制类
 */
@interface TabItem : NSObject

/**
 设置Item 所承载的RootViewController
 */
@property(nonatomic,strong,readwrite) UIViewController* rootViewController;
/**
 用于生成ItemView 用于设置当前的按钮
 */
@property(nonatomic,strong,readonly) UIView *itemView;

/**
 表示当前Item的ID类型
 */
@property (nonatomic,assign) NSUInteger  catergoryID;


/**
 构造方法

 @param tabController  构造参数，Tabbar的控制器类型
 @return TabItem实例对象
 */
-(id)initWithTabController:(TabController*)tabController;


/**
 配置当前Item的属性

 @param configuration tabItem的配置项
 */
-(void)setItemConfiguration:(TabItemConfiguration*)configuration;


/**
 获取当前Item 对应的UINavigationController 实例

 @return  当前Item 对应的UINavigationController的实例
 */
-(UINavigationController*)itemNavigator;


/**
 对应TabItemView的点击事件 RACChannelTerminal

 @return 对应的RACChannelTermianl
 */
-(RACChannelTerminal *)itemEventChannel;
@end
