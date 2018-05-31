//
//  NSArray+Functional.m
//  OrienteBase
//
//  Created by mino on 2018/1/16.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "NSArray+Functional.h"

@implementation NSArray (Functional)

-(NSArray*)flattenMap:(NSArray*(^)(id x))block{
    NSMutableArray* arr = @[].mutableCopy;
    [self enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL *stop) {
        NSArray* ret = block(obj);
        [arr addObjectsFromArray:ret?:@[]];
    }];
    return arr;
}

-(NSArray*)fmap:(id(^)(id x))block{
    return [self flattenMap:^NSArray *(id x){
        id ret = block(x);
        return (ret == nil)?@[]:@[ret];
    }];
}

-(NSArray*)filter:(BOOL(^)(id x))block{
    return [self flattenMap:^NSArray *(id x){
        BOOL ret = block(x);
        return  ret?@[x]:@[];
    }];
}


@end
