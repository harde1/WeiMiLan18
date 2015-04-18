//
//  TRNewGoodsViewController.h
//  WeiMiLan
//
//  Created by Mac on 14-7-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRNewGoodsCell.h"


@interface TRNewGoodsViewController : UIViewController
@property(strong,nonatomic)WeChatNavigationBar *weChatNavigationBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
