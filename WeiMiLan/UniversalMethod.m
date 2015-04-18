//
//  UniversalMethod.m
//  DazzleColourFonts
//
//  Created by 王颜龙 on 13-9-17.
//  Copyright (c) 2013年 longyan. All rights reserved.
//

#import "UniversalMethod.h"
#import "PublicDefault.h"
@implementation UniversalMethod

#pragma mark - btn的返回按钮

/**
 模态视图的时候返回通用的返回按钮
 @param Target : target
 @param sel    : 事件
 @returns      : 返回按钮
 */
+ (UIButton *)backBtnAddTarget:(id)Target action:(SEL)sel
{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(4, -1, 65, 45);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backN"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backS"] forState:UIControlStateSelected];
    [backBtn addTarget:Target action:sel forControlEvents:UIControlEventTouchUpInside];
    UILabel *Label = [[UILabel alloc]initWithFrame:backBtn.frame];
    
    if ([kLanguage isEqualToString:@"en"]) {
        Label.text = @"Back";
    }else{
        Label.text = @"返回";
    }
    
    Label.textAlignment = NSTextAlignmentCenter;
    Label.textColor = [UIColor whiteColor];
    Label.backgroundColor = [UIColor clearColor];
    Label.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [backBtn addSubview:Label];
    
    return backBtn;
}

#pragma mark - 开机闪屏动画效果
/**
 开机闪屏动画效果
 @param window : 设备window
 */
+ (void)showDefault:(UIWindow*)window
{
    //渐变效果
    UIImageView *splashScreen = [[UIImageView alloc] initWithFrame:window.bounds] ;
    if (iPhone5) {
        splashScreen.image = [UIImage imageNamed:@"Default-568h"];
    }else{
        splashScreen.image = [UIImage imageNamed:@"Default"];
    }
    
    [window addSubview:splashScreen];
    
    [UIView animateWithDuration:2.0 animations:^{
        CATransform3D transform = CATransform3DMakeScale(1.5, 1.5, 1.0);
        splashScreen.layer.transform = transform;
        splashScreen.alpha = 0.0;
    } completion:^(BOOL finished) {
        [splashScreen removeFromSuperview];
    }];
    
}

#pragma mark - 返回nav上的返回按钮
/**
 返回nav上的返回按钮
 @param Target : target
 @param sel    : 返回事件
 @returns      : 返回按钮
 */
+ (UIBarButtonItem *)backItemAddTarget:(id)Target action:(SEL)sel
{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(4, -1, 65, 45);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backN"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backS"] forState:UIControlStateSelected];
    [backBtn addTarget:Target action:sel forControlEvents:UIControlEventTouchUpInside];
    UILabel *Label = [[UILabel alloc]initWithFrame:backBtn.frame];
    
    if ([kLanguage isEqualToString:@"en"]) {
        Label.text = @"Back";
    }else{
        Label.text = @"返回";
    }
    
    Label.textAlignment = NSTextAlignmentCenter;
    Label.textColor = [UIColor whiteColor];
    Label.backgroundColor = [UIColor clearColor];
    Label.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [backBtn addSubview:Label];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    return backItem;
}

#pragma mark - 返回Documents目录路径
/**
 返回Documents目录路径
 @returns Documents目录路径
 */
+ (NSString *)backDocumentDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    return documentDirectory;
}

#pragma mark - 判断设备
/**
	判断设备
	@returns 返回一个字符串
    @param ViewController            : iphone5以下
    @param ViewController-iPhone5    : iphone5
    @param ViewController-iPad       : iPad
 */
+ (NSString *)dev
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height == 480.f)
        {
            return @"ViewController";
        }
        else
        {
            return @"ViewController-iPhone5";
        }
    }
    
    return @"ViewController-iPad";
}
@end
