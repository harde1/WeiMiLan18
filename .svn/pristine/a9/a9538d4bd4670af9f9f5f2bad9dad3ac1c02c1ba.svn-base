//
//  UniversalMethod.h
//  DazzleColourFonts
//
//  Created by 王颜龙 on 13-9-17.
//  Copyright (c) 2013年 longyan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UniversalMethod : NSObject

#pragma mark - 通用方法

#pragma mark - btn的返回按钮

/**
 模态视图的时候返回通用的返回按钮
 @param Target : target
 @param sel    : 事件
 @returns      : 返回按钮
 */
+ (UIButton *)backBtnAddTarget:(id)Target action:(SEL)sel;

#pragma mark - 开机闪屏动画效果

/**
 开机闪屏动画效果
 @param window : 设备window
 */
+ (void)showDefault:(UIWindow*)window;

#pragma mark - 返回nav上的返回按钮

/**
 返回nav上的返回按钮
 @param Target : target
 @param sel    : 返回事件
 @returns      : 返回按钮
 */
+ (UIBarButtonItem *)backItemAddTarget:(id)Target action:(SEL)sel;

#pragma mark - 返回Documents目录路径
/**
 返回Documents目录路径
 @returns Documents目录路径
 */
+ (NSString *)backDocumentDirectoryPath;

#pragma mark - 判断设备
/**
 判断设备
 @returns 返回一个字符串
 @param ViewController            : iphone5以下
 @param ViewController-iPhone5    : iphone5
 @param ViewController-iPad       : iPad
 */
+ (NSString *)dev;

@end
