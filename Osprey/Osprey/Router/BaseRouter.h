//
//  BaseRouter.h
//  OrienteBase
//
//  Created by mino on 2018/1/2.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseRouter : NSObject


/**
  BaseRouter 的单例

 @return  返回单例实例
 */
+(BaseRouter*)defaultRouter;


/**
 注册写有路由配置的propetites文件
 注册格式 "路径" = "对应的ClassName"
 路径分割用 "."

 @param filePath  propetites 文件的路径
 */
-(void)registerConfigrationFilePath:(NSString*)filePath;


/**
 根据pageURL 查找对应路由的注册页面

 @param pageURL  想要查找的页面的URL
 @return  返回对应的ClassName
 */
-(NSString*)routerToPageWithURL:(NSURL*)pageURL;

-(NSString*)routeToPageWithURLString:(NSString*)pageURLString;

@end
