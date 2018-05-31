//
//  BaseRouter.m
//  OrienteBase
//
//  Created by mino on 2018/1/2.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "BaseRouter.h"
#import "PropertiesParserDelegate.h"
#import <pthread/pthread.h>
#import "NSArray+Functional.h"

@interface NSMutableDictionary (RegisterComponents)

-(void)insertWithComponents:(NSArray*)components value:(NSString*)val;

@end

@implementation NSMutableDictionary (RegisterComponents)

-(void)insertWithComponents:(NSArray*)components value:(NSString*)val {
    if (components.count == 0) {
        return;
    }
    if (components.count == 1) {
        if (self[components.firstObject] == nil) {
            self[components.firstObject] = @{}.mutableCopy;
        }
        self[components.firstObject] = val;
        return;
    }
     NSString* item = [components firstObject];
     NSArray* subComponents = [components subarrayWithRange:NSMakeRange(1, components.count - 1)];
    if (!self[item]) {
        self[item] = @{}.mutableCopy;
    }
    NSMutableDictionary* lastComponents = self[item];
    [lastComponents insertWithComponents:subComponents value:val];
}


-(NSString *)findValueWithComponents:(NSArray*)components{
    if (components.count == 0) {
        return nil;
    }else if (components.count == 1){
        NSString* component = components.firstObject;
        if ([self[component] isKindOfClass:[NSString class]]) {
            return self[component];
        }else{
            return nil;
        }
    }
    NSString* component = components.firstObject;
    if ([self[component] isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary* child = self[component];
        NSArray* subComponents = [components subarrayWithRange:NSMakeRange(1, components.count - 1)];
        return [child findValueWithComponents:subComponents];
    }else{
        return nil;
    }
}

@end



@interface BaseRouter()<PropertiesParserResultProtocol>{
    pthread_rwlock_t       rwlock;
}

@property(nonatomic,strong)PropertiesParserDelegate* parserDelegate;
@property(nonatomic,strong)NSMutableDictionary* nodeTree;
@end

@implementation BaseRouter


-(id)init {
    if (self = [super init]) {
        self.parserDelegate = [[PropertiesParserDelegate alloc]initWithDelegate:self];
        self.nodeTree = @{}.mutableCopy;
        pthread_rwlock_init(&rwlock, NULL);
    }
    return self;
}


#pragma mark - methods

+(BaseRouter*)defaultRouter {
    static BaseRouter* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BaseRouter alloc]init];
    });
    return instance;
}

-(void)registerConfigrationFilePath:(NSString*)filePath {
    [self.parserDelegate parserWithConfigurationPath:filePath];
}


-(NSString*)routerToPageWithURL:(NSURL*)pageURL {
    NSString* clazz = nil;
    NSMutableArray* components = @[].mutableCopy;
    NSString* scheme = pageURL.scheme;
    NSString* host = pageURL.host;
    NSString* path = pageURL.path;
    if (scheme) {
        [components addObject:scheme];
    }
    if (host) {
        [components addObject:host];
    }
    if (path) {
        [components addObjectsFromArray:[[path componentsSeparatedByString:@"/"]filter:^BOOL(NSString* x) {
            return x.length > 0;
        }]];
    }
    pthread_rwlock_rdlock(&rwlock);
    clazz = [self.nodeTree findValueWithComponents:components];
    pthread_rwlock_unlock(&rwlock);
    return clazz;
}


-(NSString*)routeToPageWithURLString:(NSString*)pageURLString{
    NSURL* url = [NSURL URLWithString:pageURLString];
    return [self routerToPageWithURL:url];
}

#pragma mark - PropertiesParserDelegate

-(void)parseSucceed:(NSDictionary *)properities {
    pthread_rwlock_wrlock(&rwlock);
    // key 表示路由:比如 cashalo.user.setting 对应的URL为 cashalo://user/setting
    // value 表示对应的ClassName 如 CAUserSettingViewController
    [properities enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* obj, BOOL *stop) {
        NSArray* pathComponents = [key componentsSeparatedByString:@"."];
        [self.nodeTree insertWithComponents:pathComponents value:obj];
    }];
    pthread_rwlock_unlock(&rwlock);
}

-(void)parseFailed:(NSError *)error{
     @throw [NSException exceptionWithName:@"Router Properties file parse error" reason:@"no parser in Parser" userInfo:error.userInfo];
}


-(void)dealloc {
    pthread_rwlock_destroy(&rwlock);
}
@end
