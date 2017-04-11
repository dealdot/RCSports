//
//  RunningView.h
//  RCSports
//
//  Created by liveidzong on 9/21/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunningView : UIView
//@property(nonatomic,strong)UILabel *labelGPS;
//@property(nonatomic,strong)UIButton *mapsButton;
//@property(nonatomic,strong) UILabel *runningDistance;
//@property(nonatomic,strong) UILabel *runningTime;
//@property(nonatomic,strong) UILabel *runningSpeed;




@property(nonatomic,strong) UIButton *mapButton;
@property (nonatomic,strong) UILabel *distanceLB;
@property (nonatomic,strong) UILabel *timeLB;
@property (nonatomic,strong) UILabel *speedLB;
@property(nonatomic,weak) NSTimer *timer;
//用于记时的
@property(nonatomic,assign) NSInteger timerNumber;
//重置记录
-(void)resetRecord;
//开始记时器
-(void)startTimer;
//停止记时器
-(void)stopTimer;
@end