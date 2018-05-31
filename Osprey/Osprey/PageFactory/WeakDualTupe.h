//
//  WeakDualTupe.h
//  OrienteBase
//
//  Created by mino on 2018/1/19.
//  Copyright © 2018年 mino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakDualTupe : NSObject


-(id)first;

-(id)second;

+(WeakDualTupe*)first:(id)first second:(id)second;

@end
