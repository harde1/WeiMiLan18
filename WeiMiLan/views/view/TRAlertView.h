//
//  TRAlertView.h
//  WeiMiLan
//
//  Created by cong on 14-7-29.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TRAlertViewDelegate <NSObject>
@optional
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
@interface TRAlertView : UIAlertView
//{
//    id  TRdelegate;
//    UIImage *backgroundImage;
//    UIImage *contentImage;
//    NSMutableArray *_buttonArrays;
//    
//}
@property(nonatomic, strong) NSMutableArray *buttonArrays;
@property(readwrite, strong) UIImage *backgroundImage;
@property(readwrite, strong) UIImage *contentImage;
@property(nonatomic, assign) id<TRAlertViewDelegate> TRdelegate;



- (id)initWithImage:(UIImage *)image contentImage:(UIImage *)content;
-(void) addButtonWithUIButton:(UIButton *) btn;
@end
