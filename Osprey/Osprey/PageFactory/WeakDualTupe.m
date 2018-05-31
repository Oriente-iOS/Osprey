//
//  WeakDualTupe.m
//  OrienteBase
//
//  Created by mino on 2018/1/19.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "WeakDualTupe.h"

@interface WeakDualTupe()
@property(nonatomic,strong)NSPointerArray *poinerArray;
@end

@implementation WeakDualTupe


-(instancetype)initWithFirst:(id)first second:(id)second{
    if (self = [super init]) {
        self.poinerArray = [NSPointerArray weakObjectsPointerArray];
        [self addObject:first];
        [self addObject:second];
    }
    return self;
}
-(void)addObject:(id)object{
    [self.poinerArray addPointer:(__bridge void *)(object)];
}

-(id)first{
    return [self.poinerArray pointerAtIndex:0];
}

-(id)second{
    return [self.poinerArray pointerAtIndex:1];
}

+(WeakDualTupe*)first:(id)first second:(id)second{
    return [[WeakDualTupe alloc]initWithFirst:first second:second];
}


@end
