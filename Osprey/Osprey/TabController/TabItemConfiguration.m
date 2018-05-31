//
//  TabItemConfiguration.m
//  OrienteBase
//
//  Created by mino on 2017/12/28.
//  Copyright © 2017年 mino. All rights reserved.
//

#import "TabItemConfiguration.h"

@implementation TabItemConfiguration

-(UIView*)itemViewWithInnerButton:(UIButton*)button{
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];

}
@end
