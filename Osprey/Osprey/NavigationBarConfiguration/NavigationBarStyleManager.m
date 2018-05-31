//
//  NavigationBarStyleManager.m
//  OrienteBase
//
//  Created by mino on 2018/1/22.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "NavigationBarStyleManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UIKit/UIKit.h>
#import "NavigationBarDescription.h"
#import "NavigatorBarReader.h"

@interface NavigationBarStyleManager ()
@property(nonatomic,weak,readwrite)UINavigationController* navigationController;
@property(nonatomic,strong)NSMutableDictionary* despsMap; //藐视的Map

@end

@implementation NavigationBarStyleManager


-(instancetype)initWithNavigation:(UINavigationController *)navigationController{
    if (self = [super init]) {
        self.navigationController = navigationController;
        self.despsMap = @{}.mutableCopy;
        [self defaultConfiguration];
        NSDictionary* stypeMap = [self navigationBarDescriptionRegistry];
        [self.despsMap addEntriesFromDictionary:stypeMap?:@{}];
    }
    return self;
}


-(void)navigationBarStyle:(NSString *)navigationBarStyleName{
    if (navigationBarStyleName.length == 0) {
        return;
    }
    // 获取barDesciption的index;
    NavigationBarDescription* barDescription = self.despsMap[navigationBarStyleName];
    //开始对navigationBar 进行渲染
    [NavigatorBarReader pure:self.navigationController]
    .navigationBarBackground //渲染navigar的backgroundColor
    .navigationBarSplit  // 渲染navigator的下滑线
    .navigationBarTitleAttributes //渲染title的Attribute
    .navigationBarBackStyle //渲染返回按钮的样式
    .navigaitonBarHidden   //渲染是否需要隐藏
    .reader(barDescription);
}

-(void)defaultConfiguration{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"method should be overrided by subClass" userInfo:nil];
}


-(NSDictionary*)navigationBarDescriptionRegistry{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"method should be overrided by subClass" userInfo:nil];
}
@end
