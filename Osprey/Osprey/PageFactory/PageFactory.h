//
//  PageFactory.h
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 页面实例化的工厂类
 */
@interface PageFactory : NSObject


/**
 类方法： 获取默认的页面工厂句柄

 @return 返回PageFactory的单例实例
 */
+(PageFactory*)defaultFactory;

/**
 根据类名字符串值与要传入的参数返回对应的UIViewController的实例

 @param classNameString  类名的字符串值
 @param params 字典类型的参数
 @return 相应class的UIViewController的实例
 */
-(__kindof UIViewController*)intialPageWithClassNameString:(NSString*)classNameString withParams:(NSDictionary*)params;
@end
