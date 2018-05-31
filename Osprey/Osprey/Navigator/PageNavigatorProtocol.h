//
//  PageNavigatorProtocol.h
//  OrienteBase
//
//  Created by mino on 2018/1/2.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TabController;
extern NSString* const kPageReuseFlag;
extern NSString* const kPageReuseAssociateKey;
extern NSString* const kPageFromPage;
extern NSString* const kPagePushAnimated;

@protocol PageNavigatorProtocol <NSObject>


/**
  页面是否需要自己定制化

 @param navigatorViewController  当前页面栈所在的navigator
 @param tabController  如果应用使用了OrienteBase 提供的Tabbar 在毁掉中会收到该参数
 @param params  传递的参数
 @return 如果自定义了Navigator的行为，需要返回YES， 否则返回NO,调用默认的Navigator行为
 */
-(BOOL)customizeNaivgatorImplement:(UINavigationController*)navigatorViewController
                     tabController:(TabController*)tabController
                            params:(NSDictionary*)params;

@optional;

/**
 当params 中的kPageReuseFlag 为YES,表示需要复用该页面,调用该方法返回复用页面的实例

 @param navigatorViewController 当前页面栈所在的navigator
 @param tabController 如果应用使用了OrienteBase 提供的Tabbar 在毁掉中会收到该参数
 @param params 传递的参数 一般从kPageReuseAssociateKey 中获取判断标志
 @return 返回复用的viewController 实例
 */
+(UIViewController*)findPageWhenReuse:(UINavigationController*)navigatorViewController
                        tabController:(TabController*)tabController
                               params:(NSDictionary*)params;

@end
