//
//  DemoViewController.h
//  SlideImageView
//
//  Created by rd on 12-12-17.
//  Copyright (c) 2012年 LXJ_成都. All rights reserved.
//

#import <UIKit/UIKit.h>



#import "WeChatNavigationBar.h"

@protocol albumDelegate <NSObject>

-(void)delImageFromArray:(NSArray *)array;

@end
@interface KYAlbumViewController : UIViewController<UIScrollViewDelegate>
@property(strong,nonatomic)WeChatNavigationBar *weChatNavigationBar;
@property(nonatomic,strong)NSArray * album;

@property(nonatomic,assign)BOOL isFromGood;

@property(nonatomic,assign)id<albumDelegate> delegate;
@end
