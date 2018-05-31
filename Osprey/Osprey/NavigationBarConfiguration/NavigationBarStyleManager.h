//
//  NavigationBarStyleManager.h
//  OrienteBase
//
//  Created by mino on 2018/1/22.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NavigationBarStyleManager : NSObject

@property(nonatomic,weak,readonly) UINavigationController* navigationController;

/**
 初始化方法

 @param navigationController 初始化的navigationController
 @return 返回NaivagtionBarStyleManager 的实例
 */
-(instancetype)initWithNavigation:(UINavigationController*)navigationController;

/**
  默认的Configuration
 */
-(void)defaultConfiguration;

/**
选择当前的NavigationBar的样式

@param navigationBarStyleName  传入配置的NavigationBar的样式
*/
-(void)navigationBarStyle:(NSString*)navigationBarStyleName;

/**
 返回注册的NavigationBar注册的BarDecription 对应类名(String)与常用名

 @return 返回 {BarDescription的类名: 常用名}
 */
-(NSDictionary*)navigationBarDescriptionRegistry;


@end
