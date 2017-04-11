//
//  RCActionView.m
//  RCSports
//
//  Created by liveidzong on 11/9/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "RCActionView.h"
#import "RCGridMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "MapViewController.h"
#import "MineViewController.h"
#import "RCTabBarController.h"
//新浪weibo
#import "WeiboSDK.h"

@interface RCActionView() <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, strong) CAAnimation *showMenuAnimation;
@property (nonatomic, strong) CAAnimation *dismissMenuAnimation;
@property (nonatomic, strong) CAAnimation *dimingAnimation;
@property (nonatomic, strong) CAAnimation *lightingAnimation;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation RCActionView
+ (RCActionView *)sharedActionView {
    static RCActionView *actionView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect rect = [[UIScreen mainScreen] bounds];//整个可见视图范围内
        actionView = [[RCActionView alloc] initWithFrame:rect];
    });
    
    return actionView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    //self.layer.borderColor=[[UIColor yellowColor] CGColor];
    //self.layer.borderWidth = 1.0f;
    //self.alpha = 0.6f;
    if (self) {
        _menus = [NSMutableArray array];
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _tapGesture.delegate = self;
        [self addGestureRecognizer:_tapGesture];
    }
    // int(^blockDemo)(int,int) = ^(int a, int b){return a+b;};
    // int sum = blockDemo(5,6);
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)tapGesture {
    CGPoint touchPoint = [tapGesture locationInView:self];
    RCBaseMenu *menu = self.menus.lastObject;
    if (!CGRectContainsPoint(menu.frame, touchPoint)) {
        [[RCActionView sharedActionView] dismissMenu:menu Animated:YES];
        [self.menus removeObject:menu];
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.tapGesture]) {
        CGPoint p = [gestureRecognizer locationInView:self];
        RCBaseMenu *topMenu = self.menus.lastObject;
        if (CGRectContainsPoint(topMenu.frame, p)) {
            return NO;
        }
    }
    return YES;
}


- (void)setMenu:(UIView *)menu animation:(BOOL)animated {
    if (![self superview]) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        //self.backgroundColor = [UIColor redColor];
        [window addSubview:self];
        //NSLog(@"%@",[self superview]);//UIWindow
    }
    RCBaseMenu *topMenu = (RCBaseMenu *)menu;//多态，父类引用指向子类对象 RCGridMenu
    //NSLog(@"%@",topMenu);//SGGridMenu
    [self.menus makeObjectsPerformSelector:@selector(removeFromSuperview)];//all objects react the action
    [self.menus addObject:topMenu];
    
    topMenu.style = self.style;
    [self addSubview:topMenu];
    [topMenu layoutIfNeeded];
    topMenu.frame = (CGRect){CGPointMake(0, self.bounds.size.height - topMenu.bounds.size.height), topMenu.bounds.size};
    
    if (animated && self.menus.count == 1) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [self.layer addAnimation:self.dimingAnimation forKey:@"diming"];
        
        [topMenu.layer addAnimation:self.showMenuAnimation forKey:@"showMenu"];
        [CATransaction commit];
    }
}

- (void)dismissMenu:(RCBaseMenu *)menu Animated:(BOOL)animated
{
    if ([self superview]) {
        [self.menus removeObject:menu];
        if (animated && self.menus.count == 0) {
            //NSLog(@"super view exists");
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.2];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            [CATransaction setCompletionBlock:^{
                [self removeFromSuperview];
                [menu removeFromSuperview];
            }];
            [self.layer addAnimation:self.lightingAnimation forKey:@"lighting"];
            [menu.layer addAnimation:self.dismissMenuAnimation forKey:@"dismissMenu"];
            [CATransaction commit];
        }else{
            [menu removeFromSuperview];
            
            RCBaseMenu *topMenu = self.menus.lastObject;
          //  topMenu.style = self.style;
            [self addSubview:topMenu];
            [topMenu layoutIfNeeded];
            topMenu.frame = (CGRect){CGPointMake(0, self.bounds.size.height - topMenu.bounds.size.height), topMenu.bounds.size};
        }
    }
}


- (CAAnimation *)dimingAnimation
{
    if (_dimingAnimation == nil) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _dimingAnimation = opacityAnimation;
    }
    return _dimingAnimation;
}

- (CAAnimation *)lightingAnimation
{
    if (_lightingAnimation == nil ) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _lightingAnimation = opacityAnimation;
    }
    return _lightingAnimation;
}

- (CAAnimation *)showMenuAnimation
{
    if (_showMenuAnimation == nil) {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1 / -500.0f;
        CATransform3D from = CATransform3DRotate(t, -30.0f * M_PI / 180.0f, 1, 0, 0);
        CATransform3D to = CATransform3DIdentity;
        [rotateAnimation setFromValue:[NSValue valueWithCATransform3D:from]];
        [rotateAnimation setToValue:[NSValue valueWithCATransform3D:to]];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scaleAnimation setFromValue:@0.9];
        [scaleAnimation setToValue:@1.0];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:50.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:0.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@0.0];
        [opacityAnimation setToValue:@1.0];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:@[rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _showMenuAnimation = group;
    }
    return _showMenuAnimation;
}


- (CAAnimation *)dismissMenuAnimation {
    if (_dismissMenuAnimation == nil) {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1 / -500.0f;
        CATransform3D from = CATransform3DIdentity;
        CATransform3D to = CATransform3DRotate(t, -30.0f * M_PI / 180.0f, 1, 0, 0);
        [rotateAnimation setFromValue:[NSValue valueWithCATransform3D:from]];
        [rotateAnimation setToValue:[NSValue valueWithCATransform3D:to]];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scaleAnimation setFromValue:@1.0];
        [scaleAnimation setToValue:@0.9];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:50.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@1.0];
        [opacityAnimation setToValue:@0.0];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:@[rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _dismissMenuAnimation = group;
    }
    return _dismissMenuAnimation;
}

-(void)showGridMenuWithItemTitles:(NSArray *)itemTitles images:(NSArray *)images {
    RCGridMenu *menu = [[RCGridMenu alloc] initWithItemTitles:itemTitles images:images];
    [menu triggerSelectedAction:^(NSInteger index) {//这里的block是当作参数传递使用，而非回调,类比理解为{}中的内容作为参数传递
        switch (index) {
                //cancelButton
            case 0:
                [[RCActionView sharedActionView] dismissMenu:menu Animated:YES];
                break;
            case 1:
                //sina weibo
                [[RCActionView sharedActionView] dismissMenu:menu Animated:YES];
                [self shareToWeibo];
                break;
            default:
                [[RCActionView sharedActionView] dismissMenu:menu Animated:YES];
                break;
        }
        
    }];

    [[RCActionView sharedActionView] setMenu:menu animation:YES];
}
//sina weibo
-(void)shareToWeibo {
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
    request.userInfo = nil;
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare {
    
    RCTabBarController *tabBarController = (RCTabBarController *)self.window.rootViewController;
    UINavigationController *navVC = tabBarController.viewControllers[4];
    MineViewController *mineVC = navVC.viewControllers[0];
    MapViewController *mapVC = mineVC.mvc;
    UIImage *shareImage = [mapVC takeSnapshots];
    
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"于%@，%@到%@ ,跑步%@公里，用时%@。",mineVC.sharingrecordDate,mineVC.sharingstartTime,mineVC.sharingendTime,mineVC.sharingtotalDistance,mineVC.sharingtimeSpend];
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(shareImage, 0.2f);
    message.imageObject = imageObject;
    return message;
}
//weixin

@end
