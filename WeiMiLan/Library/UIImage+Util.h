//
//  UIImage+Util.h
//  KidsEduCircle
//
//  Created by cong on 14-6-20.
//  Copyright (c) 2014年 Zhang Kai Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)
+(UIImage*)cutToSize:(CGRect)rect for:(UIImage *)image;
+(UIImage*)cutToSize:(CGRect)rect for:(UIImage *)image scaleToSize:(CGSize)size;
+(UIImage*)cutToSize:(CGRect)rect for:(UIImage *)image scale:(CGFloat)scale;
+ (UIImage*)scaleToSize:(CGSize)size for:(UIImage*) image;
+ (UIImage*)scaleToHalf:(UIImage*) image;
+(UIImage*) grayscale:(UIImage*)anImage type:(char)type RGBStringArray:(NSArray *)rgbArr;
@end
