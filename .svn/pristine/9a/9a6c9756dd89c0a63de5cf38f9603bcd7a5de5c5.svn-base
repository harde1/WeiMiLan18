//
//  TRGoodsViewController.h
//  WeiMiLan
//
//  Created by Mac on 14-7-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeChatNavigationBar.h"
#import "WXApiObject.h"

@protocol goodsViewDelegate <NSObject>
- (void) changeScene:(NSInteger)scene;
- (void) sendTextContent;
- (void) sendImageContent:(UIImage *)image andImageDescription:(NSString*)description;
- (void) sendLinkContent;
- (void) sendMusicContent;
- (void) sendVideoContent;
- (void) sendAppContent;
- (void) sendNonGifContent;
- (void) sendGifContent:(NSArray *)array andFilePath:(NSString *)filePath;
- (void) sendFileContent;
@end


@interface TRGoodsViewController : UIViewController


@property(strong,nonatomic)WeChatNavigationBar *weChatNavigationBar;

@property(nonatomic,copy)NSString * productTypeId;

@property (nonatomic, assign) id<goodsViewDelegate,NSObject> delegate;

@end
