//
//  TRListTableViewController.h
//  WeiMiLan
//
//  Created by cong on 14-7-20.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeChatNavigationBar.h"

typedef NS_ENUM(NSInteger, WhichViewControllerUsage)
{
    myCollVC,
    sharedVC,
    collectedVC,
    downVC
};
@interface TRListTableViewController : UIViewController

@property(nonatomic)WhichViewControllerUsage usage;
@property(strong,nonatomic)WeChatNavigationBar *weChatNavigationBar;

@end
