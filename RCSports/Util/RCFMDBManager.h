//
//  RCFMDBManager.h
//  RCSports
//
//  Created by liveidzong on 10/15/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCRunRecord.h"
#import "FMDatabase.h"
#import <CoreLocation/CoreLocation.h>

@interface RCFMDBManager : NSObject
//单一数据库实例
+(FMDatabase *)defaultDatabase;
//执行创建表,增删改sql语句
+(BOOL)executeUpdateWithSql:(NSString *)sql;
//查询操作
//+(NSArray *)executeQueryWithSql:(NSString *)sql;
//保存所有的locations
+(RCRunRecord *)saveLocations;

//返回所有数据
+(NSMutableArray *)getAllListRecords;

//按日期取回数据
+(NSArray<CLLocation *> *)getLocationsWithDate:(NSString *)startDate andTime:(NSString *)startTime;
//按日期删除数据
+(BOOL)deleteRecordsWithDate:(NSString *)startDate andTime:(NSString *)startTime;
//获取RecordTable表中的所有行的totalDistance和timeSpend,并计算加和值，以便显示总里程数，所花时间，从而计算出总卡路里数
+(NSArray *)getTotalDistanceAndTimeSpend;
@end