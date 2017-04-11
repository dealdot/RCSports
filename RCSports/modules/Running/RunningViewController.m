//
//  RunningViewController.m
//  RCSports
//
//  Created by liveidzong on 9/19/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "RunningViewController.h"
#import "CountDownViewController.h"
#import "Masonry.h"
#import "RCFMDBManager.h"
#import "MineViewController.h"

@interface RunningViewController ()
@property(nonatomic,strong)UIButton *beginButton;
@property (nonatomic,strong) UILabel *totalLabel;
@end

@implementation RunningViewController

//static CGSize blockSize = {80,80};

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor whiteColor];
    //[self addBeginButtonOffsetFromCenterBy:UIOffsetMake(0, 0)];

    
    
    //total meters label
    UILabel *showLabel = [[UILabel alloc] init];
    [showLabel setNumberOfLines:0];
    showLabel.text = @"跑步总里程(公里)";
    showLabel.textColor = [UIColor yellowColor];
    showLabel.font = [UIFont systemFontOfSize:13];
    showLabel.textAlignment= NSTextAlignmentCenter;
    [showLabel sizeToFit];
    showLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:showLabel];
    [showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        //make.bottom.mas_equalTo(btn.mas_top).offset(-30);
    }];
    
    //
    self.totalLabel = [[UILabel alloc] init];
    //NSArray *totalDistanceAndTimeInterval = [RCFMDBManager getTotalDistanceAndTimeSpend];
    //self.totalLabel.text = totalDistanceAndTimeInterval[0];
    self.totalLabel.text = @"00:00";
    self.totalLabel.textColor = [UIColor yellowColor];
    self.totalLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:80];
    self.totalLabel.textAlignment= NSTextAlignmentCenter;
    [self.totalLabel sizeToFit];
    [self.view addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(showLabel.mas_bottom).offset(-80);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
       // make.bottom.mas_equalTo(btn.mas_top).offset(-30);
    }];
    
    //beginbutton
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor yellowColor].CGColor;
    btn.layer.cornerRadius = 40;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:btn];
    //self.beginButton = btn;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(20);
        make.top.mas_equalTo(self.totalLabel.mas_bottom).offset(30);
    }];
    
    
    //label warning
    UILabel *warningLabel = [[UILabel alloc] init];
    [warningLabel setNumberOfLines:0];
    warningLabel.text = @"跑步模式可能会损耗您的一些电量";
    warningLabel.textColor = [UIColor yellowColor];
    warningLabel.font = [UIFont systemFontOfSize:13];
    warningLabel.textAlignment= NSTextAlignmentCenter;
    [warningLabel sizeToFit];
    warningLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:warningLabel];
    [warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom).offset(50);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-80);
    }];
}

-(void)buttonClick:(id)sender {
    UIViewController *viewController = [[CountDownViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *totalDistanceAndTimeInterval = [RCFMDBManager getTotalDistanceAndTimeSpend];
    self.totalLabel.text = totalDistanceAndTimeInterval[0];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)dealloc {
    NSLog(@"Running ViewController dealloc");
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"Running ViewController will disappear");
}
@end