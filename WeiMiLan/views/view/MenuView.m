//
//  MenuView.m
//  微米兰
//
//  Created by death on 14-6-30.
//  Copyright (c) 2014年 death. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

-(void)layoutMenuImage:(NSString *)image andTitle:(NSString *)title{
   UIImageView* menu=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 40)];
    menu.image=[UIImage imageNamed:image];
   
    UILabel* textLabel=[[UILabel alloc]initWithFrame:CGRectMake(35, 50, 50, 20)];
    textLabel.text=title;
    textLabel.font=[UIFont systemFontOfSize:12];
    textLabel.textColor=[UIColor whiteColor];
    textLabel.backgroundColor=[UIColor clearColor];
    
    [self addSubview:menu];
    [self addSubview:textLabel];
}

@end
