//
//  PropertiesParserDelegate.h
//  OrienteBase
//
//  Created by mino on 2018/1/2.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Properties 解析所遵循的协议
 */
@protocol PropertiesParserResultProtocol <NSObject>


/**
  解析成功

 @param properities  key-value properties 值
 */
-(void)parseSucceed:(NSDictionary*)properities;


/**
 解析失败

 @param error  错误对象
 */
-(void)parseFailed:(NSError*)error;

@end


@interface PropertiesParserDelegate : NSObject


/**
 初始化方法

 @param delegte  传入代理
 @return  返回生成的实例
 */
-(id)initWithDelegate:(id<PropertiesParserResultProtocol>)delegte;


/**
 根据传入的Url 实现解析

 @param urlPath  配置文件的路径
 */
-(void)parserWithConfigurationPath:(NSString*)urlPath;

@end
