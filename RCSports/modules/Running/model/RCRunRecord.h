//
//  RCRunRecord.h
//  RCSports
//
//  Created by liveidzong on 10/15/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCRunRecord : NSObject
@property(nonatomic,copy) NSString *recordDate;
@property(nonatomic,copy) NSString *startTime;
@property(nonatomic,copy) NSString *endTime;
@property(nonatomic,copy) NSString *totalDistance;
@property(nonatomic,copy) NSString *timeSpend;
@property(nonatomic,copy) NSString *timeInterval;
@end