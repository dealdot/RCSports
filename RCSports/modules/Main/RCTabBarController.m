//
//  RCTabBarController.m
//  RCSports
//
//  Created by liveidzong on 9/19/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "RCTabBarController.h"
#import "RCNavigationController.h"
//import tab bar view controllers
#import "RunningViewController.h"
#import "NewsViewController.h"
#import "MineViewController.h"
#import "CircleViewController.h"
#import "MessageViewController.h"
@interface RCTabBarController ()

@end

@implementation RCTabBarController

-(instancetype)initRCTabBarController {
    if(self = [super init]) {
        self.viewControllers = [self tabBarviewControllers];
        self.tabBar.tintColor = RCColor(0.19, 0.63, 0.34, 1);
        self.tabBar.barStyle = UIBarStyleBlack;
        self.tabBar.translucent = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSLog(@"i am called view did load");
}
//tabbarcontroller是当程序退出的时候销毁
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"tab bar viewcontroller will disappear");
}

- (NSArray *)tabBarviewControllers {
    
    
    CircleViewController *circleViewController = [[CircleViewController alloc] init];
    circleViewController.tabBarItem.title = @"运动圈";
    circleViewController.tabBarItem.image = [UIImage imageNamed:@"main_tab_title_social_0"];
    circleViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"main_tab_title_social_1"];
    circleViewController.navigationItem.title = @"运动圈";
    UIViewController *circleNavigationController = [[RCNavigationController alloc]
                                                    initWithRootViewController:circleViewController];
    
    
    NewsViewController *newsViewController = [[NewsViewController alloc] init];
    newsViewController.tabBarItem.title = @"发现";
    newsViewController.tabBarItem.image = [UIImage imageNamed:@"main_tab_title_discover_0"];
    newsViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"main_tab_title_discover_1"];
    newsViewController.navigationItem.title = @"发现";
    UIViewController *newsNavigationController = [[RCNavigationController alloc]
                                                  initWithRootViewController:newsViewController];
    
    RunningViewController *runningViewController = [[RunningViewController alloc] init];
    
    runningViewController.tabBarItem.title = @"运动";
    runningViewController.tabBarItem.image = [UIImage imageNamed:@"main_tab_title_sport_0"];
    runningViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"main_tab_title_sport_1"];
    runningViewController.navigationItem.title = @"运动";
    UIViewController *runningNavigationController = [[RCNavigationController alloc]
                                                     initWithRootViewController:runningViewController];
    
    MessageViewController *messViewController = [[MessageViewController alloc] init];
    
    messViewController.tabBarItem.title = @"消息";
    messViewController.tabBarItem.image = [UIImage imageNamed:@"main_tab_title_message_0"];
    messViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"main_tab_title_message_1"];
    messViewController.navigationItem.title = @"消息";
    UIViewController *messNavigationController = [[RCNavigationController alloc]
                                                  initWithRootViewController:messViewController];
    
    MineViewController *mineViewController = [[MineViewController alloc] init];
    mineViewController.tabBarItem.title = @"我的";
    mineViewController.tabBarItem.image = [UIImage imageNamed:@"main_tab_title_personal_0"];
    mineViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"main_tab_title_personal_1"];
    mineViewController.navigationItem.title = @"我的";
    
    UIViewController *mineNavigationController = [[RCNavigationController alloc]
                                                  initWithRootViewController:mineViewController];
    NSArray *viewControllers = @[
                                 circleNavigationController,
                                 newsNavigationController,
                                 runningNavigationController,
                                 messNavigationController,
                                 mineNavigationController
                                 ];
    //获取根视图控制器，因为它是全局可用的
    // UIViewController *rootVC= [[[UIApplication sharedApplication]keyWindow] rootViewController];
    //从nib中初始化vc，把nib理解成未编译的XIB
    // UIViewController *vc = [[UIViewController alloc] initWithNibName:@"view1" bundle:nil];
    return viewControllers;
}
//-(instancetype)initWithControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes {
//    if(self = [self init]) {
//        self.arrviewControllers = viewControllers;
//        self.tabBarItemsAttributes = tabBarItemsAttributes;
//    }
//    return self;
//}
//-(instancetype)tabBarControllerWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes {
//    RCTabBarController *tabBarController = [self initWithControllers:viewControllers tabBarItemsAttributes:tabBarItemsAttributes];
//    return tabBarController;
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end