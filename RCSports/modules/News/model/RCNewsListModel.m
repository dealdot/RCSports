//
//  RCNewsListModel.m
//  RCSports
//
//  Created by liveidzong on 11/19/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "RCNewsListModel.h"

@implementation RCNewsListModel

-(NSArray *)RCNewsListModelWithArray:(id)responseObj {
    NSMutableArray <RCNewsListModel *> *arr = [NSMutableArray arrayWithCapacity:20];
    for (NSDictionary *dic in responseObj) {
        RCNewsListModel *newslist = [[RCNewsListModel alloc] init];
        newslist.docid = dic[@"docid"];
        newslist.ptime = dic[@"ptime"];
        newslist.url_3w = dic[@"url_3w"];
        newslist.title = dic[@"title"];
        newslist.imgUrl = dic[@"imgsrc"];
        newslist.digest = dic[@"digest"];
        if([dic valueForKey:@"imgextra"]) {
            newslist.imgextra = @[dic[@"imgextra"][0][@"imgsrc"],dic[@"imgextra"][1][@"imgsrc"]];
        }
        [arr addObject:newslist];
    }
    id objs = [NSMutableArray array];
    
    return arr;
}
@end
