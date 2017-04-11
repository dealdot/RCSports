//
//  RCBaseMenu.m
//  RCSports
//
//  Created by liveidzong on 11/9/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "RCBaseMenu.h"

@implementation RCButton

//-(instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if(self) {
//        self.backgroundColor = [UIColor lightGrayColor];
//    }
//    return self;
//}
- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        //self.backgroundColor = [UIColor lightGrayColor];
    }else{
        double delayInSeconds = 0.2; //seconds
        //self.backgroundColor = [UIColor lightGrayColor];
        //NSED_PER_SEC 把秒转化为纳秒,表示从现在开始0.2秒之内 so something
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.backgroundColor = [UIColor clearColor];
        });
    }
}

@end


@implementation RCBaseMenu

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.style = RCActionViewStyleLight;
    }
    return self;
}
@end