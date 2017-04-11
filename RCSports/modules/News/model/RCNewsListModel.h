//
//  RCNewsListModel.h
//  RCSports
//
//  Created by liveidzong on 11/19/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCNewsListModel : NSObject
//每条新闻发布的时间
@property(nonatomic,copy) NSString *ptime;
//新闻列表list中的标题
@property(nonatomic,copy) NSString *title;
//新闻的url地址，url_3w是自适应的布局，只接用即可
@property(nonatomic,copy) NSString *url_3w;
//对应的docid即栏目id
@property(nonatomic,copy) NSString *docid;
//新闻列表对应的icon的url
@property(nonatomic,copy) NSString *imgUrl;
//对应的副标题
@property(nonatomic,copy) NSString *subtitle;
//对应的简介
@property(nonatomic,copy) NSString *digest;
//新闻中对应的多图类型
@property(nonatomic,strong) NSArray *imgextra;


//根据拿到的字典数据转换为数组返回
-(NSArray *)RCNewsListModelWithArray:(id)responseObj;

@end