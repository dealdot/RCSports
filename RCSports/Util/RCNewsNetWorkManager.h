//
//  RCNewsNetWorkManager.h
//  RCSports
//
//  Created by liveidzong on 11/19/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCNewsListModel.h"

@interface RCNewsNetWorkManager : NSObject

//通过get方式请求数据

+(id)GetMethod:(NSString *)path andParameter:(NSDictionary *)parameter completeHandle:(void(^)(id,NSError *))handle;


@end