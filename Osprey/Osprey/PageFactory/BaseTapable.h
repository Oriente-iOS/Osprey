//
//  BaseTapable.h
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Aspects/Aspects.h>
#import "TapableEventObserverProtocol.h"
#import "TapableEvent.h"

/**
 事件流的基类
 */
@interface BaseTapable : RACChannel

/**
 添加订阅者

 @param subscribe 遵照TapableEventObserverProtocol 协议的订阅者对象
 */
-(void)addSubscribe:(id<TapableEventObserverProtocol>)subscribe;

/**
 发布内部监听到的事件

 @param x  事件元组
 */
-(void)publish:(id) x;
@end
