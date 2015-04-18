//
//  TRMemuViewController.h
//  WeiMiLan
//
//  Created by Mac on 14-7-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarView.h"
#import "WeChatNavigationBar.h"
#import "TRTabBarViewController.h"
#import "TRBar.h"


@interface TRMemuViewController : UIViewController<CustomTabBarViewDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TRTabBarViewControllerDelegate>
@property(strong,nonatomic)WeChatNavigationBar *weChatNavigationBar;
@property(strong,nonatomic)TRTabBarViewController *tabBar;
@property(strong,nonatomic)TRBar *chooseView;
@property(strong,nonatomic)TRBar *actionView;
@property(retain,nonatomic)UIScrollView *Bigscroll;
@end
