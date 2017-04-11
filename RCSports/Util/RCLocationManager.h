//
//  RCLocationManager.h
//  RCSports
//
//  Created by liveidzong on 10/6/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RCLocationManager,BMKUserLocation,CLLocation;

@protocol RCLocationManagerDelegate <NSObject>
//当位置发生变化的时候调用
-(void)locationManager:(RCLocationManager *)manager didUpdatedLocations:(NSArray<CLLocation *> *)locations;

//当运动状态发生变化时候调用 [即是running 是true还是false]
@optional
-(void)locationManager:(RCLocationManager *)manager didChangeLocationsState:(BOOL)running;

@end


@interface RCLocationManager : NSObject
//存储用户每次移动的位置点
@property(nonatomic,strong) NSMutableArray<CLLocation *> *locations;
@property(nonatomic,weak) id <RCLocationManagerDelegate> delegate;

//保存总记录
@property(nonatomic) double totalDistance;
//速度
@property(nonatomic) double speed;
//定位开始时间
@property(nonatomic,strong) NSDate *startLocationDate;
//是否是在运动
@property(nonatomic,getter=isRunning) BOOL running;
//显示当前所在的位置
@property(nonatomic,strong) BMKUserLocation *userLocation;

//定义一个RCLocationManager的单例
+(RCLocationManager *)sharedLocationManager;

//开始定位
-(void)startUpdatingLocation;

//停止定位
-(void)stopUpdatingLocation;
@end