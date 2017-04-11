//
//  RCGridMenu.h
//  RCSports
//
//  Created by liveidzong on 11/9/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCBaseMenu.h"
@interface RCGridMenu : RCBaseMenu
- (instancetype)initWithItemTitles:(NSArray *)itemTitles images:(NSArray *)images;

- (void)triggerSelectedAction:(void(^)(NSInteger index))actionHandle;
@end