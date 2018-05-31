//
//  Reader.h
//  OrienteBase
//
//  Created by mino on 2018/1/23.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^ReaderBlock)(id x);


@interface Reader : NSObject

@property(nonatomic,strong,readonly)ReaderBlock reader;

+(instancetype)pure:(id) a;

-(instancetype)bind:(Reader *(^)(id a)) block;

+(instancetype)createReader:(ReaderBlock)block;

@end
