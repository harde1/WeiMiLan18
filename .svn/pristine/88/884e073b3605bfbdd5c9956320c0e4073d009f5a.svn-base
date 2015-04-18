//
//  TRSendViewController.h
//  WeiMiLan
//
//  Created by Mac on 14-7-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <MobileCoreServices/UTCoreTypes.h>
#import "CTAssetsPickerController.h"
#import "WeChatNavigationBar.h"
@interface TRSendViewController : UIViewController<UINavigationControllerDelegate,CTAssetsPickerControllerDelegate>

- (IBAction)chooseImages:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@property (strong, nonatomic) IBOutlet UITextField *DirectoryTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property(strong,nonatomic)WeChatNavigationBar *weChatNavigationBar;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

- (IBAction)sendAction:(UIButton *)sender;

- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end
