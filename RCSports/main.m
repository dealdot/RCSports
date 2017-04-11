//
//  main.m
//  RCSports
//
//  Created by liveidzong on 9/19/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCAppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        //这里会创建Run Loop, 维护@autoreleasepool释放池
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([RCAppDelegate class]));
    }
}