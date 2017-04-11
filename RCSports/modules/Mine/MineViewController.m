//
//  MineViewController.m
//  RCSports
//
//  Created by liveidzong on 9/19/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeaderView.h"
#import "RCFMDBManager.h"
//#import "MapViewController.h"
#import "RCRunRecord.h"
#import "RCRunRecordCell.h"

@interface MineViewController ()
@property(nonatomic,strong) MineHeaderView *headView;
//get datas from sqlite
@property(nonatomic,strong) NSMutableArray *allDatas;

//
@property (nonatomic,weak) UILabel *totalDistance;
@property (nonatomic,weak) UILabel *totalTimeSpend;
@property (nonatomic,weak) UILabel *totalCalorie;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor= [UIColor whiteColor];
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(90, 150, 69, 69)];
//    btn.backgroundColor = [UIColor redColor];
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStyleDone target:self action:@selector(test)];
//    self.navigationItem.leftBarButtonItem = leftItem;
//    
//    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStyleDone target:self action:@selector(test)];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
//    self.navigationController.navigationBar.titleTextAttributes = dic;
//    
//    self.navigationController.navigationBar.translucent = NO;
    
    
    self.tableView.tableHeaderView = self.headView;
    //self.tableView.sectionIndexColor = [UIColor redColor];
    //减少setter/getter访问次数
    self.totalCalorie = self.headView.totalCalorie;
    self.totalDistance = self.headView.totalDistance;
    self.totalTimeSpend = self.headView.totalTimeSpend;
    [self showLabelValues];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    RCLog(@"mine view controller did load");
    //[self.tableView reloadData];
    //NSLog(@"%@",((RCRunRecord *)self.allDatas[0][3]).startTime);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
    [self showLabelValues];
    RCLog(@"mine vc will appear");
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    RCLog(@"MineViewController的viewDidAppear方法被调用喽");
}
-(MineHeaderView *)headView {
    if(!_headView) {
        _headView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, RCScreenW, 250)];
        [_headView setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1]];
        
    }
    return _headView;
}
-(NSMutableArray *)allDatas {
    if(!_allDatas) {
        _allDatas = [RCFMDBManager getAllListRecords];
    }
    return _allDatas;
}
-(void)showLabelValues {
    NSArray *totalDistanceAndTimeInterval = [RCFMDBManager getTotalDistanceAndTimeSpend];
    //NSLog(@"%@",totalDistanceAndTimeInterval);
    self.totalDistance.text = totalDistanceAndTimeInterval[0];
    NSString *timeIntervals = totalDistanceAndTimeInterval[1];
    NSInteger timeInt = round([timeIntervals doubleValue]);
    //timeInt = 11657290;
    NSInteger hour = (NSInteger)timeInt/3600;
    NSInteger minute = (NSInteger)(timeInt - hour * 3600)/60;
    NSInteger second = (NSInteger)(timeInt - hour * 3600 - minute * 60);
    self.totalTimeSpend.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour, minute ,second];
    self.totalCalorie.text = @"19899.90";
}
-(void)refreshDataFroTableViewWith:(id)object withSection: (NSInteger)section {
    //[self.tableView reloadData];
    if([object isMemberOfClass:[RCRunRecord class]]) {
        if(section != -1) {
            NSMutableArray *arr = self.allDatas[section];
            [arr removeObject:object];
            if(arr.count == 0) {
                [self.allDatas removeObject:arr];
            }
        }else {
            NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];//永远是最上边的一个ROW
            if (self.allDatas.count == 0) {//没有数据时
                [self.allDatas addObject:[NSMutableArray arrayWithObject:object]];
                
                [self.tableView beginUpdates];
                //会自动插入一个cell。。。表视图的相关操作，[必须，不然表视图不会显示更新，光reloadData是不能更新表视图的]
                //可以打印一下数据来看，在insert/delete的时候如果不执行下边视图相关操作的话 表视图不会更新
                [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];//这保证了所有方法执行完成后调用代理方法一次性更新表视图，【该方法执行完，立即调用相关的代理方法更新表视图】
                return;
            }
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *todatStr = [dateFormatter stringFromDate:[NSDate new]];
            //同一个recordDate的加到一个section中
            if ([((RCRunRecord *)self.allDatas[0][0]).recordDate isEqualToString:todatStr]) {
                //NSMutableArray *test = [[NSMutableArray alloc] init];
                
                //[self.allDatas[0] addObject:object];//这一步是用来更新数据源
                [self.allDatas[0] insertObject:object atIndex:0];//作为数组第一个元素,更新数据源
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            }else{
                //要将数组插入最前面，更新数据源
                [self.allDatas insertObject:[NSMutableArray arrayWithObject:object] atIndex:0];
                //[self.allDates addObject:[NSMutableArray arrayWithObject:object]]; error
                
                [self.tableView beginUpdates];
                //批量更新表视图
                [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            }
            
        }
    }
}
#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //NSLog(@"numberOfSectionsInTableView");
    return self.allDatas.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *temp = self.allDatas[section];
    return temp.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *array = self.allDatas[section];
    RCRunRecord *record = array[0];
    return record.recordDate;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *resueId = @"RecordCell";
    [tableView registerClass:[RCRunRecordCell class] forCellReuseIdentifier:resueId];//从代码中注册标识[必须]
    
    RCRunRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:resueId forIndexPath:indexPath];
    
    //configure the cell from the model
    NSArray *arr = self.allDatas[indexPath.section];//得到分组信息
    //分组中的行[1 2 ....n行数据],第几行
    //RCRunRecord *record = arr[indexPath.row];
    //把第0行作为reusableCell
    //RCRunRecord *record = arr[arr.count-1-indexPath.row];
    //当前行作为resueCell
    RCRunRecord *record = arr[indexPath.row];
    cell.accessoryType = 1;
    cell.totalDistance.text = [NSString stringWithFormat:@"%@公里",record.totalDistance];
    cell.totalTime.text = [NSString stringWithFormat:@"%@s",record.timeSpend];
    cell.timeFromTo.text = [NSString stringWithFormat:@"%@ ~ %@",record.startTime,record.endTime];
    
    
    return cell;
}
//cell根据情况自适应高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
//响应选择行动作，跳到mapVC显示当次运动的轨迹
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *arr = self.allDatas[indexPath.section];
    //RCRunRecord *record = (RCRunRecord *)arr[arr.count - 1 - indexPath.row];
    RCRunRecord *record = (RCRunRecord *)arr[indexPath.row];
    //NSLog(@"%@--%@",record.recordDate,record.startTime);
    
    //for sharing record
    self.sharingrecordDate = record.recordDate;
    self.sharingstartTime = record.startTime;
    self.sharingendTime = record.endTime;
    self.sharingtimeSpend = record.timeSpend;
    self.sharingtotalDistance = record.totalDistance;
    
    MapViewController *mapVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"map"];
    //设置mapVC.type
    self.mvc = mapVc;
    mapVc.type = MapViewTypeQueryDetail;
    mapVc.locations = (NSMutableArray *)[RCFMDBManager getLocationsWithDate:record.recordDate andTime:record.startTime];
    NSLog(@"%lu",(unsigned long)mapVc.locations.count);
    if(mapVc.locations ==nil || mapVc.locations.count == 0) {
        RCLog(@"找不到相关信息");
        return;
    }
    [self presentViewController:mapVc animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate 的相关操作

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除此记录";
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除记录?" message:@"确定要删除此记录吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView endEditing:YES];
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self tableView:tableView deleteCellAtIndexPath:indexPath];
            [self showLabelValues];
        }];
        [alert addAction:deleteAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//根据IndexPath删除cell

-(void)tableView:(UITableView *)tableView deleteCellAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.allDatas[indexPath.section];
    //RCRunRecord *record = arr[arr.count - 1 - indexPath.row];
    RCRunRecord *record = arr[indexPath.row];
    if([RCFMDBManager deleteRecordsWithDate:record.recordDate andTime:record.startTime] ) {
        NSMutableArray *arr = self.allDatas[indexPath.section];
        [arr removeObject:record];//删除当前行数据，从而进行更新arr中元素个数  从而进行计算sections数和numberofsection数
        if(arr.count == 0) {
            [self.allDatas removeObject:arr];//如果当前section中没有数据了则删除整个section
        }
        if([tableView numberOfRowsInSection:indexPath.section] == 1) {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else {
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        [tableView endUpdates];
    }
}

#pragma mark - 计算总里程，总时间，消耗的大卡[算法]

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    RCLog(@"mine view controller did disappear");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end