//
//  RCUINavigationController.m
//  RCSports
//
//  Created by liveidzong on 9/19/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "RCNavigationController.h"

@interface RCNavigationController ()

@end

@implementation RCNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end