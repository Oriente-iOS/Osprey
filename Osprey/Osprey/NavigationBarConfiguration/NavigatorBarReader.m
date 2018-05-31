//
//  NavigatorBarReader.m
//  OrienteBase
//
//  Created by mino on 2018/1/23.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "NavigatorBarReader.h"
#import "NavigationBarDescription.h"
#import "NSString+UIHelper.h"
#import "UIImage+UtilHelper.h"

@implementation NavigatorBarReader



-(NavigatorBarReader*)navigationBarBackground{
    return [self bind:^Reader *(UINavigationController *a) {
        return [NavigatorBarReader createReader:^id(NavigationBarDescription *x) {
            NSString* colorHex = x.navigatorBarHexColor;
            CGFloat alpha = 1 - x.navigatorBarOpaque;
            [a.navigationBar setBackgroundImage:[UIImage imageWithUIColor:[colorHex hexStringtoColorWithAlpha:alpha]] forBarMetrics:UIBarMetricsDefault];
            return a;
        }];
    }];
}




-(NavigatorBarReader*)navigationBarSplit{
    return [self bind:^Reader *(UINavigationController *a) {
        return [NavigatorBarReader createReader:^id(NavigationBarDescription *x) {
            NSString* colorHex = x.splitLineHexColor ;
            CGFloat alpha = 1 - x.splitLineOpaque;
            [a.navigationBar setShadowImage:[UIImage imageWithUIColor:[colorHex hexStringtoColorWithAlpha:alpha] size:CGSizeMake(CGRectGetWidth(a.navigationBar.bounds), 0.6)]];
            return a;
        }];
    }];
}

-(NavigatorBarReader*)navigationBarTitleAttributes{
    return [self bind:^Reader *(UINavigationController *a) {
        return [NavigatorBarReader createReader:^id(NavigationBarDescription *x) {
            CGFloat fontSize = x.titleFontSize;
            NSString* fontColorHex = x.titleForegroundHexColor;
            CGFloat fontAlpha = 1 - x.titleForegroundOpaque;
            NSDictionary* textAttributes = @{NSFontAttributeName :[UIFont systemFontOfSize:fontSize],
                                             NSForegroundColorAttributeName : [fontColorHex hexStringtoColorWithAlpha:fontAlpha]
                                             };
            [a.navigationBar setTitleTextAttributes:textAttributes];
            return a;
        }];
    }];
}

-(NavigatorBarReader*)navigationBarBackStyle{
    return [self bind:^Reader *(UINavigationController *a) {
        return [NavigatorBarReader createReader:^id(NavigationBarDescription *x) {
        //[a.navigationItem.backBarButtonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -) forBarMetrics:UIBarMetricsDefault];
            if (x.backButtonImageName) {
                UIImage* img = [UIImage imageNamed:x.backButtonImageName];
                img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [a.navigationBar setBackIndicatorImage:img];
                [a.navigationBar setBackIndicatorTransitionMaskImage:img];
            }
            return a;
        }];
    }];
}

-(NavigatorBarReader*)navigaitonBarHidden{
    return [self bind:^Reader *(UINavigationController *a) {
        return [NavigatorBarReader createReader:^id(NavigationBarDescription *x) {
            BOOL isHidden = x.ishidden;
            [a setNavigationBarHidden:isHidden];
            return a;
        }];
    }];
}

@end
