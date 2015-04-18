//
//  TRBar.m
//  WeiMiLan
//
//  Created by Mac on 14-7-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRBar.h"

@implementation TRBar



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, kIsIOS7 ? 0 : 0, kUI_SCREEN_WIDTH, 66)];
    if (self) {
        //[self setImage:kImgName(@"topNav2", @"png")];
        self.image=[UIImage imageNamed:@"上导航背景"];
        self.backgroundColor=[UIColor blackColor];
        [self setUserInteractionEnabled:YES];
      //  [self setBackgroundColor:[UIColor clearColor]];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setFrame:CGRectMake(10, 27, 50, 33)];
        [_leftButton setBackgroundColor:[UIColor clearColor]];

        [self addSubview:_leftButton];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:CGRectMake(kUI_SCREEN_WIDTH-54, 27, 50, 30)];
        [_rightButton setBackgroundColor:[UIColor clearColor]];

        [self addSubview:_rightButton];
        
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
