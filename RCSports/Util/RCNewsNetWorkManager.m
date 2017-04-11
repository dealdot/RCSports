//
//  RCNewsNetWorkManager.m
//  RCSports
//
//  Created by liveidzong on 11/19/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "RCNewsNetWorkManager.h"
#import "AFNetworking.h"
@implementation RCNewsNetWorkManager


+(id)GetMethod:(NSString *)path andParameter:(NSDictionary *)parameter completeHandle:(void(^)(id,NSError *))handle {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *urlPath = [NSString stringWithFormat:@"%@%@-20.html", path, parameter[@"pageNumber"]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    return nil;
}

@end
