//
//  TabController.m
//  OrienteBase
//
//  Created by mino on 2017/12/28.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "TabController.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "TapableEvent.h"
#import "PageFactory.h"
#import "BaseRouter.h"
#import "UIViewController+PageParams.h"

@interface TabContainer:UIView

@property(nonatomic, assign) BOOL isNeedUpdateConstraint;
@property(nonatomic,strong)NSMutableArray * tabItems;
@end


@implementation TabContainer

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.isNeedUpdateConstraint = NO;
        self.tabItems = @[].mutableCopy;
    }
    
    return self;
}

-(void)addItemView:(UIView*)itemView {
    if (![self.tabItems containsObject:itemView]) {
        [self.tabItems addObject:itemView];
        [self addSubview:itemView];
        self.isNeedUpdateConstraint = YES;
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}


-(void)removeItemView:(UIView*)itemView{
    if ([self.tabItems containsObject:itemView]) {
        [self.tabItems removeObject:itemView];
        [itemView removeFromSuperview];
        self.isNeedUpdateConstraint = YES;
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}


-(void)updateConstraints{
    [super updateConstraints];
    if (self.isNeedUpdateConstraint) {
        // 平均分视图
        BOOL isLeft = NO;
        BOOL isRight = NO;
        __block  UIView* preview = nil;
        for (UIView* subView in self.tabItems) {
            
            if ([self.tabItems firstObject] == subView) {
                isLeft = YES;
            }
            if ([self.tabItems lastObject] == subView) {
                isRight = YES;
            }
            [subView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(self);
                if (isLeft) {
                    make.left.equalTo(self.mas_left);
                }else{
                    make.left.equalTo(preview.mas_right);
                    make.width.equalTo(preview.mas_width);
                }
                if (isRight) {
                    make.right.equalTo(self.mas_right);
                }
                
            }];
            preview = subView;
            isLeft = NO;
            isRight= NO;
        }
        self.isNeedUpdateConstraint = NO;
    }
}
@end



@interface TabController()
@property(nonatomic,strong,readwrite) NSMutableArray* items;
@property(nonatomic,strong,readwrite) TabItem *currentTabItem;
@property(nonatomic,strong) TabItem *defaultTabItem;
@property (nonatomic,weak,readwrite) TabViewController* tabViewController; // Tab的容器Controller 相当于window的RootViewController

@property(nonatomic,strong) RACSubject *setDefaultItemSignal;
@property(nonatomic,strong) RACSubject * tabItemEventSubject;
@property(nonatomic,strong) RACSubject * switchEventSubject; // 用于发送event的句柄
@property(nonatomic,strong) TabContainer *tabContainerView;
@property(nonatomic,strong) NSMutableArray<id<TabControllerTabSwitchProtocol>>* tabPlugins;
@end

@implementation TabController


-(id)initWithTabViewController:(TabViewController *)tabViewController{
    if (self = [super init]) {
        self.tabViewController = tabViewController;
        self.items = @[].mutableCopy;
        self.tabPlugins = @[].mutableCopy;
        self.setDefaultItemSignal = [RACSubject subject];
        self.switchEventSubject = [RACSubject subject];
        self.tabItemEventSubject = [RACReplaySubject replaySubjectWithCapacity:1];
        @weakify(self);
        [self.setDefaultItemSignal subscribeNext:^(TabItem  *item) {
            @strongify(self);
            [tabViewController defaultNavigationViewController:item.itemNavigator];
             UIViewController* viewController = item.rootViewController;
             NSCParameterAssert(viewController != nil);
            if(![viewController.view.subviews containsObject:self.tabContainerView]){
                [viewController.view addSubview:self.tabContainerView];
                [self.tabContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.equalTo(viewController.view);
                    if (@available(iOS 11.0, *)){
                        make.bottom.equalTo(viewController.view.mas_safeAreaLayoutGuideBottom);
                    }else{
                        make.bottom.equalTo(viewController.view.mas_bottom);
                    }
                    make.height.mas_equalTo(tabBarHeight);
                }];
            }
             [viewController.view bringSubviewToFront:self.tabContainerView];
        }];
        
        [[[RACObserve(self, currentTabItem) distinctUntilChanged] filter:^BOOL(id value) {
            return  value != nil;
        }] subscribeNext:^( TabItem *item) {
            @strongify(self);
            [self.setDefaultItemSignal sendNext:item];
            [self.tabItemEventSubject sendNext:item];
        }];
        self.tabContainerView = [[TabContainer alloc]initWithFrame:CGRectZero];
        [tabViewController customizeTabContainerView:self.tabContainerView];
        __block RACDisposable* disposal = nil;
        disposal =[[[self.tabViewController rac_signalForSelector:@selector(viewWillAppear:)]takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id x) {
            @strongify(self);
            if (self.defaultTabItem != nil) {
                self.currentTabItem = self.defaultTabItem; // 切换成当前的TabITem
            }
            [disposal dispose];
        }];
        
        
    }
    
    return self;
}


-(void)addTabItem:(TabItem *)item{
    if (self.defaultTabItem == nil) {
        self.defaultTabItem = item;
    }
    [self.items addObject:item];
    // 修改底部元素
    [self.tabContainerView addItemView:item.itemView];
    RACChannelTerminal* channelTerminal = item.itemEventChannel;
    [self.tabItemEventSubject subscribe:channelTerminal];
    @weakify(self);
    [[[channelTerminal flattenMap:^RACStream *(TabItem *value) {
        @strongify(self);
        // 1.初始化原始的 switchSignal
        RACSignal* switchSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@(YES)];
            [subscriber sendCompleted];
            return nil;
        }];
        // 2.链式调用
        for (id<TabControllerTabSwitchProtocol> plugin in self.tabPlugins) {
            RACSubject *pluginSubject = [RACReplaySubject replaySubjectWithCapacity:1];
            void(^contianuation)(BOOL)= ^(BOOL flag){
                [pluginSubject sendNext:@(flag)];
                [pluginSubject sendCompleted];
            };
            switchSignal = [[switchSignal combineLatestWith:pluginSubject]reduceEach:^id(NSNumber* first, NSNumber* last){
                return @([first boolValue] && [last boolValue]);
            }];
            [plugin processTabAction:self fromIndex:[self indexOfTabItem:self.currentTabItem ] toIndex:[self indexOfTabItem:value] withContinuation:contianuation];
        }
        return [[switchSignal filter:^BOOL(NSNumber* value) {
            return  [value boolValue];
        }] mapReplace:value];
    }] deliverOnMainThread] subscribeNext:^(TabItem *x) {
        @strongify(self);
        [self switchToTabItemIndex: [self.items indexOfObject:x]];
    }];
    
}



-(void)removeTabItemAtIndex:(NSInteger)index{
    TabItem* removingItem = [self.items objectAtIndex:index];
    if (removingItem == self.currentTabItem) {
        [self.items removeObjectAtIndex:index];
        self.currentTabItem = [self.items firstObject];
    }
    if (self.defaultTabItem == removingItem) {
        self.defaultTabItem = nil;
    }
    //修改底部元素
    [self.tabContainerView removeItemView:removingItem.itemView];
}


-(void)switchToTabItemIndex:(NSInteger)index {
    
    if (index >= self.items.count || index < 0 ) {
        return;
    }
    if ([self.items indexOfObject:self.currentTabItem] == index) {
        return;
    }
    TabItem* previousItem = self.currentTabItem;
    if (previousItem != nil) {
        [self.switchEventSubject sendNext:RACTuplePack(self.tabViewController, self,previousItem, self.items[index] ,[TapableEvent switchEvent:TabWillSwitch])];
    }
    self.currentTabItem = self.items[index];
    if (previousItem != nil) {
        [self.switchEventSubject sendNext:RACTuplePack(self.tabViewController, self,previousItem, self.items[index],[TapableEvent switchEvent:TabDidSwitch])];
    }
}

-(void)tabControllerAddPlugins:(id<TabControllerTabSwitchProtocol>)firstPlugin, ...{
    NSMutableArray* plugins = @[].mutableCopy;
    va_list args;
    va_start(args, firstPlugin);
    for (id<TabControllerTabSwitchProtocol> currentPlugin = firstPlugin; currentPlugin != nil; currentPlugin = va_arg(args, id<TabControllerTabSwitchProtocol>)){
        [plugins addObject:currentPlugin];
    }
    va_end(args);
    @synchronized (self) {
        [self.tabPlugins addObjectsFromArray:plugins];
    }
}


-(RACSignal *)switchEventSignal{
    return self.switchEventSubject;
}


#pragma -- helper

-(NSInteger)indexOfTabItem:(TabItem*)tabItem {
    return [self.items indexOfObject:tabItem];
}


+(TabController*)appTabController{
        TabViewController* tabViewController = [[PageFactory defaultFactory]intialPageWithClassNameString:[[BaseRouter defaultRouter] routerToPageWithURL:[NSURL URLWithString:@"base://tabviewcontroller"]] withParams:@{PageInjectionForbidden:@(YES)}];
    return tabViewController.tabController;
}

@end
