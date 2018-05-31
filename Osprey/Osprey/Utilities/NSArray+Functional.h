//
//  NSArray+Functional.h
//  OrienteBase
//
//  Created by mino on 2018/1/16.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Functional)

-(NSArray*)flattenMap:(NSArray*(^)(id x))block;

-(NSArray*)fmap:(id(^)(id x))block;

-(NSArray*)filter:(BOOL(^)(id x))block;



@end
