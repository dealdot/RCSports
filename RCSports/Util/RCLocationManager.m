//
//  RCLocationManager.m
//  RCSports
//
//  Created by liveidzong on 10/6/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "RCLocationManager.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
//定位头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface RCLocationManager()<BMKLocationServiceDelegate>
@property(nonatomic,strong) BMKLocationService *locationService;
@end

#define minDistance 5.0f
@implementation RCLocationManager

//生成单例
+(RCLocationManager *)sharedLocationManager {
    static RCLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RCLocationManager alloc] init];
    });
    return manager;
}
//getter
-(NSMutableArray<CLLocation *>*)locations {
    if(!_locations) {
        _locations = [[NSMutableArray alloc] init];
    }
    return _locations;
}
#pragma mark - BMKLocationServiceDelegate
//是否正确定位
-(void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"定位失败 error : %@",error);
}
//处理位置更新,即有位置更新的时候调用
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    //类似A[委托方]的类BMKLocationService这个为参数userLocation提供由来
    self.userLocation = userLocation;
    CLLocation *location = userLocation.location;
    if(location.horizontalAccuracy <0 ||location.horizontalAccuracy>20.0) {
        NSLog(@"GPS信号差");
    }
//    else if (0<location.horizontalAccuracy&&location.horizontalAccuracy<10) {
//        NSLog(@"GPS信号强");
    else {
        if(self.locations.count>1) {
            //计算本次定位数据与上一次的距离
            CGFloat distance = [location distanceFromLocation:[self.locations lastObject]];
            if(distance > minDistance) {
                self.totalDistance += distance;
                self.speed = location.speed;
            }else {
                //不添加距离太近的两点，minDistance = 5 因为误差比较大
                //程序在前台,或者在后台运行，即还保持活动状态,允许程序在后台运行
                UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
                if( applicationState == UIApplicationStateActive||applicationState == UIApplicationStateBackground ) {
                    //位置发生变化的时候调用
                    [self.delegate locationManager:self didUpdatedLocations:self.locations];
                }
                return;
            }
        }
        //每次移动，位置更新的时候把当前的location加入数组self.locations
        [self.locations addObject:location];
    }
    //程序在前台,或者在后台运行，即还保持活动状态,允许程序在后台运行
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
    if(applicationState == UIApplicationStateActive||applicationState ==UIApplicationStateBackground) {
        //位置发生变化的时候调用
        [self.delegate locationManager:self didUpdatedLocations:self.locations];
    }
}


//开始更新位置
-(void)startUpdatingLocation {
    if(self.running) {
        //已经在定时了
        return;
    }
    if(!_locationService) {
        _locationService = [[BMKLocationService alloc] init];
        
        if([UIDevice currentDevice].systemVersion.doubleValue>=9.0) {
            _locationService.allowsBackgroundLocationUpdates = YES;
        }
        
        _locationService.desiredAccuracy = kCLLocationAccuracyBest;
        _locationService.pausesLocationUpdatesAutomatically = NO;
        _locationService.delegate = self;
    }
    self.totalDistance = 0;
    self.running = YES;
    if([self.delegate respondsToSelector:@selector(locationManager:didChangeLocationsState:) ]) {
        [self.delegate locationManager:self didChangeLocationsState:self.running];
    }
    //开始定位前清空数组
    [self.locations removeAllObjects];
    [self.locationService startUserLocationService];
    self.startLocationDate = [[NSDate alloc]init];//当前时间
    
}

//结束位置更新,即跑步结束
-(void)stopUpdatingLocation {
    [self.locationService stopUserLocationService];
    self.locationService = nil;
    self.running = NO;
    if([self.delegate respondsToSelector:@selector(locationManager:didChangeLocationsState:) ]) {
        [self.delegate locationManager:self didChangeLocationsState:self.running];
    }
}
//该方法永远不会被调用，因为在程序的生命周期内，该单例是一直存在的
-(void)dealloc {
    NSLog(@"RCLocationManager dealloc");
}

@end