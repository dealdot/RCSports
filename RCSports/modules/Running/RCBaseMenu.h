//
//  RCBaseMenu.h
//  RCSports
//
//  Created by liveidzong on 11/9/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCActionView.h"


#define BaseMenuBackgroundColor(style)  (style == RCActionViewStyleLight ? [UIColor colorWithWhite:1.0 alpha:1.0] : [UIColor colorWithWhite:0.2 alpha:1.0])
#define BaseMenuTextColor(style)        (style == RCActionViewStyleLight ? [UIColor colorWithRed:152.0/255.0 green:152.0/255.0 blue:152.0/255.0 alpha:1.0] : [UIColor lightTextColor])
#define BaseMenuActionTextColor(style)  ([UIColor colorWithRed:152.0/255.0 green:152.0/255.0 blue:152.0/255.0 alpha:1.0])

@interface RCButton : UIButton
@end

@interface RCBaseMenu : UIView
@property (nonatomic, assign) RCActionViewStyle style;
@end