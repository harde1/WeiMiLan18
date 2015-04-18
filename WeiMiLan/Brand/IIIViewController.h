//
//  IIIViewController.h
//  IIILocalizedIndexDemo
//
//  Created by sehone on 1/23/13.
//  Copyright (c) 2013 sehone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IIIViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(strong,nonatomic)WeChatNavigationBar *weChatNavigationBar;
@property(strong,nonatomic)NSString *titleString;
@end
