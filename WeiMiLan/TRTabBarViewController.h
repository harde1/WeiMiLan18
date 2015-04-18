//
//  TRTabBarViewController.h
//  WeiMiLan
//
//  Created by Mac on 14-7-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarView.h"

@protocol TRTabBarViewControllerDelegate <NSObject>

- (void)menuViewDidSelecte:(NSInteger) index;

@end

@interface TRTabBarViewController : UITabBarController<CustomTabBarViewDelegate,UITabBarControllerDelegate>
@property(strong,nonatomic)CustomTabBarView * customTabBarView;
@property(strong,nonatomic)UIView *menuView;
@property (assign,nonatomic) id<TRTabBarViewControllerDelegate>delegate;
@end
