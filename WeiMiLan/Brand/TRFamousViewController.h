//
//  TRFamousViewController.h
//  WeiMiLan
//
//  Created by cong on 14-7-26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeChatNavigationBar.h"
@interface TRFamousViewController : UIViewController

@property(strong,nonatomic)WeChatNavigationBar *weChatNavigationBar;
@property(nonatomic,copy)NSString * famousID;
@property(nonatomic,strong)NSMutableArray * famousArray;


@end
