//
//  NavigationBarDescription.h
//  OrienteBase
//
//  Created by mino on 2018/1/22.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 需要渲染函数:
 1.navigatorBar的背景颜色
 2.navigatorBar的分割线颜色
 3.navigatorBar的title的Attributes
 4.navigatorBar的返回按钮样式
 5. navigationBar 是否隐藏
 Opaque 表示不同明度 1 - alpha
 */
@interface NavigationBarDescription : NSObject

@property(nonatomic,strong) NSString* navigatorBarHexColor; //对应NaivagtionBar的BackgroundImage
@property(nonatomic,strong) NSString* splitLineHexColor;  // 对应NaivagtionBar 的shadowImage
@property(nonatomic,assign) CGFloat   navigatorBarOpaque;
@property(nonatomic,assign) CGFloat   splitLineOpaque;
@property(nonatomic,assign) CGFloat   titleFontSize; //对应title的Size
@property(nonatomic,strong) NSString* titleForegroundHexColor; //对应title的颜色
@property(nonatomic,assign) CGFloat   titleForegroundOpaque;
@property(nonatomic,strong) NSString* backButtonImageName;
@property(nonatomic,assign) BOOL ishidden;

@end
