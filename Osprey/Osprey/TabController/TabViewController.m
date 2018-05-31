//
//  TabViewController.m
//  OrienteBase
//
//  Created by mino on 2017/12/28.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "TabViewController.h"
#import "UIViewController+PageParams.h"
#import "PageFactory.h"
#import "TabItemConfiguration.h"
#import "TabController.h"
#import <Masonry/Masonry.h>

@interface TabViewController ()
@property(nonatomic,strong,readwrite) TabController *tabController;
@property(nonatomic,strong) UIViewController* currentViewController;
@property(nonatomic,strong) NSArray<TabItemConfiguration*>* tabItemConfigurations;
@end

@implementation TabViewController

//@dynamic tabItemConfigurations;

IsSingletonPage(YES)

-(instancetype)init {
    if (self = [super init]) {
        self.tabController = [[self class] defaultTabControllerWithTabViewController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated { [super viewWillAppear:animated];};
-(void)viewDidAppear:(BOOL)animated {[super viewDidAppear:animated];}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customizeTabContainerView:(UIView*)tabContainerView{}

-(void)defaultNavigationViewController:(UINavigationController *)viewController {
    if (self.currentViewController == viewController) {
        return;
    }
    if (self.currentViewController != nil) {
        [self removeCurrentViewController];
    } // 先移除当前的ViewController
    if (viewController != nil) {
        [self addCurrentViewController:viewController];
    }// 切换为当前的viewController
}


#pragma mark -- private methods


/**
 私有函数：为rootviewController 增加子viewController
 @param viewController  要增加的vc
 */
-(void)addCurrentViewController:(UIViewController*)viewController{
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    [self.view addSubview:viewController.view];
    [viewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.currentViewController = viewController;
}



/**
 移除当前的viewController
 
 @return  返回当前的viewController
 */
-(UIViewController *)removeCurrentViewController{
    UIViewController* previewController = nil;
    if (_currentViewController) {
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        previewController = self.currentViewController;
    }
    return previewController;
}

#pragma mark -- setter
// fake setter
-(void)setTabItemConfigurations:(NSArray *)tabItemConfigurations {
    for (TabItemConfiguration * configuration in tabItemConfigurations) {
        TabItem* listItem = [[TabItem alloc]initWithTabController:self.tabController];
        listItem.rootViewController = configuration.viewController;
        [listItem setItemConfiguration:configuration];
        [self.tabController addTabItem:listItem];
    }
    _tabItemConfigurations = tabItemConfigurations;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


+(TabController*)defaultTabControllerWithTabViewController:(__kindof TabViewController*)tabController{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}
@end
