//
//  TabItemConfiguration.h
//  OrienteBase
//
//  Created by mino on 2017/12/28.
//  Copyright © 2017年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 抽象类
 用于配置对应的TabItem
 */
@interface TabItemConfiguration : NSObject

/**
 TabItem 对应页面的根视图
 */
@property(nonatomic,strong) UIViewController* viewController;

/**
 TabItem 的分类ID
 */
@property (nonatomic,assign) NSUInteger  catergoryID;




/**
  abstract methods

 @param button  tabItem 的视图实际是一个button,传入该button实例用于绘制返回的View
 @return 返回要显示的view
 */
-(UIView*)itemViewWithInnerButton:(UIButton*)button;

@end
