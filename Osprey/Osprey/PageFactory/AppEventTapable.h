//
//  AppEventTapable.h
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "BaseTapable.h"

@interface AppEventTapable : BaseTapable
/**
 生成用于触发当前页面应用生命周期事件的tapable
 
 @return 生成的tapable实例
 */
+(BaseTapable *)appEventTapable;
@end
