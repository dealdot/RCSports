//
//  RunningDetailViewController.m
//  RCSports
//
//  Created by liveidzong on 9/28/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "RunningDetailViewController.h"
#import "RunningView.h"
#import "MapViewController.h"
#import "UIViewController+MaterialDesign.h"
#import "RCLocationManager.h"
#import "MineViewController.h"
#import "MBProgressHUD.h"
#import "RCRunRecord.h"
#import "RCFMDBManager.h"

#define minSaveCount 3
#define removeObjectsLen 20

@interface RunningDetailViewController()<RCLocationManagerDelegate>
@property(nonatomic,strong) RunningView *runningView;
@property (nonatomic,strong) UIButton *presentControllerButton;

@property (nonatomic,weak) UILabel *distanceLB;
@property (nonatomic,weak) UILabel *timeLB;
@property (nonatomic,weak) UILabel *speedLB;


@end


@implementation RunningDetailViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    self.view = self.runningView;
    [self presentMapVC];
    [self loadSharedRCLocationManagerInstance];
    //更新数据时减少getter访问的次数[???]
    self.distanceLB = self.runningView.distanceLB;
    self.timeLB = self.runningView.timeLB;
    self.speedLB = self.runningView.speedLB;
    [self createPresentControllerButtonStop];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //这里一定要再设置一次，因为如果从地图页面过来的，viewDidLoad()不会再加载了，只会加载viewWillAppear:方法
    self.locationManager.delegate = self;
   [self continueTimer];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTime];
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSRange range = NSMakeRange(0, removeObjectsLen);
    [self.locationManager.locations removeObjectsInRange:range];
                     
}
- (void)createPresentControllerButtonStop
{
    CGFloat y = 400;
    CGFloat width = 90;
    CGFloat height = width;
    CGFloat x = 110;
    
    self.presentControllerButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    self.presentControllerButton.layer.cornerRadius = width / 2.;
    //self.presentControllerButton.backgroundColor = [UIColor redColor];
    
    [self.presentControllerButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    
    [self.presentControllerButton addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.presentControllerButton];
}

-(void)stopRecord {
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    //这一句不用加，因为locationManager是个单例，它的dealloc方法永远不会被调用，因为在程序的生命周期内，该单例一直都存在
    self.locationManager = nil;
}
-(void)loadSharedRCLocationManagerInstance {
    RCLocationManager *locationManager = [RCLocationManager sharedLocationManager];
    if(!locationManager.running) {
        //开始定位,这时locationManager.running = YES;直到点击暂停按钮再把locationManager.running = NO;
        //即running从该VC一加载算起，直到停止按钮点击的时候停止
        //不能把running理解为跑步的时候为true,停止下来休息的时候为false
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
    }
    self.locationManager = locationManager;
}

-(RunningView *)runningView {
    if(!_runningView) {
        _runningView = [[RunningView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    return _runningView;
}
-(void)presentMapVC {
    [self.runningView.mapButton addTarget:self action:@selector(mapShow) forControlEvents:UIControlEventTouchUpInside];
}

-(void)mapShow {
    MapViewController *mapVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"map"];
    mapVc.type = self.locationManager.running;
    mapVc.locationManager = self.locationManager;
    mapVc.locations = [NSMutableArray arrayWithArray:self.locationManager.locations];
    [self presentLHViewController:mapVc tapView:self.runningView.mapButton color:nil animated:YES completion:^{
        
    }];
}

#pragma mark- RCLocationManagerDelegate
-(void)locationManager:(RCLocationManager *)manager didUpdatedLocations:(NSArray<CLLocation *> *)locations {
    //NSLog(@"%@",manager); //<RCLocationManager: 0x156f95860>,
    //占位符 '%0M.Nlf'表示小数点为N位，长度为M-1位，如3.1--->%05.2lf-->03.10
    self.distanceLB.text = [NSString stringWithFormat:@"%05.2lf",manager.totalDistance/1000.0];
    self.speedLB.text = [NSString stringWithFormat:@"%05.2lf",manager.speed > 0 ? manager.speed:0];
}

-(void)locationManager:(RCLocationManager *)manager didChangeLocationsState:(BOOL)running {
    if(running) {
        [self.runningView startTimer];
        UIApplication *app = [UIApplication sharedApplication];
        //接收当前的UIApplication[单例]发送的通知，然后处理selector
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueTimer) name:UIApplicationWillEnterForegroundNotification object:app];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTime) name:UIApplicationDidEnterBackgroundNotification object:app];
        
    }else {
        //点击停止按钮后
        [self.runningView stopTimer];
        __block RCRunRecord *record = nil;
        
        //hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        UINavigationController *navVC = self.tabBarController.viewControllers[4];
        MapViewController *mapVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"map"];
        //下面开始做保存的工作
        if(self.locationManager.locations.count < minSaveCount) {
            [self.runningView resetRecord];
            //弹出
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"距离太短,无法保存" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *doAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];

            [alert addAction:doAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else if(self.locationManager.locations.count >= minSaveCount) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                
                
                //下边的操作会阻塞主线程
                if((record = [RCFMDBManager saveLocations])) {
                    //NSLog(@"%@",record);
                    //NSLog(@"保存成功");
                    //show it
                    
                    
                    //  NSLog(@"%@",mineVC);

                    //设置mapVC.type
                    mapVc.type = MapViewTypeDetail;
                    //设置mapVC.locations,从数据库所中取出当前一次保存的数据
                    mapVc.locations = (NSMutableArray *)[RCFMDBManager getLocationsWithDate:record.recordDate andTime:record.startTime];
                    //NSLog(@"%lu",(unsigned long)mapVc.locations.count);
                    //self.tabBarController.selectedIndex = 4;
                    
                    
                }
                //主线程中更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    MineViewController *mineVC = navVC.viewControllers[0];
                    //这里引用
                    mineVC.mvc = mapVc;
                    
                    //for sharing record
                    mineVC.sharingrecordDate = record.recordDate;
                    mineVC.sharingstartTime = record.startTime;
                    mineVC.sharingendTime = record.endTime;
                    mineVC.sharingtimeSpend = record.timeSpend;
                    mineVC.sharingtotalDistance = record.totalDistance;
                    
                    //要在主线程中进行更新
                    self.tabBarController.selectedViewController = navVC;
                    //[NSThread sleepForTimeInterval:4];
                    //[navVC pushViewController:mapVc animated:YES];
                    
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    [navVC pushViewController:mapVc animated:YES];
                    //[mineVC presentViewController:mapVc animated:NO completion:nil];
                    if ([mineVC isViewLoaded]) { //这个属性太TM重要了
                       [mineVC refreshDataFroTableViewWith:record withSection: -1];//error line
                    }
                    
                });
            });
        }

        //进行跳转
//        UINavigationController *navVC = self.tabBarController.viewControllers[4];
//        QueryDetailViewController *queryDetailVC= [[QueryDetailViewController alloc] init];
//        //self.tabBarController.selectedViewController = navVC;//实现类似点击效果,点击后才能加载VC
//        self.tabBarController.selectedIndex = 4;
//        [navVC pushViewController:queryDetailVC animated:YES];
//        [self.navigationController popToRootViewControllerAnimated:NO];
        
        //进行跳转
//        UINavigationController *navVC = self.tabBarController.viewControllers[4];
       // MineViewController *mineVC = navVC.viewControllers[0];
        //  NSLog(@"%@",mineVC);
        //[mineVC refreshDataFroTableViewWith:record withSection: -1];
//        MapViewController *mapVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"map"];
        //设置mapVC.type
//        mapVc.type = MapViewTypeDetail;
        //设置mapVC.locations,从数据库所中取出当前一次保存的数据
//        mapVc.locations = (NSMutableArray *)[RCFMDBManager getLocationsWithDate:record.recordDate andTime:record.startTime];
        //NSLog(@"%lu",(unsigned long)mapVc.locations.count);
        //self.tabBarController.selectedIndex = 4;
//        self.tabBarController.selectedViewController = navVC;
//        [navVC pushViewController:mapVc animated:YES];
//        [self.navigationController popToRootViewControllerAnimated:NO];

        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

-(void)continueTimer {
    if(self.locationManager.running) {
      //  self.distanceLB.text = [NSString stringWithFormat:@"%05.2lf",self.locationManager.totalDistance/1000.0];
      //  self.speedLB.text = [NSString stringWithFormat:@"%05.2lf",self.locationManager.speed > 0 ? self.locationManager.speed:0];
        [self.runningView.timer setFireDate:[NSDate distantPast]];
        NSDate *nowDate = [[NSDate alloc] init];
        NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:self.locationManager.startLocationDate];
        self.runningView.timerNumber = (NSInteger)timeInterval;
    }
}

-(void)stopTime {
    //关闭定时器
    [self.runningView.timer setFireDate:[NSDate distantFuture]];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)dealloc {
    NSLog(@"detailVC dealloc");
}
@end