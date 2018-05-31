//
//  CompoundTapable.m
//  OrienteBase
//
//  Created by mino on 2017/12/27.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "CompoundTapable.h"

@interface CompoundTapable()

@property(nonatomic,strong)NSMutableArray* tapables;
@end

@implementation CompoundTapable

+(instancetype)compoundTapable{
    return [[CompoundTapable alloc]init];
}

-(id)init {
    if (self = [super init]) {
        self.tapables = @[].mutableCopy;
    }
    return self;
}


-(void)publish:(id)x {
    [self.followingTerminal sendNext:x];
}

-(void)addTapable:(BaseTapable*)tapable{
    [self.tapables addObject:tapable];
    [tapable.followingTerminal subscribe:self.followingTerminal];
    [self.leadingTerminal subscribe:tapable.followingTerminal];
}

-(void)removeTapable:(BaseTapable*)tapable{
    [self.tapables removeObject:tapable];
    [tapable.leadingTerminal sendCompleted];
}

-(void)dealloc {
    NSArray* tempArray = self.tapables.copy;
    for (BaseTapable *tapable in tempArray) {
        [self removeTapable:tapable];
    }
}

@end
