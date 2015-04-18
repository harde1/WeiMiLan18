//
//  WeChatNavigationBar.m
//  WeChatHelper
//
//  Created by bang yi bang on 14-3-26.
//  Copyright (c) 2014年 bang yi bang. All rights reserved.
//

#import "WeChatNavigationBar.h"
#import "TRTabBarViewController.h"
#import "TRSearchView.h"
@implementation WeChatNavigationBar


-(void)removeSear:(UIButton *)btn{
    [btn.superview removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, kIsIOS7 ? 0 : 0, kUI_SCREEN_WIDTH, 66)];
    if (self) {
        //[self setImage:kImgName(@"topNav2", @"png")];
        self.image=[UIImage imageNamed:@"上导航背景"];
        self.backgroundColor=[UIColor blackColor];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setFrame:CGRectMake(10, 27, 50, 33)];
        [_leftButton setBackgroundColor:[UIColor clearColor]];
        [_leftButton setImage:[UIImage imageNamed:@"logo1"] forState:UIControlStateNormal];
        [self addSubview:_leftButton];
        
//        [_leftButton addTarget:self action:@selector(gotoMainPage) forControlEvents:UIControlEventTouchUpInside];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:CGRectMake(kUI_SCREEN_WIDTH-54, 33, 20, 20)];
        [_rightButton setBackgroundColor:[UIColor clearColor]];
        [_rightButton setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
        
//        [_rightButton addTarget:self action:@selector(showSearch) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
        
        
        _rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton2 setFrame:CGRectMake(kUI_SCREEN_WIDTH-54-30-10, 27, 30, 30)];
        [_rightButton2 setBackgroundColor:[UIColor clearColor]];
        [_rightButton2 setImage:[UIImage imageNamed:@"down下载按钮"] forState:UIControlStateNormal];
        [_rightButton2 setImage:[UIImage imageNamed:@"down下载按键按下"] forState:UIControlStateHighlighted];
        
        _rightButton2.hidden = YES;
        [self addSubview:_rightButton2];
        
        _rightButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton3 setFrame:CGRectMake(kUI_SCREEN_WIDTH-54-30-10-10-30, 27, 30, 30)];
        [_rightButton3 setBackgroundColor:[UIColor clearColor]];
        [_rightButton3 setImage:[UIImage imageNamed:@"back返回按钮"] forState:UIControlStateNormal];
        [_rightButton3 setImage:[UIImage imageNamed:@"back返回按键按下"] forState:UIControlStateHighlighted];
        
        _rightButton3.hidden = YES;
        [self addSubview:_rightButton3];
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 20, 212, 44)];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
    }
    return self;
}

@end
