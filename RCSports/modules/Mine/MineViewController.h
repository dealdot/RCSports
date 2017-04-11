//
//  MineViewController.h
//  RCSports
//
//  Created by liveidzong on 9/19/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
@interface MineViewController : UITableViewController
//for sharing record
@property(nonatomic,copy) NSString *sharingrecordDate;
@property(nonatomic,copy) NSString *sharingstartTime;
@property(nonatomic,copy) NSString *sharingendTime;
@property(nonatomic,copy) NSString *sharingtotalDistance;
@property(nonatomic,copy) NSString *sharingtimeSpend;
@property(nonatomic,weak) MapViewController *mvc;

-(void)refreshDataFroTableViewWith:(id)object withSection: (NSInteger)section;
@end