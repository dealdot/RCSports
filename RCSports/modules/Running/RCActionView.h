//
//  RCActionView.h
//  RCSports
//
//  Created by liveidzong on 11/9/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, RCActionViewStyle){
    RCActionViewStyleLight = 0,     // 浅色背景，深色字体
    RCActionViewStyleDark           // 深色背景，浅色字体
};

@interface RCActionView : UIView

@property (nonatomic, assign) RCActionViewStyle style;
//单例
+ (RCActionView *)sharedActionView;

- (void)showGridMenuWithItemTitles:(NSArray *)itemTitles images:(NSArray *)images;
@end