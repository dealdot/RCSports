//
//  MineHeaderView.m
//  RCSports
//
//  Created by liveidzong on 10/17/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "MineHeaderView.h"
#import "Masonry.h"
@implementation MineHeaderView
//override
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.totalDistance = [[UILabel alloc]init];
        self.totalDistance.text = @"00.00";
        self.totalDistance.font =  [UIFont fontWithName:@"HelveticaNeue-Medium" size:80];
        self.totalDistance.textAlignment = NSTextAlignmentCenter;
        //文本文字自适应大小
        //  _distanceLB.adjustsFontSizeToFitWidth = YES;
        //  [_distanceLB setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.totalDistance];
        [self.totalDistance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.right.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        }];
        
        UILabel *unitLabel = [[UILabel alloc]init];
        unitLabel.text = @"累计里程(公里)";
        unitLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:unitLabel];
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.totalDistance.mas_bottom).mas_equalTo(2);
            make.centerX.mas_equalTo(0);
        }];
        
        UIView *containerView = [UIView new];
        [self addSubview:containerView];
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(unitLabel.mas_bottom).mas_equalTo(0);
            make.bottom.mas_equalTo(2);
            make.left.right.mas_equalTo(0);
        }];
        
        /* 时间 */
        UIImageView *timeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sportdetail_time"]];
        [self addSubview:timeImageView];
        [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(containerView.mas_top).mas_equalTo(10);
            make.centerX.mas_equalTo(100);
        }];
        
        UILabel *unit4Time =[UILabel new];
        unit4Time.text = @"累计时间(时:分:秒)";
        unit4Time.font = [UIFont systemFontOfSize:12];
        [self addSubview:unit4Time];
        [unit4Time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeImageView.mas_bottom).mas_equalTo(10);
            make.centerX.mas_equalTo(timeImageView.mas_centerX).mas_equalTo(0);
        }];
        
        self.totalTimeSpend = [[UILabel alloc]init];
        self.totalTimeSpend.text = @"00:00";
        self.totalTimeSpend.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
        [self addSubview:self.totalTimeSpend];
        [self.totalTimeSpend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(unit4Time.mas_bottom).mas_equalTo(10);
            make.centerX.mas_equalTo(unit4Time.mas_centerX).mas_equalTo(0);
        }];
        
        /* 平均速度 */
        UIImageView *speedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sportdetail_speed"]];
        [self addSubview:speedImageView];
        [speedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(containerView.mas_top).mas_equalTo(10);
            make.centerX.mas_equalTo(-100);
        }];
        
        
        UILabel *unit4Speed =[UILabel new];
        unit4Speed.text = @"累计热量(大卡)";
        unit4Speed.font = [UIFont systemFontOfSize:12];
        [self addSubview:unit4Speed];
        [unit4Speed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(speedImageView.mas_bottom).mas_equalTo(10);
            make.centerX.mas_equalTo(speedImageView.mas_centerX).mas_equalTo(0);
        }];
        
        self.totalCalorie = [[UILabel alloc]init];
        self.totalCalorie.text = @"00.00";
        self.totalCalorie.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
        [self addSubview:self.totalCalorie];
        [self.totalCalorie mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(unit4Speed.mas_bottom).mas_equalTo(10);
            make.centerX.mas_equalTo(unit4Speed.mas_centerX).mas_equalTo(0);
            //demo for mas_make();
            //make.edges.mas_offset(UIEdgeInsetsMake(10, 10, 10, 10));
            //make.size.mas_equalTo(CGSizeMake(200, 200));
            //make.top.mas_equalTo(unit4Time).with.offset(10);
            //make.top.width.offset(90);
            //make.top.offset(90);
            //make.left.equalTo(unit4Time).with.offset(10);
            
        }];
        
        
    }
    
    return self;
}
//-(void)showTotalValues {
//    self.totalDistance.text = @"2267.99";
//    self.totalTimeSpend.text = @"983.33";
//    self.totalCalorie.text = @"19899.90";
//}
@end