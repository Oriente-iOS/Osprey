//
//  UIViewController+PageRouter.h
//  OrienteBase
//
//  Created by mino on 2018/1/2.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
   于PageRoute 相关的辅助类
 */
@interface UIViewController (PageRouter)



/**
 根据PageUrl 进行跳转

 @param pageURL 注册页面的URL
 @return  返回跳转成功的标志
 */
-(BOOL)routeToPageURL:(NSURL*)pageURL;



/**
  根据base URL 和参数进行访问

 @param baseURLString   查找页面的Url
 @param params  参数
 @return  返回值
 */
-(BOOL)routeToPageBaseURLString:(NSString*)baseURLString params:(NSDictionary*)params;

/**
 根据URLString 进行跳转

 @param pageURLString  URLString
 @return  返回跳转成功的标志
 */
-(BOOL)routeToPageURLString:(NSString*)pageURLString;
@end
