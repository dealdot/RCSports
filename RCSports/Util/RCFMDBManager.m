//
//  RCFMDBManager.m
//  RCSports
//
//  Created by liveidzong on 10/15/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "RCFMDBManager.h"
#import "RCLocationManager.h"
#import "FMDB.h"

@implementation RCFMDBManager
+(FMDatabase *)defaultDatabase {
    static FMDatabase *db = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        docPath = [docPath stringByAppendingPathComponent:@"sqlite.db"];
        db = [FMDatabase databaseWithPath:docPath];
        if([db open]) {
            NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS RecordTable (recordDate TEXT,startTime TEXT,endTime TEXT,totalDistance TEXT,timeSpend Text,timeInterval Text)";
            BOOL res = [db executeUpdate:sqlCreateTable];
            if(!res) {
                NSLog(@"error when creating tabel RecordTable");
            }else {
                NSLog(@"creating tabel RecordTable Success");
            }
            sqlCreateTable = @"CREATE TABLE IF NOT EXISTS LocationsTable(recordDate TEXT,startTime TEXT,longitude TEXT,latitude TEXT)";
            res = [db executeUpdate:sqlCreateTable];
            if(!res) {
               NSLog(@"error when creating tabel LocationsTable");
            }else {
                NSLog(@"creating tabel LocationsTable Success");
            }
            //创建完后关闭数据库连接
            [db close];
        }
    });
    return db;
}

+(BOOL)executeUpdateWithSql:(NSString *)sql {
    FMDatabase *db = [self defaultDatabase];
    if([db open]) {
        BOOL res = [db executeUpdate:sql];
        if(!res) {
            NSLog(@"error happened when executeUpdate table with sql:%@",sql);
        }
        [db close];
        return res;
    }
    return NO;
}

//+(BOOL)executeUpdateWithSqlUsingTransactionForArray:(NSArray <CLLocation *>*) locationArray {
//    FMDatabase *db = [self defaultDatabase];
//    if([db open]) {
//        [db beginTransaction];
//        BOOL isRollBack = NO;
//        @try {
//            for(CLLocation *location in locationArray) {
//                BOOL isSucceed = [RCFMDBManager executeUpdateWithSql:[NSString stringWithFormat:@"INSERT INTO LocationsTable(recordDate, startTime, longitude, latitude) VALUES ('%@', '%@', '%lf', '%lf')",record.recordDate, record.startTime, location.coordinate.longitude,location.coordinate.latitude]];
//            }
//        } @catch (NSException *exception) {
//            //
//        } @finally {
//            //
//        }
//    }
//    return NO;
//}

//把数据从数据库中取出并交给RCRunRecord实例,然后把RCRunRecord的实例集合放到数组中arr中去
+(NSMutableArray *)resToList:(FMResultSet *)res {
    NSMutableArray *arr = [[NSMutableArray alloc] init];//里边的对象是数组
    NSString *date = nil;
    while ([res next]) {
        RCRunRecord *record = [[RCRunRecord alloc] init];
        record.recordDate = [res stringForColumn:@"recordDate"];
        record.startTime = [res stringForColumn:@"startTime"];
        record.endTime = [res stringForColumn:@"endTime"];
        record.totalDistance = [res stringForColumn:@"totalDistance"];
        record.timeSpend = [res stringForColumn:@"timeSpend"];
        //同一个日期的加到一起
        if([record.recordDate isEqualToString:date]) {
            NSMutableArray <RCRunRecord *> *dataArr = [arr lastObject];
            [dataArr addObject:record];
            //等价于
            //[[arr lastObject] addObject:record];
        }else {
            [arr addObject:[[NSMutableArray alloc] initWithObjects:record, nil]];
        }
        date = record.recordDate;
    }
    return arr;
}



+(BOOL)deleteRecordsWithDate:(NSString *)startDate andTime:(NSString *)startTime {
   return  [self executeUpdateWithSql:[NSString stringWithFormat:@"DELETE FROM RecordTable WHERE recordDate = '%@' AND startTime = '%@'",startDate,startTime]];
}

+(NSMutableArray<CLLocation *> *)getLocationsWithDate:(NSString *)startDate andTime:(NSString *)startTime {
    FMDatabase *db = [self defaultDatabase];
    if([db open]) {
        FMResultSet *res = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM LocationsTable WHERE recordDate = '%@' and startTime = '%@' ",startDate,startTime]];
        NSMutableArray<CLLocation *> *array = [NSMutableArray new];
        while([res next]) {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[res stringForColumn:@"latitude"].doubleValue longitude:[res stringForColumn:@"longitude"].doubleValue];
            [array addObject:location];
        }
        [db closeOpenResultSets];
        [db close];
        return [array copy];
    }
    return nil;
}

+(NSMutableArray *)getAllListRecords {
    FMDatabase *db = [self defaultDatabase];
    if([db open]) {
        FMResultSet *res = [db executeQuery:@"SELECT * FROM RecordTable ORDER BY recordDate DESC,startTime DESC"];
        NSMutableArray *arr = [self resToList:res];
        [db closeOpenResultSets];
        [db close];
        return arr;
    }
    return nil;
}

+(NSArray *)getTotalDistanceAndTimeSpend {
    NSArray *timeAndDistance = nil;
    NSString *totalDistance = nil;
    NSString *timeIntervals = nil;
    FMDatabase *db = [self defaultDatabase];
    if([db open]) {
        //查询结果是标量
        FMResultSet *res = [db executeQuery:@"SELECT SUM(totalDistance),SUM(timeInterval) FROM RecordTable"];
        while ([res next]) {
            //直接取第0行的数据
            totalDistance = [NSString stringWithFormat:@"%05.2lf",[res doubleForColumnIndex:0]];
            timeIntervals = [NSString stringWithFormat:@"%ld",[res longForColumnIndex:1]];
        }
        timeAndDistance = @[totalDistance,timeIntervals];
    }
    //NSLog(@"%@--%@",totalDistance,timeIntervals);
    return timeAndDistance;
}

+(RCRunRecord *)saveLocations {
    RCLocationManager *locationManager = [RCLocationManager sharedLocationManager];

    NSArray <CLLocation *> *array = locationManager.locations;
    NSTimeInterval timeInterval = [[array lastObject].timestamp timeIntervalSinceDate:[array firstObject].timestamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    RCRunRecord *record = [[RCRunRecord alloc] init];
    record.startTime = [dateFormatter stringFromDate:[array firstObject].timestamp];
    record.endTime = [dateFormatter stringFromDate:[array lastObject].timestamp];
    record.totalDistance = [NSString stringWithFormat:@"%.2lf",locationManager.totalDistance/1000.0];
    
    NSInteger hour = (NSInteger)timeInterval/3600;
    NSInteger minute = (NSInteger)(timeInterval - hour * 3600)/60;
    NSInteger second = (NSInteger)(timeInterval - hour * 3600 - minute * 60);
    
    
    record.timeSpend = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,second];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    record.recordDate = [dateFormatter stringFromDate:[array firstObject].timestamp];
    record.timeInterval = [NSString stringWithFormat:@"%lf",timeInterval];//NSTimeInterval是double类型
    
    if(record.recordDate == nil) return nil;
    //下边开始更新数据到数据库中[一次插入一条数据]
    BOOL isSucceed = [RCFMDBManager executeUpdateWithSql:[NSString stringWithFormat:@"INSERT INTO RecordTable(recordDate, startTime, endTime, totalDistance, timeSpend, timeInterval) VALUES ('%@', '%@', '%@', '%@', '%@', '%@')",record.recordDate, record.startTime, record.endTime, record.totalDistance, record.timeSpend, record.timeInterval]];
    if(!isSucceed) return nil;
    
    //这样的操作效率低，回来用事务 Transaction
//    for(CLLocation *location in array) {
//        isSucceed = [RCFMDBManager executeUpdateWithSql:[NSString stringWithFormat:@"INSERT INTO LocationsTable(recordDate, startTime, longitude, latitude) VALUES ('%@', '%@', '%lf', '%lf')",record.recordDate, record.startTime, location.coordinate.longitude,location.coordinate.latitude]];
//        if(!isSucceed) return nil;
//    }
    
    //改用事务[速度提升10倍]
    FMDatabase *db = [self defaultDatabase];
    if([db open]) {
        [db beginTransaction];
        BOOL isRollBack = NO;
        @try {
            //一次插入多条数据
            for(CLLocation *location in array) {
                isSucceed = [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO LocationsTable(recordDate, startTime, longitude, latitude) VALUES ('%@', '%@', '%lf', '%lf')",record.recordDate, record.startTime, location.coordinate.longitude,location.coordinate.latitude]];
                if(!isSucceed) return nil;
            }
        } @catch (NSException *exception) {//@try{}中发生了异常会执行,这个异常是指[比如executeUpdate的时候字段不匹配,网络延时]
            isRollBack = YES;
            [db rollback];
        } @finally { //即使try,catch中return了,finally里的语句也会执行,最好不要在finally中加return语句
            if(!isRollBack) {
                [db commit];
            }
            [db close];
        }
    }
    
    return record;
}
@end