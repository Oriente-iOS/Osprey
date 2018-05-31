//
//  TapableEventObserverProtocol.h
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TapableEvent;
@class BaseTapable;


/**
  Tapable 订阅者所遵循的接口协议
 */
@protocol TapableEventObserverProtocol <NSObject>
@required

/**
 接受Tapalbe 分发事件的回调函数

 @param event 事件类型
 @param arguments  触发对应事件所传递的参数数组
 */
-(void)receiveEvent:(TapableEvent *)event withArguments: (NSArray *)arguments;
@end
