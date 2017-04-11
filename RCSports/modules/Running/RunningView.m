//
//  RunningView.m
//  RCSports
//
//  Created by liveidzong on 9/21/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "RunningView.h"
#import "Masonry.h"

@interface RunningView()
@property(nonatomic,strong) CAGradientLayer *gradientLayer;
@property(nonatomic,strong) UIView *gradientView;

@end

@implementation RunningView


-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        
        //background color gradient
        
        self.gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self addSubview:self.gradientView];
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.frame = self.gradientView.bounds;
        
        [self.gradientView.layer addSublayer:self.gradientLayer];
        
        self.gradientLayer.startPoint = CGPointMake(0, 0);
        self.gradientLayer.endPoint = CGPointMake(0, 1);
        
        self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:31.0/255 green:47.0/255 blue:66.0/255 alpha:1].CGColor,(__bridge id)[UIColor colorWithRed:65.0/255 green:95.0/255 blue:115.0/255 alpha:1].CGColor];
        
        self.gradientLayer.locations = @[@(0.5f),@(1.0f)];
        
        //gps
        
        UILabel *gpsLabel = [[UILabel alloc]init];
        gpsLabel.text = @"GPS:";
        gpsLabel.textColor = [UIColor whiteColor];
        gpsLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:gpsLabel];
        [gpsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(55);
            make.left.mas_equalTo(25);
        }];
        
        
        UILabel *gpsInfo = [[UILabel alloc]init];
        gpsInfo.text = @"强";
        gpsInfo.textColor = [UIColor whiteColor];
        gpsInfo.textAlignment = NSTextAlignmentCenter;
        [self addSubview:gpsInfo];
        [gpsInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(gpsLabel.mas_left).offset(49);
            make.centerY.mas_equalTo(gpsLabel.mas_centerY).offset(0);
        }];
        
        
        self.mapButton = [[UIButton alloc] init];
        [self.mapButton setImage:[UIImage imageNamed:@"mapInnovation"] forState:UIControlStateNormal];
        [self addSubview:self.mapButton];
        [self.mapButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.width.height.mas_equalTo(38);
            make.centerY.mas_equalTo(gpsLabel.mas_centerY).offset(0);
        }];
        
        _distanceLB = [[UILabel alloc]init];
        _distanceLB.text = @"00.00";//Futura-CondensedExtraBold
        _distanceLB.textColor = [UIColor whiteColor];
        _distanceLB.font =  [UIFont fontWithName:@"HelveticaNeue-Medium" size:80];//PingFangSC-Ultralight
        _distanceLB.textAlignment = NSTextAlignmentCenter;
        //文本文字自适应大小
        //  _distanceLB.adjustsFontSizeToFitWidth = YES;
        //  [_distanceLB setBackgroundColor:[UIColor redColor]];
        [self addSubview:_distanceLB];
        [_distanceLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(130);
            make.left.right.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
        }];
        
        UILabel *unitLabel = [[UILabel alloc]init];
        unitLabel.text = @"距离(公里)";
        unitLabel.textColor = [UIColor whiteColor];
        unitLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:unitLabel];
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_distanceLB.mas_bottom).mas_equalTo(2);
            make.centerX.mas_equalTo(0);
        }];
       
        
        _timeLB = [[UILabel alloc]init];
        _timeLB.text = @"00:00";
        _timeLB.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
        _timeLB.textColor = [UIColor whiteColor];
        [self addSubview:_timeLB];
        [_timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(unitLabel.mas_bottom).mas_equalTo(50);
            //make.centerX.mas_equalTo(unitLabel.mas_centerX).mas_equalTo(-10);
            make.left.mas_equalTo(36);
        }];
        
        UILabel *unit4Time =[UILabel new];
        unit4Time.text = @"时间 (s)";
        unit4Time.textColor = [UIColor whiteColor];
        unit4Time.font= [UIFont fontWithName:@"HelveticaNeue-light" size:16];
        [self addSubview:unit4Time];
        [unit4Time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_timeLB.mas_bottom).mas_equalTo(10);
            make.centerX.mas_equalTo(_timeLB.mas_centerX).mas_equalTo(0);
        }];
        
        
        
        _speedLB = [[UILabel alloc]init];
        _speedLB.text = @"00.00";
        _speedLB.textColor = [UIColor whiteColor];
        _speedLB.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
        [self addSubview:_speedLB];
        [_speedLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(unitLabel.mas_bottom).mas_equalTo(50);
            //make.centerX.mas_equalTo(unitLabel.mas_centerX).mas_equalTo(10);
            make.right.mas_equalTo(-36);
        }];
        
        UILabel *unit4Speed =[UILabel new];
        unit4Speed.text = @"速度 (m/s)";
        unit4Speed.textColor = [UIColor whiteColor];
        unit4Speed.font = [UIFont fontWithName:@"HelveticaNeue-light" size:16];
        [self addSubview:unit4Speed];
        [unit4Speed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_speedLB.mas_bottom).mas_equalTo(10);
            make.centerX.mas_equalTo(_speedLB.mas_centerX).mas_equalTo(0);
        }];
        
    }
    return self;
}
-(void)startTimer {
    [self resetRecord];
    if(!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTimeValue) userInfo:nil repeats:YES];
    }else {
        [_timer setFireDate:[NSDate distantPast]]; //开始
    }
}
-(void)stopTimer {
    //唯一的方法将_timer从runloop池中移除,invalite会让timer退出runloop,取消timer
    [_timer invalidate];
    _timer = nil;
    _timerNumber = 0;
}
-(void)changeTimeValue {
    _timerNumber ++;
    _timeLB.text = [NSString stringWithFormat:@"%.2ld:%.2ld",_timerNumber/60,_timerNumber%60];
}
-(void)resetRecord {
    _timeLB.text = @"00.00";
    _distanceLB.text = @"00.00";
    _speedLB.text = @"00.00";
    _timerNumber = 0;
    [_timer setFireDate:[NSDate distantFuture]]; //暂停
}
@end