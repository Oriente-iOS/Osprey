//
//  PageFactory.m
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "PageFactory.h"
#import "UIViewController+PageParams.h"
#import "UIViewController+Tapable.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "CompoundTapable.h"
#import "AppEventTapable.h"
#import "PageTapable.h"
#import "NSString+formatInitInstanceMethods.h"
#import "BasePageFilter.h"

static NSMutableDictionary* singletonFilters = nil;
static NSMutableDictionary* singletonPages = nil;
static const NSString* luInstanceInitialKey = @"init";


@interface NSMutableArray (AscendSortedArray)
-(void)addItem:(id)item  yield:(NSString*(^)(id x))yield;
@end

@implementation NSMutableArray (AscendSortedArray)

-(void)addItem:(id)item  yield:(NSString*(^)(id x))yield{
    if (self.count == 0) {
        [self addObject:item];
    }else{
        NSString* flag = yield(item);
        if (flag == nil) return;
        NSInteger index = 0;
        for (int i = 0; i < self.count; i++) {
            if ( [yield (self[i]) compare:flag options:NSNumericSearch] == NSOrderedAscending) {
                index ++ ;
            }else{
                break;
            }
        }
        if (index  < self.count) {
            [self insertObject:item atIndex:index];
        }else{
            [self addObject:item];
        }
    }
}

@end

@implementation PageFactory

+(PageFactory *)defaultFactory{
    static PageFactory* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PageFactory alloc]init];
    });
    return instance;
}

-(id)init {
    if (self  = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singletonFilters = @{}.mutableCopy;
            singletonPages = @{}.mutableCopy;
        });
    }
    return self;
}

-(__kindof UIViewController*)intialPageWithClassNameString:(NSString*)classNameString withParams:(NSDictionary*)params{
    if (!(classNameString.length > 0)) {
        return nil;
    }
    //1.如果 classNameString 是单例类，注入param后直接返回
    UIViewController* singletonPage = singletonPages[classNameString];
    if (singletonPage != nil) {
        [singletonPage settersInjection:params];
        return singletonPage;
    }
    // 2. 判断vcClass 是否存在以及是否为UIViewController的类型
    __block Class vcClass = NSClassFromString(classNameString);
    if (vcClass == nil && ![vcClass isSubclassOfClass:[UIViewController class]])  return nil;
    // 3. 获取 vc 配置的所有的filter, <如果父类中配置了filter 那么子类将会继承该filter>
    NSMutableArray* filters = @[].mutableCopy;
    Class currentClass = vcClass;
    while (currentClass != [UIViewController class]) {
        unsigned int methodCount = 0;
        Method * methodList = class_copyMethodList(object_getClass(currentClass), &methodCount);
        NSMutableArray* tmpFilter = @[].mutableCopy;
        for (unsigned int i = 0; i < methodCount; i++) {
            NSString *selStr = [NSString stringWithCString: sel_getName(method_getName(methodList[i])) encoding:NSUTF8StringEncoding];
            if (![selStr hasPrefix:@"base_page_filter_"]) continue;
            SEL selector = NSSelectorFromString(selStr);
            if ([currentClass respondsToSelector: selector]) {
                NSString* filter = ((NSString*(*)(id, SEL))[currentClass methodForSelector:selector])(currentClass,selector);
                if (filter.length > 0 && ![filters containsObject:filter] && ![tmpFilter containsObject:filter]) {
                    //TODO 调整filter的优先顺序当前类比父类优先，类之间按照filter在文件中的配置顺序调整
                    [tmpFilter addItem:filter yield:^NSString *(id x) {
                        return  [x substringFromIndex: @"base_page_filter_".length];
                    }];
                }
            }
        }
        [filters addObjectsFromArray:tmpFilter];
        free(methodList);
        currentClass = class_getSuperclass(currentClass);
    }
    // 4. 实例化VC配置的所有filter(如果filter 为单例那么从全局对象中获取)
    RACSequence* fullFilterSequence = [filters.rac_sequence map:^id(NSString* value) {
        Class filterClass = NSClassFromString(value);
        if (![filterClass isSubclassOfClass:[BasePageFilter class]])  return nil;
        BOOL isSigleton = ((BOOL(*)(id, SEL))[filterClass methodForSelector:@selector(isSingleton)])(filterClass,@selector(isSingleton));
        if (isSigleton) {
            BasePageFilter * filter = singletonFilters[value];
            if (filter == nil) {
                filter = [((BasePageFilter*)[ filterClass alloc])init];
                singletonFilters[value]= filter;
            }
            return filter;
        }else{
            return [((BasePageFilter*)[ filterClass alloc])init];
        }
    }];
    //filter 的启动过程
    // (1). prologue 在vc没有实例化之前就调用，该filter需要实现 LuPreInitailPageFilterProtocol 可以改写VC在实例过程中的(Class 和 params)参数
    //      当Class 的值修改为其他Class只，就去实例修改后的Class, 当Class 的值为nil,则退出实例化
    // (2). epilogue 在vc实例化之后注册， 该filter 需要实现 LuPostInitialPageFilterProtocol  在VC实例化之后调用，主要用于注册 Taple 的事件响应流
    CompoundTapable * compoundTapable = [CompoundTapable compoundTapable];
    RACSequence* prologueFilterSeq = [fullFilterSequence filter:^BOOL(BasePageFilter* filter) {
        if(![filter conformsToProtocol:@protocol(PreInitialPageFilterProtocol)]) return NO;
        return YES;
    }];
    // 5. 启动prologue filter的流程
    NSArray<BasePageFilter<PreInitialPageFilterProtocol>*> * prologueArray = prologueFilterSeq.array;
    __block UIViewController* viewController = nil;
    void(^__block recursiveCall)(NSInteger n, Class  clazz, NSDictionary* params);
    __weak __block __typeof(recursiveCall) weakRecursiveCall;
    __block NSMutableDictionary* hookedParams = nil;
    @weakify(self);
    recursiveCall = ^(NSInteger n,Class  clazz, NSDictionary* params){
        if (n < 0){ hookedParams = params.mutableCopy; return;}
        void(^callBack)(Class redicectClass, NSDictionary * inner_params) = ^(Class redicectClass, NSDictionary * inner_params){
            if (redicectClass == nil){ vcClass = nil; return ;}
            // TODO: 增加class循环引用的检测，就是redirectClass 之间引用重复了
            @strongify(self);
            if(redicectClass != vcClass){
                viewController = [self intialPageWithClassNameString:NSStringFromClass(redicectClass) withParams:inner_params];
                return;
            }
            weakRecursiveCall(n-1,redicectClass, inner_params);
        };
        [compoundTapable addSubscribe: prologueArray[prologueArray.count - n -1]]; //将filter添加到compoundTapable当中
        [prologueArray[prologueArray.count - n -1] onPageFilterCall:clazz params:params callback:callBack]; //继续调用
    };
    weakRecursiveCall = recursiveCall;
    recursiveCall(prologueArray.count - 1,vcClass,params);
    if (viewController != nil) {
        return viewController;
    }
    if(vcClass == nil || ![vcClass isSubclassOfClass:[UIViewController class]]) return nil;
    // 6. vc 的实例化与属性的注入
    // 当 params 配置了"init"的Key, 调用自定义的实例化方法 比如init 的Key 值对应为 parent_controller 那么调用initWithParentController
    // 自定义实例化方法只支持传入一个参数，如果不是initWithDictionary: 那么该参数的值从params配置的 init键 对应的value作为key的值取出
    NSString *initMethodString = hookedParams[luInstanceInitialKey];
    if(initMethodString.length > 0){
        NSString* formattedMethodString = [initMethodString initialMethodStringFormatWithPrefix:@"initWith"];
        SEL initSel = NSSelectorFromString(formattedMethodString);
        Method method = class_getInstanceMethod(vcClass, initSel);
        NSAssert(method != nil, @"=[Failed to find initSel]=");
        IMP methodIMP = method_getImplementation(method);
        id secondParam = hookedParams;
        if (![initMethodString isEqualToString:@"dictionary"]) {
            secondParam = hookedParams[hookedParams[luInstanceInitialKey]];
        }
        viewController = ((UIViewController*(*)(id, SEL, id))methodIMP)([vcClass alloc], initSel, secondParam);
    }else{
        viewController = [[vcClass alloc]init];
    }
    if(viewController == nil) return nil;
    [viewController settersInjection:hookedParams];
    // 8. 处理单例的VC
    SEL pageIsSingletonSEL  = NSSelectorFromString(@"page_isSingleton");
    if ([vcClass respondsToSelector:pageIsSingletonSEL]) {
        BOOL isSingleton = ((BOOL(*)(id, SEL))[vcClass methodForSelector:pageIsSingletonSEL])(vcClass,pageIsSingletonSEL);
        if (isSingleton) {
            singletonPages[classNameString] = viewController;
        }
    }
    // 9. 启动 epilogue filter 的流程
    BaseTapable* pageTapable = [PageTapable tapableWithPage:viewController];
    [compoundTapable addTapable:pageTapable];
    [compoundTapable addTapable:[AppEventTapable appEventTapable]];
    viewController.tapable = compoundTapable;
    RACSequence* epilogureFilterSeq = [fullFilterSequence filter:^BOOL(BasePageFilter* filter) {
        if(![filter conformsToProtocol:@protocol(PostInitialPageFilterProtocol)]) return NO;
        return YES;
    }];
    for(BasePageFilter<PostInitialPageFilterProtocol>* filter in epilogureFilterSeq.objectEnumerator){
        [pageTapable addSubscribe:filter];
        [filter onPageFilterCall:viewController params: hookedParams];
    }
    //10. 返回实现后的VC
    return viewController;
}


@end












