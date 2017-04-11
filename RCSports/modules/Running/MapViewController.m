//
//  MapViewController.m
//  RCSports
//
//  Created by liveidzong on 10/4/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "MapViewController.h"
#import "UIViewController+MaterialDesign.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Utils/BMKGeometry.h>//只引入所需的单个头文件,用于计算


#define polylineWidth 5.5
#define polylineColors [[UIColor yellowColor] colorWithAlphaComponent:1]
#define polylineColor [UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:224.0/255.0 alpha:1.0]
#define mapViewZoomLevel 20
#define removeObjectsLen 20

//for sharing view
#import "RCActionView.h"

@interface MapViewController()<BMKMapViewDelegate,RCLocationManagerDelegate>
//显示百度地图view
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property(nonatomic,strong) BMKPolyline *polyLine;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *dissMissBtn;

@property(nonatomic,weak) BMKPointAnnotation *startAnnotation;
@end


@implementation MapViewController


-(UIImage *)takeSnapshots {
    UIImage *shareImage = [self.mapView takeSnapshot];
    return shareImage;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self BMKMapConfiguration];
    [self initMapLocation];
    
    //NSLog(@"%lu",self.type);
   // NSLog(@"%lu",(unsigned long)self.locations.count);
}
-(void)initMapLocation {
    
    if ( MapViewTypeRunning == self.type ) {
        self.shareButton.hidden = YES;

    }else if (MapViewTypeDetail == self.type) {
        self.dissMissBtn.hidden = YES;
        return;//如果是查询轨迹的话直接返回
    }else if (MapViewTypeQueryDetail == self.type) {
        return;
    }
    self.mapView.zoomLevel = mapViewZoomLevel;
    //self.locationManager = [RCLocationManager sharedLocationManager];
    self.locationManager.delegate = self;
    //开始定位[在RunningDetailViewController中已经开启了，这里不会再开启,因为有逻辑判断]
    [self.locationManager startUpdatingLocation];
    
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    self.mapView.showsUserLocation = YES;
    
    
    if(MapViewTypeRunning == self.type) {
        BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc] init];
        displayParam.isRotateAngleValid = YES;//跟随角度生效果
        displayParam.isAccuracyCircleShow = NO;//不显示精度圈
        displayParam.locationViewOffsetX = 0; //定位偏移量【经度】
        displayParam.locationViewOffsetY = 0;//定位偏移量【纬度】
        displayParam.locationViewImgName = @"walk";
        [self.mapView updateLocationViewWithParam:displayParam];
    }
    
}
-(void)addOneViewTest {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:view];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self addOneView];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    //开始更新位置信息
    if(MapViewTypeQueryDetail != self.type || MapViewTypeDetail != self.type) {
        //从locationManager处获得位置信息更新跑步者在地图中的位置
        BMKUserLocation *userLocation = self.locationManager.userLocation;
        self.mapView.centerCoordinate = userLocation.location.coordinate;
        [self.mapView updateLocationData:userLocation];
    }
    if(MapViewTypeLocation != self.type) {
        [self drawWalkPolyline:self.locations];
        [self mapViewFitPolyLine:self.polyLine];
        if((self.type == MapViewTypeQueryDetail ||self.type == MapViewTypeDetail)&&self.locations.count>1) {
            [self createPointWithLocation:[self.locations lastObject] title:@"终点"];
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.locationManager.delegate = nil;
    UIImage *image = [self takeSnapshots];
    NSLog(@"%@",image);
}


- (IBAction)shareMyRunning:(id)sender {
    
    [[RCActionView sharedActionView] showGridMenuWithItemTitles:@[
                                                                  @"新浪微博", @"微信好友", @"Google+", @"Linkedin",
                                                                  @"Facebook", @"Twitter", @"Pocket", @"Dropbox"
                                                                  ]
                                                         images:@[
                                                                  [UIImage imageNamed:@"weibo"],
                                                                  [UIImage imageNamed:@"wechat"],
                                                                  [UIImage imageNamed:@"googleplus"],
                                                                  [UIImage imageNamed:@"linkedin"],
                                                                  [UIImage imageNamed:@"facebook"],
                                                                  [UIImage imageNamed:@"twitter"],
                                                                  [UIImage imageNamed:@"pocket"],
                                                                  [UIImage imageNamed:@"dropbox"]
                                                                  ]];
    [RCActionView sharedActionView].style = RCActionViewStyleLight;
}



- (IBAction)dissMapVC:(id)sender {
    
    //[self dismissLHViewControllerWithTapView:sender color:nil animated:YES completion:^{}];
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.type == MapViewTypeRunning) return;
    
   // [self.locationManager stopUpdatingLocation];
}

-(void)BMKMapConfiguration {
    //[self.mapView setTrafficEnabled:YES];
    //self.mapView.mapType = BMKMapTypeSatellite;
    //self.mapView.showsUserLocation = YES;
}
#pragma mark - 路径绘制

-(void)drawWalkPolyline:(NSArray *)locations {
    //轨迹点的个数
    NSUInteger count = locations.count;
    //动态分配存储空间,BMKMapPoint是个结构体，表示地理坐标点，X表示横坐标，Y表示纵坐标
    //动态new一个tempPoints临时数组
    BMKMapPoint *tempPoints = malloc(sizeof(BMKMapPoint)*count);
    
    [locations enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL * _Nonnull stop) {
        BMKMapPoint locationPoint = BMKMapPointForCoordinate(location.coordinate);
        tempPoints[idx] = locationPoint;
    }];
    if(!_startAnnotation &&count > 0) {
        _startAnnotation = [self createPointWithLocation:[self.locations firstObject] title:@"起点"];
    }
    //移除原有的绘图，避免重画
    if(self.polyLine) {
        [self.mapView removeOverlay:self.polyLine];
    }
    //通过BMKMapPoint点绘制折线
    self.polyLine = [BMKPolyline polylineWithPoints:tempPoints count:count];
    //把折线添加到地图上显示
    if(self.polyLine) {
        [self.mapView addOverlay:self.polyLine];
    }
    //清空临时数组
    free(tempPoints);
}

//根据polyLine设置地图范围

- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {

    //一个矩形的四边
    /** ltx: top left x */
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    
    BMKMapRect mapRect;
    mapRect.origin = BMKMapPointMake(ltX, ltY);
    mapRect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [self.mapView setVisibleMapRect:mapRect ];
    
   //self.mapView.zoomLevel = self.mapView.zoomLevel - 0.3;
    
    CGPoint point = [self.mapView convertCoordinate:self.locations.firstObject.coordinate toPointToView:self.mapView];
    if (16777215 == point.x) {
        [self.mapView zoomOut];
    }
    [self.mapView zoomOut];
}

//在地图上添加一个大头针
-(BMKPointAnnotation *)createPointWithLocation:(CLLocation *)location title:(NSString *)title {
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
    point.coordinate = location.coordinate;
    point.title = title;
    [self.mapView addAnnotation:point];
    return point;
}

#pragma mark - BMKMapViewDelegate

-(void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    NSLog(@"地图加载完毕");
}

-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = polylineColor;
        polylineView.lineWidth = polylineWidth;
        return polylineView;
    }
    return nil;
}
//原作者说添加大头针的时候调用,viewDidLoad中不会调用
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        if([[annotation title] isEqualToString:@"起点"]) {
            annotationView.pinColor = BMKPinAnnotationColorGreen;
        }else if ([[annotation title] isEqualToString:@"终点"]) {
            annotationView.pinColor = BMKPinAnnotationColorRed;
        }else {
            annotationView.pinColor = BMKPinAnnotationColorPurple;
        }
        //从天上xiu掉下来的动画
        annotationView.animatesDrop = YES;
        //不可拖拽
        annotationView.draggable = NO;
        return annotationView;
    }
    return nil;
}

#pragma mark - RCLocationManagerDelegate
//位置变化的时候调用
-(void)locationManager:(RCLocationManager *)manager didUpdatedLocations:(NSArray<CLLocation *> *)locations {
    BMKUserLocation *userLocation = manager.userLocation;
    [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [self.mapView updateLocationData:userLocation];
    if(self.type != MapViewTypeLocation) {
        [self drawWalkPolyline:locations];
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSRange range = NSMakeRange(0, removeObjectsLen);
    [self.locationManager.locations removeObjectsInRange:range];
}
-(void)dealloc {
    NSLog(@"map view controller dealloc");
}
@end