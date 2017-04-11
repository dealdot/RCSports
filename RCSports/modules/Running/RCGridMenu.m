//
//  RCGridMenu.m
//  RCSports
//
//  Created by liveidzong on 11/9/16.
//  Copyright © 2016 SBM. All rights reserved.
//

#import "RCGridMenu.h"
#import <QuartzCore/QuartzCore.h>

#define kMAX_CONTENT_SCROLLVIEW_HEIGHT 400

@interface SGGridItem : UIButton
@property (nonatomic, weak) RCGridMenu *menu;
@end

@implementation SGGridItem


- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        //button包含titleLabel,imageView属性
        self.clipsToBounds = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:BaseMenuTextColor(self.menu.style) forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews
{    //这里对image,label进行了定位【绝对定位，直接设置rect】
    [super layoutSubviews];
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    CGRect imageRect = CGRectMake(width * 0.2, width * 0.2, width * 0.6, width * 0.6);
    self.imageView.frame = imageRect;
    
    float labelHeight = height - (imageRect.origin.y + imageRect.size.height);
    CGRect labelRect = CGRectMake(width * 0.05, imageRect.origin.y + imageRect.size.height, width * 0.9, labelHeight);
    self.titleLabel.frame = labelRect;
}

@end

@interface RCGridMenu()


@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) RCButton *cancelButton;//SGBaseMenu头文件进行了声明
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) NSArray *itemImages;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) void (^actionHandle)(NSInteger);
@end

@implementation RCGridMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemTitles = [NSArray array];
        _itemImages = [NSArray array];
        _items = [NSArray array];
        
        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _contentScrollView.contentSize = _contentScrollView.bounds.size;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = YES;
        _contentScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentScrollView];
        
        _cancelButton = [RCButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
        _cancelButton.clipsToBounds = YES;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_cancelButton setTitleColor:BaseMenuTextColor(self.style) forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(tapAction:)
                forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"取    消" forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
    }
    return self;
}

-(instancetype)initWithItemTitles:(NSArray *)itemTitles images:(NSArray *)images {
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        NSInteger count = MIN(itemTitles.count, images.count);
        _itemTitles = [itemTitles subarrayWithRange:NSMakeRange(0, count)];
        _itemImages = [images subarrayWithRange:NSMakeRange(0, count)];
        [self setupWithItemTitles:_itemTitles images:_itemImages];
    }
    return self;
}

- (void)setupWithItemTitles:(NSArray *)titles images:(NSArray *)images {
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++) {
        SGGridItem *item = [[SGGridItem alloc] initWithTitle:titles[i] image:images[i]];
        item.menu = self;
        item.tag = i;
        [item addTarget:self
                 action:@selector(tapAction:)
       forControlEvents:UIControlEventTouchUpInside];
        [items addObject:item];
        [_contentScrollView addSubview:item];
    }
    _items = [NSArray arrayWithArray:items];
}

//setter
- (void)setStyle:(RCActionViewStyle)style {
    // _style = style;
    [super setStyle:style];
    self.backgroundColor = BaseMenuBackgroundColor(style);
    [self.cancelButton setTitleColor:BaseMenuActionTextColor(style) forState:UIControlStateNormal];
    for (SGGridItem *item in self.items) {
        [item setTitleColor:BaseMenuTextColor(style) forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutContentScrollView];
    self.contentScrollView.frame = (CGRect){CGPointZero, self.contentScrollView.bounds.size};
    
    self.cancelButton.frame = CGRectMake(0, self.contentScrollView.bounds.size.height, self.bounds.size.width, 44);
    
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, self.contentScrollView.bounds.size.height + self.cancelButton.bounds.size.height)};
//    self.layer.borderColor = [[UIColor yellowColor] CGColor];
//    self.layer.borderWidth = 1.0f;
}

- (void)layoutContentScrollView
{
    UIEdgeInsets margin = UIEdgeInsetsMake(0, 10, 15, 10);
    CGSize itemSize = CGSizeMake((self.bounds.size.width - margin.left - margin.right) / 4, 85);
    
    NSInteger itemCount = self.items.count;
    NSInteger rowCount = ((itemCount-1) / 4) + 1;
    self.contentScrollView.contentSize = CGSizeMake(self.bounds.size.width, rowCount * itemSize.height + margin.top + margin.bottom);
    //self.contentScrollView.layer.borderColor = [[UIColor purpleColor] CGColor];
    //self.contentScrollView.layer.borderWidth = 1.0f;
    for (int i = 0; i < itemCount; i++) {
        SGGridItem *item = self.items[i];
        int row = i / 4;
        int column = i % 4;
        CGPoint p = CGPointMake(margin.left + column * itemSize.width, margin.top + row * itemSize.height);
        item.frame = (CGRect){p, itemSize};
        [item layoutIfNeeded];
    }
    
    if (self.contentScrollView.contentSize.height > kMAX_CONTENT_SCROLLVIEW_HEIGHT) {
        self.contentScrollView.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, kMAX_CONTENT_SCROLLVIEW_HEIGHT)};
    }else{
        self.contentScrollView.bounds = (CGRect){CGPointZero, self.contentScrollView.contentSize};
    }
}


- (void)triggerSelectedAction:(void (^)(NSInteger))actionHandle
{
    self.actionHandle = actionHandle;//把block传递过来，在某处 self.actionHandle里进行调用[第186行，第192行]
    //actionHandle(5);//调用
}

- (void)tapAction:(id)sender {
    if (self.actionHandle) {
        
        if ([sender isEqual:self.cancelButton]) {
            double delayInSeconds = 0.15;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.actionHandle(0);
            });
        }else{
            double delayInSeconds = 0.15;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.actionHandle([sender tag] + 1);
            });
        }
    }
}
@end