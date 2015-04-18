//
//  PlayBillView.m
//  微米兰
//
//  Created by death on 14-7-1.
//  Copyright (c) 2014年 death. All rights reserved.
//

#import "PlayBillView.h"
@interface PlayBillView ()
@property(nonatomic,strong)UILabel *titleLabel;
@end
@implementation PlayBillView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40)];
        view.backgroundColor=[UIColor darkGrayColor];
        [view setAlpha:0.6];
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width-5, 40)];
       // self.titleLabel.text=@"这是一个label" ;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textColor=[UIColor whiteColor];
        [view addSubview:self.titleLabel];
      
        [self addSubview:view];
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

@end
