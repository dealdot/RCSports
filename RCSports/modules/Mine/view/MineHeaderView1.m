//
//  MineHeaderView.m
//  RCSports
//
//  Created by liveidzong on 10/14/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "MineHeaderView.h"
#import "DYVerticalButton.h"




@interface MineHeaderView ()
@property (weak, nonatomic) IBOutlet DYVerticalButton *goodsCarBtn;

@end


@implementation MineHeaderView

+ (instancetype)meHeaderView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


@end