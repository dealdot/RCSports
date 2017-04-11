//
//  AppDelegate.m
//  RCSports
//
//  Created by liveidzong on 9/19/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "RCAppDelegate.h"
#import "RCTabBarController.h"
/** baiduMap */
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#define BMKMapKey @"kpvfo4ULcC47szFQD2fQOovQsVMgGCUQ"

#import "WeiboSDK.h"

//dealdot.DYRuntime
#define kAppKey         @"848025612"
#define kRedirectURI    @"https://api.weibo.com/oauth2/default.html"

@interface RCAppDelegate () <WeiboSDKDelegate>
@property(nonatomic,strong) BMKMapManager *mapManager;
@end

@implementation RCAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:0.3];
    //create window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //self.window.backgroundColor = [UIColor redColor];
    
    //configuration of the main controller
    RCTabBarController *rcTabBarController = [[RCTabBarController alloc] initRCTabBarController];
    self.window.rootViewController = rcTabBarController;
  
    // 默认显示第2个tabbaritem
    rcTabBarController.selectedIndex = 2;
    //show the window
    [self.window makeKeyAndVisible];
    [self loadBMPManager];
    //NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    //NSLog(@"%@",docPath);
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    return YES;
}
-(void)loadBMPManager {
    self.mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [self.mapManager start:BMKMapKey generalDelegate:nil];
    if(!ret) {
        NSLog(@"baidu map manager start failed");
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return [WeiboSDK handleOpenURL:url delegate:self];//当前类RCAppDelegate作为weiboSDK代理，用来处理回调
}

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    
}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        if (response.statusCode == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成功" message:@"新浪微博分享成功" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *doAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:doAction];
            [self.window.rootViewController.presentedViewController presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"失败" message:@"新浪微博分享失败" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *doAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:doAction];
            [self.window.rootViewController.presentedViewController presentViewController:alert animated:YES completion:nil];
        }
    }
}
@end