//
//  UIViewController+PageRouter.m
//  OrienteBase
//
//  Created by mino on 2018/1/2.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "UIViewController+PageRouter.h"
#import "UIViewController+Navigator.h"
#import "PageFactory.h"
#import "NSString+PathHelper.h"
#import "BaseRouter.h"
#import "TabViewController.h"
#import "UIViewController+PageParams.h"

NSString* const kPageFromPage = @"Oriente_Base_kPageFromPage";
@implementation UIViewController (PageRouter)


-(BOOL)routeToPageBaseURLString:(NSString*)baseURLString params:(NSDictionary*)params{
    NSURL* url = [NSURL URLWithString:baseURLString];
    NSString* classString = [[BaseRouter defaultRouter]routerToPageWithURL:url];
    Class klass = NSClassFromString(classString);
    if ([klass isSubclassOfClass:[UIViewController class]]) {
        //获取TabViewController的实例
        TabViewController* tabViewController = [[PageFactory defaultFactory]intialPageWithClassNameString:[[BaseRouter defaultRouter] routerToPageWithURL:[NSURL URLWithString:@"base://tabviewcontroller"]] withParams:@{PageInjectionForbidden:@(YES)}];
        UIViewController* vc = nil;
        if ([params[kPageReuseFlag] boolValue] == YES) {
            // todo BaseVCPage
            vc = [klass findPageWhenReuse: self.navigationController tabController:tabViewController.tabController params:params];
        }else{
            vc = [[PageFactory defaultFactory] intialPageWithClassNameString:classString withParams:params];
        }
        if (vc != nil) {
            if (![vc customizeNaivgatorImplement:self.navigationController tabController:tabViewController.tabController params:params]) {
                // 默认的行为，当前栈Push
                if (self.navigationController != nil) {
                    BOOL animated = YES;
                    if (params[kPagePushAnimated]) {
                        animated = [params[kPagePushAnimated] boolValue];
                    }
                    if ([params[kPageReuseFlag] boolValue]) {
                        if ([self.navigationController.childViewControllers containsObject:vc]){
                            [self.navigationController popToViewController:vc animated:animated];
                        }else{
                            [self.navigationController pushViewController:vc animated:animated];
                        }
                    }else{
                    [self.navigationController pushViewController:vc animated:animated];
                    }
                }
                return YES;
            }else{
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL)routeToPageURL:(NSURL*)pageURL{
    NSDictionary* queryParams = [pageURL.query queryComponents];
    NSMutableDictionary* params = @{kPageFromPage:self}.mutableCopy;
    [params addEntriesFromDictionary:queryParams];
    NSString* classString = [[BaseRouter defaultRouter]routerToPageWithURL:pageURL];
    Class klass = NSClassFromString(classString);

    if ([klass isSubclassOfClass:[UIViewController class]]) {
        //获取TabViewController的实例
        TabViewController* tabViewController = [[PageFactory defaultFactory]intialPageWithClassNameString:[[BaseRouter defaultRouter] routerToPageWithURL:[NSURL URLWithString:@"base://tabviewcontroller"]] withParams:@{PageInjectionForbidden:@(YES)}];
        UIViewController* vc = nil;
        if ([params[kPageReuseFlag] boolValue] == YES) {
            // todo BaseVCPage
           vc = [klass findPageWhenReuse: self.navigationController tabController:tabViewController.tabController params:params];
        }else{
            vc = [[PageFactory defaultFactory] intialPageWithClassNameString:classString withParams:params];
        }
        if (vc != nil) {
            if (![vc customizeNaivgatorImplement:self.navigationController tabController:tabViewController.tabController params:params]) {
                // 默认的行为，当前栈Push
                if (self.navigationController != nil) {
                    BOOL animated = YES;
                    if (params[kPagePushAnimated]) {
                        animated = [params[kPagePushAnimated] boolValue];
                    }
                    if ([params[kPageReuseFlag] boolValue]) {
                        if ([self.navigationController.childViewControllers containsObject:vc]){
                            [self.navigationController popToViewController:vc animated:animated];
                        }else{
                            [self.navigationController pushViewController:vc animated:animated];
                        }
                    }else{
                        [self.navigationController pushViewController:vc animated:animated];
                    }
                }
                return YES;
            }else{
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL)routeToPageURLString:(NSString*)pageURLString{
    return  [self routeToPageURL:[NSURL URLWithString:pageURLString]];
}
@end
