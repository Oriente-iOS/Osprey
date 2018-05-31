//
//  Reader.m
//  OrienteBase
//
//  Created by mino on 2018/1/23.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "Reader.h"

@interface Reader()
@property(nonatomic,strong,readwrite)ReaderBlock reader;
@end


@implementation Reader

+(instancetype)createReader:(ReaderBlock)block {
    Reader* reader = [((Reader*)[[self class]alloc])initWithBlock:block];
    return reader;
}

-(instancetype)initWithBlock:(ReaderBlock)block {
    if (self = [super init]) {
        self.reader = block;
    }
    return self;
}

+(instancetype)pure:(id) a{
    return [[self class] createReader:^id(id x) {
        return a;
    }];
}

-(instancetype)bind:(Reader *(^)(id a)) block{
    ReaderBlock selfReader = [self.reader copy];
    return  [[self class] createReader:^id(id x) {
        id ret = selfReader(x);
       return  block(ret).reader(x);
    }];
}

@end
