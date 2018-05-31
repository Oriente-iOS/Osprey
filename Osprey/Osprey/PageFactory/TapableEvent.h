//
//  TapableEvent.h
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 TapableEvent 中表示页面事件类型的枚举类型

 - PageLoaded: 页面初始加载时触发的事件
 - PageBecomeActive: 页面显示时触发的事件
 - PageResignActive: 页面消失后触发的事件
 - PageFinished: 页面被销毁后触发的事件
 - PageEventPlacehold: 占位
 */
typedef NS_ENUM(NSInteger,PageEvent) {
    PageLoaded = 0,
    PageBecomeActive,
    PageResignActive,
    PageFinished,
    PageActived,
    PageEventPlacehold
};


/**
  TapableEvent 中表示Tabbar切换事件类型的枚举类型

 - TabWillSwitch: Tabbar tab切换前触发的事件
 - TabDidSwitch: Tabbar  tab切换后触发的事件
 - TabSwitchPlacehold: 占位
 */
typedef NS_ENUM(NSInteger,SwitchEvent) {
    TabWillSwitch = 0,
    TabDidSwitch,
    TabSwitchPlacehold
};

/**
 TapableEvent 中表示App声明周期事件类型的枚举类型

 - AppFinishedLaunch:  对应系统的 UIApplicationDidFinishLaunchingNotification 事件
 - AppBecomeActive: 对应系统的 UIApplicationDidBecomeActiveNotification 事件
 - AppResignActive:  对应系统的 UIApplicationWillResignActiveNotification 事件
 - AppEnterForeground: 对应系统的 UIApplicationWillEnterForegroundNotification 事件
 - AppEnterBackground: 对应系统的 UIApplicationDidEnterBackgroundNotification 事件
 - AppTerminate: 对应系统的 UIApplicationWillTerminateNotification 事件
 - AppEventPlacehold: 占位
 */
typedef NS_ENUM(NSInteger,AppEvent) {
    AppFinishedLaunch = 0,
    AppBecomeActive,
    AppResignActive,
    AppEnterForeground,
    AppEnterBackground,
    AppTerminate,
    AppEventPlacehold
};


typedef NS_ENUM(NSInteger,DisplayEvent){
    DisplayMain = 0,
    DisplayPlacehold
};

#pragma mark --  注意每个Tapable的event集合最多支持8个互斥事件

/**
 抽象工厂类
 */
@interface TapableEvent : NSObject <NSCopying>

/**
 表示event的具体类型
 */
@property(nonatomic,assign,readonly)NSInteger event;

/**
 根据event的具体类型生成TapableEvent的构造函数

 @param event  event 类型
 @return TapableEvent 的实例
 */
-(id)initWithEvent:(NSInteger)event;

/**
 处理PageEvent 的工厂方法

 @param pageEvent pageEvent 的具体类型
 @return  返回对应类型的实例
 */
+(TapableEvent *)pageEvent:(PageEvent)pageEvent;

/**
 处理SwitchEvent 的工厂方法
 
 @param switchEvent  switchEvent的具体类型
 @return  返回对应类型的实例
 */
+(TapableEvent *)switchEvent:(SwitchEvent)switchEvent;


/**
 处理 AppEvent 的工厂方法

 @param appEvent appEvent的具体类型
 @return 返回对应类型的实例
 */
+(TapableEvent *)appEvent:(AppEvent)appEvent;

+(TapableEvent *)displayEvent:(DisplayEvent)displayEvent;


@end
