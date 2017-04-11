//
//  CountDownViewController.m
//  RCSports
//
//  Created by liveidzong on 9/26/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "CountDownViewController.h"
#import "RunningDetailViewController.h"
#import "Masonry.h"

@interface CountDownViewController ()
@property (strong, nonatomic) UILabel *timeCount;
@end

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view.
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [countLabel setNumberOfLines:0];
    countLabel.textColor = [UIColor redColor];
    countLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:100];
    countLabel.textAlignment= NSTextAlignmentCenter;
    [countLabel sizeToFit];
    countLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    
    self.timeCount = countLabel;
    
    [self AnimationForCountDown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)AnimationForCountDown {
    __block NSInteger number = 4;
    
    NSTimeInterval period = 1.0;
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    dispatch_source_set_timer(source, start, period*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(source, ^(){
        
        number--;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timeCount.enabled = NO;
            self.timeCount.userInteractionEnabled = NO;
            self.timeCount.text = [NSString stringWithFormat:@"%zi",number];
            [self scaleAnimationWithLayer:self.timeCount.layer andScale:@[[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.5],[NSNumber numberWithFloat:2.0]]];
        });
        
        if (number == 1) {
            dispatch_source_cancel(source);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeCount.enabled = NO;
                self.timeCount.userInteractionEnabled = NO;
                [self performSelector:@selector(pushDetailVC) withObject:nil afterDelay:0.8];
               // NSLog(@"go go go");
            });
        }
        
    });
    dispatch_resume(source);
}
-(void)pushDetailVC {
    RunningDetailViewController *detailVC= [[RunningDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
   // NSMutableArray *array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    //删除最后一个，也就是自己
    //[array removeObjectAtIndex:array.count-2];
   // self.navigationController.viewControllers = array;
    
    NSLog(@"%@",self.navigationController.viewControllers);
}

- (void)scaleAnimationWithLayer:(CALayer *)layer andScale:(NSArray *)scales {
    CFTimeInterval beginTime = CACurrentMediaTime();//当前CALayer的时间
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.keyTimes = @[scales[0], scales[1], scales[2]];
    scaleAnimation.values = @[scales[2], scales[3], scales[4]];
    scaleAnimation.duration = 1.0;
    
    CAKeyframeAnimation *opacityAnimaton = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimaton.keyTimes = @[scales[0], scales[1], scales[2]];
    opacityAnimaton.values = @[scales[2], scales[3], scales[4]];
    opacityAnimaton.duration = 1.0;
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    
    animations.animations = @[scaleAnimation, opacityAnimaton];
    animations.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animations.duration = 1.0;
    animations.removedOnCompletion = false;
    
    animations.beginTime = beginTime;
    [layer addAnimation:animations forKey:@"animation"];
}
-(void)dealloc {
    NSLog(@"CountDownViewController dealloc");
}
@end