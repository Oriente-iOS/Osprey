//
//  BasePageFilter.h
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SparrowMacro.h"
#import "BaseTapable.h"
#import "TapableEventObserverProtocol.h"


/**
 用于在托管于PageFactory的页面中配置Filter

 @param filter  filter 的类名
 @return  返回字符串名
 */
#define PageFilter(filter) \
+(NSString*)SPARROWCONCAT(base_page_filter_, __LINE__){\
return @__STRING(filter) ;\
}\


/**
 用于作为PreFilter 协议参数的cps类型

 @param redirectPageClass  要重定向的类名
 @param params  需要传递的参数
 */
typedef void(^PageFilterAsyncCall)(Class redirectPageClass, NSDictionary* params);

/**
 PreFilter 遵循的协议
 配置宏如下：
 filterType(prologue);
 在ViewController未被实例化之前调用
 传入值为要实例化的PageClass 与要传入的参数
 在处理完成需要触发传入的回调，回调参数为(PageClass => 可以改写实例化的VC,params => 可以改写传入的params)
 */
@protocol PreInitialPageFilterProtocol


/**
 PageFactory 触发页面配置的PreFilter的回调。
 可用于做注册Tapable事件，页面重定向，传参覆盖等功能

 @param pageClass  Page的Class值
 @param params  传入PageFactory的参数
 @param filterCall  cps, 必须同步触发回调
 可以传入重定向的类名与新修改的参数;
 如果不执行该回调，配置页面之后的preFilter的回调函数全部阻断
 */
-(void) onPageFilterCall:(Class) pageClass params:(NSDictionary*)params callback: (PageFilterAsyncCall) filterCall;

@end


/**
 PostFilter 遵循的协议
 配置宏如下：
 filterType(epilogue);
 在viewController 被实例化之后，没有被显示之前
 传入值为已经实例化后的viewController 与对应的params
 可以修改params 中的内容，但是不能在改变viewController的实例
 主要用于做一些简单的处理，一般用于注册page声明周期的事件，调用
 -(void) registerEvent:(PageLifeEvent)event withSelector:(SEL)sel;
 注册对应事件的回调方法
 */
@protocol PostInitialPageFilterProtocol


/**
 PageFactory 触发页面配置的PostFilter的回调。
 可用于做注册Tapable事件，传参修改等功能

 @param viewController  Filter所属页面的实例
 @param params filter 之间传递的的页面参数
 */
-(void)onPageFilterCall:(UIViewController*) viewController params:(NSMutableDictionary*)params;

@end



/**
 PageFilter 的基类
 遵循 TapableEventObserverProtocol 协议,
 通过PageFactory生成的页面，所有配置的Filter 都注册到该页面的tapable中去了
 */
@interface BasePageFilter : NSObject<TapableEventObserverProtocol>


/**
 注册需要响应的事件，在hook方法内部调用

 @param event  事件的类型
 @param selector 响应事件类型的SEL, 参数类型与个数要与事件分发的元组的元素长度与元素类型匹配
 */
-(void)registerEvent:(TapableEvent *)event withSel:(SEL)selector;


/**
 设置Filter 是否为单例的，如果Filter无状态可复用建议配置为单例模式

 @return  返回Bool值 YES表示单例Filter
 */
+(BOOL)isSingleton;



@end
