//
//  CompoundTapable.h
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "BaseTapable.h"


/**
 用于组合多个BaseTapable的具体实现
 */
@interface CompoundTapable : BaseTapable


/**
 CompoundTapable 的实例化类方法

 @return 返回CompoundTapable的实例
 */
+(instancetype)compoundTapable;


/**
 向compoundTapable 中添加BaseTapable实现类

 @param tapable  支持某一类事件的实现类
 */
-(void)addTapable:(BaseTapable*)tapable;

/**
 从compoundTapable中删除指定的tapable实例

 @param tapable 指定的tapable实例
 */
-(void)removeTapable:(BaseTapable*)tapable;

//todo 增加dispose

@end
