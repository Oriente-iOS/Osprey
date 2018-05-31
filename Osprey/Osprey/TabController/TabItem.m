//
//  TabItem.m
//  OrienteBase
//
//  Created by mino on 2017/12/28.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "TabItem.h"
#import "TabController.h"
#import <Masonry/Masonry.h>
#import "BaseNavigationController.h"




@interface TabItemView : UIView

@property(nonatomic,assign) BOOL isSelected;

@property(nonatomic,strong) UIButton* itemButton;

@property (nonatomic,weak) TabItem * tabItem;

-(RACChannelTerminal *)rac_itemResponseChannel;


@end

@implementation TabItemView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.itemButton = [[UIButton alloc]initWithFrame:CGRectZero];
    }
    return self;
}


-(id)initWithTabConfiguration:(TabItemConfiguration*)configuration {
    if (self = [self initWithFrame:CGRectZero]) {
        UIView* view = [configuration itemViewWithInnerButton:self.itemButton];
        if ((view != self.itemButton) && (!self.itemButton.superview)) {
            [view addSubview:self.itemButton];
            [self.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(view);
            }];
        }
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

-(void)updateConstraints {
    [self.itemButton sizeToFit];
    [super updateConstraints];
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    [self.itemButton setSelected:isSelected];
}

-(RACChannelTerminal *)rac_itemResponseChannel {
    RACChannel *channel = [[RACChannel alloc]init];
    [self.rac_deallocDisposable addDisposable:[RACDisposable disposableWithBlock:^{
        [channel.followingTerminal sendCompleted];
    }]];
    @weakify(self);
    RACSignal* eventSignal = [[[[self.itemButton rac_signalForControlEvents:UIControlEventTouchUpInside]filter:^BOOL(id value) {
        @strongify(self);
        return ! self.isSelected;
    }]mapReplace:self.tabItem]takeUntil:[channel.followingTerminal ignoreValues]];
    [eventSignal subscribe:channel.followingTerminal];
    [[[channel.followingTerminal map:^id(TabItem *value) {
        @strongify(self);
        if (value == self.tabItem){
            return @(YES);
        }else{
            return @(NO);
        }
    }]distinctUntilChanged] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.isSelected = [x boolValue];
    }];
    
    return channel.leadingTerminal;
}

@end




@interface TabItem()
@property(nonatomic,weak) TabController* tabController;
@property(nonatomic,strong) TabItemView* tabItemView;
@property(nonatomic,strong) UINavigationController* navigationViewController;

@end

@implementation TabItem

-(id)initWithTabController:(TabController *)tabController {
    if (self = [super init]) {
        self.tabController = tabController;
    }
    return self;
}

-(void)setItemConfiguration:(TabItemConfiguration *)configuration {
    TabItemView* tabItemView = [[TabItemView alloc]initWithTabConfiguration:configuration];
    tabItemView.tabItem = self;
    self.catergoryID = configuration.catergoryID;
    self.tabItemView = tabItemView;
    // 可以增加对tabItemView 的重新配置
}

-(RACChannelTerminal *)itemEventChannel {
    return self.tabItemView.rac_itemResponseChannel;
}

#pragma mark - getter

-(UIView*)itemView {
    return self.tabItemView;
}

-(UINavigationController*)itemNavigator {
    return self.navigationViewController;
}

#pragma mark - setter

-(void)setRootViewController:(UIViewController *)rootViewController{
    if (_rootViewController != nil && rootViewController != nil) {
        return;
    }
    _rootViewController = rootViewController;
    self.navigationViewController = [[BaseNavigationController alloc] initWithRootViewController:rootViewController];
}








@end
