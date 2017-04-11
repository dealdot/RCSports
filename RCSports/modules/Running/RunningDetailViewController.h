//
//  RunningDetailViewController.h
//  RCSports
//
//  Created by liveidzong on 9/28/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCLocationManager;
@interface RunningDetailViewController : UIViewController
@property(nonatomic,strong) RCLocationManager *locationManager;
@end