//
//  CustomTabBarView.h
//  WeChatHelper
//
//  Created by Mac on 14-3-26.
//  Copyright (c) 2014年 bang yi bang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTabBarViewDelegate <NSObject>

-(void)buttonWasSelected:(NSInteger)index;


@end

@interface CustomTabBarView : UIView


@property (strong, nonatomic) IBOutlet UIButton *msgBt;
@property (strong, nonatomic) IBOutlet UIButton *rangBt;
@property (strong, nonatomic) IBOutlet UIButton *MeBt;
@property (assign,nonatomic) id<CustomTabBarViewDelegate> delegate;
@property (strong,nonatomic)UITapGestureRecognizer *tap;

-(void)selectItem:(NSInteger)num;
- (IBAction)changAction:(UIButton *)sender;
- (void)buttonWasSelected:(NSInteger)index;
-(void)initView;
@end
