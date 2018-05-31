//
//  NavigatorBarReader.h
//  OrienteBase
//
//  Created by mino on 2018/1/23.
//  Copyright © 2018年 mino. All rights reserved.
//

#import "Reader.h"
#import <UIKit/UIKit.h>
@interface NavigatorBarReader : Reader



-(NavigatorBarReader*)navigationBarBackground;

-(NavigatorBarReader*)navigationBarSplit;

-(NavigatorBarReader*)navigationBarTitleAttributes;

-(NavigatorBarReader*)navigationBarBackStyle;

-(NavigatorBarReader*)navigaitonBarHidden;

@end
