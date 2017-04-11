//
//  DYVerticalButton.m
//  LoveMovie
//
//  Created by xudingyang on 16/5/11.
//  Copyright © 2016年 许定阳. All rights reserved.
//  把按钮设置成图片在上，标题在下的形式。

#import "DYVerticalButton.h"
#import "UIView+DYExt.h"
@implementation DYVerticalButton

- (void)layoutSubviews{
    [super layoutSubviews];
    
//    self.imageView.centerX = self.centerX;
    self.imageView.x = (self.width - self.imageView.width) / 2.0;
    self.imageView.y = 5;
    
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.y + self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.imageView.height;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

@end
