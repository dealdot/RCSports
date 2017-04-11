//
//  MapViewController.h
//  RCSports
//
//  Created by liveidzong on 10/4/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLocationManager.h"
@class CLLocation;
typedef enum: NSUInteger {
    //定位 0,默认的
    MapViewTypeLocation,
    //运动轨迹 1
    MapViewTypeRunning,
    //轨迹回放 2
    MapViewTypeQueryDetail,
    //专用于保存的时候返回的轨迹
    MapViewTypeDetail
}MapViewType;

@interface MapViewController : UIViewController
//记录用户移动位置集合
@property(nonatomic,strong) NSMutableArray<CLLocation *> *locations;
//MapViewController的显示类型
@property(nonatomic) MapViewType type;
@property(nonatomic,strong) RCLocationManager *locationManager;
-(UIImage *)takeSnapshots;
@end