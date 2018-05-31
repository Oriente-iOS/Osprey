//
//  UIViewController+PageParams.h
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SparrowMacro.h"



/**
 声明通过PageFactory装载的页面为单例的方法

 @param flag  YES 表示单例页面的声明，默认为NO
 @return  返回声明值
 */
#define IsSingletonPage(flag) \
+(BOOL) page_isSingleton{\
return flag;\
}\

// 页面是否可以进行属性注入标识的KEY值
extern NSString* const  PageInjectionForbidden ;

@interface UIViewController (PageParams)


/**
  所有通过PageFactory 传入的params 都可以通过该属性取得
 */
@property(nonatomic,strong)NSDictionary* requestParams;


/**
 遵照KVC的规范为页面的properties注入params中的键值

 @param params 传入的符合KVC标准的字典对象
 */
-(void)settersInjection:(NSDictionary*)params;
@end
