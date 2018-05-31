//
//  PageTapable.m
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "PageTapable.h"
#import "TapableEvent.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "WeakDualTupe.h"


typedef void(^HookDeallocBlock)(id);

static void* const kPageTapableDellocKey = (void *)&kPageTapableDellocKey;

@interface PageTapable()
@property(nonatomic,weak) UIViewController* page;

@end

@implementation PageTapable

+(BaseTapable*)tapableWithPage:(UIViewController*)page{
    return [[PageTapable alloc]initWithPage:page];
}


BOOL pageTapableDeallocSwizzle(Class clazz){
    BOOL swizzled = NO;
    for (Class currentClass = clazz; !swizzled && currentClass!= nil; currentClass = class_getSuperclass(currentClass)) {
        swizzled = [objc_getAssociatedObject(currentClass, kPageTapableDellocKey) boolValue];
    }
    return !swizzled;
}

void pageTapableDeallocIfNeeded(Class clazz, HookDeallocBlock hookedBlock ) {
    static SEL deallocSEL = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deallocSEL = sel_getUid("dealloc");
    });
    @synchronized(clazz){
        if (! pageTapableDeallocSwizzle(clazz)) {
            return;
        }
        objc_setAssociatedObject(clazz, kPageTapableDellocKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    Method dealloc = NULL;
    unsigned int n;
    Method *methods = class_copyMethodList(clazz, &n);
    for (unsigned int i = 0;  i < n;  i++) {
        if ( method_getName(methods[i]) == deallocSEL ) {
            dealloc = methods[i];
            break;
        }
    }
    free(methods);
    HookDeallocBlock copiedBlock = [hookedBlock copy];
    if (dealloc == NULL) {
         Class superclass = class_getSuperclass(clazz);
        class_addMethod(clazz, deallocSEL, imp_implementationWithBlock(^(__unsafe_unretained id self) {
            copiedBlock(self);
            // ARC automatically calls super when dealloc is implemented in code,
            // but when provided our own dealloc IMP we have to call through to super manually
            struct objc_super superStruct = (struct objc_super){ self, superclass };
            ((void (*)(struct objc_super*, SEL))objc_msgSendSuper)(&superStruct, deallocSEL);
            
        }), method_getTypeEncoding(dealloc));
    }else{
        __block IMP deallocIMP = method_setImplementation(dealloc, imp_implementationWithBlock(^(__unsafe_unretained id self) {
              copiedBlock(self);
            // invoke the original dealloc IMP
            ((void(*)(id, SEL))deallocIMP)(self, deallocSEL);
        }));
    }
}


-(instancetype)initWithPage:(UIViewController*)page {
    if (self = [super init]) {
        self.page = page;
    }
    @weakify(self);
    [self.page aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^{
        @strongify(self);
     
        [self publish:RACTuplePack([WeakDualTupe first:self second:self.page],[TapableEvent pageEvent:PageLoaded])];
    } error:nil];
    [self.page aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionBefore usingBlock:^{
        @strongify(self);
        [self publish:RACTuplePack([WeakDualTupe first:self second:self.page],[TapableEvent pageEvent:PageBecomeActive])];
    } error:nil];
    [self.page aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^{
        @strongify(self);
        [self publish:RACTuplePack([WeakDualTupe first:self second:self.page],[TapableEvent pageEvent:PageActived])];
    } error:nil];
    [self.page aspect_hookSelector:@selector(viewDidDisappear:) withOptions:AspectPositionAfter usingBlock:^{
        @strongify(self);
         [self publish:RACTuplePack([WeakDualTupe first:self second:self.page],[TapableEvent pageEvent:PageResignActive])];
    } error:nil];
    pageTapableDeallocIfNeeded([self.page class], ^(id x){
        @strongify(self);
        [self publish:RACTuplePack([WeakDualTupe first:self second:self.page],[TapableEvent pageEvent:PageFinished])];
        [self.leadingTerminal sendCompleted];
    });
    return self;
}

//// 一定不要用RACTupe 引用页面
//-(void)addSubscribe:(id<TapableEventObserverProtocol>) subscribe{
//    // 根据subscribe 传递事件及内容
//    @weakify(self);
//    [self.leadingTerminal subscribeNext:^(RACTuple *x) {
//        @strongify(self);
//        TapableEvent* event = x.last;
//        UIViewController* ctrl =  self.page;
//        NSMutableArray* arguments = ctrl?@[self, ctrl].mutableCopy:@[self].mutableCopy;
//       // NSMutableArray* arguments =  @[self, ctrl].mutableCopy;
//        if ([subscribe respondsToSelector:@selector(receiveEvent:withArguments:)]) {
//            [subscribe receiveEvent:event withArguments: arguments];
//        }
//    }];
//}

@end
