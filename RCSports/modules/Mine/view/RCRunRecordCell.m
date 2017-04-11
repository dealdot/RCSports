//
//  RCRunRecordCell.m
//  RCSports
//
//  Created by liveidzong on 10/18/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "RCRunRecordCell.h"
#import "Masonry.h"
@implementation RCRunRecordCell
//getter
-(UILabel *)timeFromTo {
    if(!_timeFromTo) {
        _timeFromTo = [[UILabel alloc] init];
        _timeFromTo .textColor = [UIColor lightGrayColor];
        _timeFromTo.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_timeFromTo];
        [_timeFromTo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.totalDistance.mas_bottom).mas_equalTo(8);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _timeFromTo;
}

-(UILabel *)totalDistance {
    if(!_totalDistance) {
        _totalDistance = [[UILabel alloc] init];
        _totalDistance.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_totalDistance];
        [_totalDistance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
        }];
    }
    return _totalDistance;
}

-(UILabel *)totalTime {
    if(!_totalTime) {
        _totalTime = [[UILabel alloc] init];
        _totalTime.font = [UIFont systemFontOfSize:15];
        _totalTime.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_totalTime];
        [_totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    return  _totalTime;
}

@end
