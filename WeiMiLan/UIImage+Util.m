//
//  UIImage+Util.m
//  KidsEduCircle
//
//  Created by cong on 14-6-20.
//  Copyright (c) 2014年 Zhang Kai Yu. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)
//剪图片
+(UIImage*)cutToSize:(CGRect)rect for:(UIImage *)image{
    
    CGImageRef cgimg = CGImageCreateWithImageInRect([image CGImage], rect);
    image = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);//用完一定要释放，否则内存泄露
    return image;
}
//剪完后再缩小图片
+(UIImage*)cutToSize:(CGRect)rect for:(UIImage *)image scaleToSize:(CGSize)size{
    
    CGImageRef cgimg = CGImageCreateWithImageInRect([image CGImage], rect);
    
    image = [UIImage imageWithCGImage:cgimg];
    image = [self scaleToSize:size for:image];
    CGImageRelease(cgimg);//用完一定要释放，否则内存泄露
    return image;
}
//剪完后再缩小图片
+(UIImage*)cutToSize:(CGRect)rect for:(UIImage *)image scale:(CGFloat)scale{
    
    CGImageRef cgimg = CGImageCreateWithImageInRect([image CGImage], rect);
    
    image = [UIImage imageWithCGImage:cgimg];
    image = [self scaleToHalf:image inScale:scale];
    CGImageRelease(cgimg);//用完一定要释放，否则内存泄露
    return image;
}
+ (UIImage*)scaleToSize:(CGSize)size for:(UIImage*) image
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    //    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage*)scaleToHalf:(UIImage*) image
{
    CGSize size = image.size;
    size.width = size.width / 2;
    size.height = size.height / 2;
    
    return [self scaleToSize:size for:image];
    
}
+ (UIImage*)scaleToHalf:(UIImage*) image inScale:(CGFloat)scale
{
    CGSize size = image.size;
    size.width = size.width * scale;
    size.height = size.height * scale;
    
    return [self scaleToSize:size for:image];
    
}
/**
 *  ios UIImage 图片处理 灰度 反色 深棕色
 *
 *  @param anImage 处理的图片
 *  @param type    处理的模式
 *  @param rgbArr  RGB数组，存字符串数字
 *
 *  @return 新图片
 */
+(UIImage*) grayscale:(UIImage*)anImage type:(char)type RGBStringArray:(NSArray *)rgbArr{
    CGImageRef  imageRef;
    imageRef = anImage.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // ピクセルを構成するRGB各要素が何ビットで構成されている，像素的RPG各要素是什么位组成。
    size_t                  bitsPerComponent;
    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    // ピクセル全体は何ビットで構成されているか,像素全体是什么位组成的吗?
    size_t                  bitsPerPixel;
    bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    // 画像の横1ライン分のデータが、何バイトで構成されているか,画面的横一期扩建工程的数据,但要组成的吗?
    size_t                  bytesPerRow;
    bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    // 画像の色空間,画像的颜色空间
    CGColorSpaceRef         colorSpace;
    colorSpace = CGImageGetColorSpace(imageRef);
    
    // 画像のBitmap情報,图像的Bitmap信息
    CGBitmapInfo            bitmapInfo;
    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    // 画像がピクセル間の補完をしているか,画像像素之间的完善问题。
    bool                    shouldInterpolate;
    shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    // 表示装置によって補正をしているか,首先,根据显象装置吗?
    CGColorRenderingIntent  intent;
    intent = CGImageGetRenderingIntent(imageRef);
    
    // 画像のデータプロバイダを取得する,取得データプロバイダ图像的
    CGDataProviderRef   dataProvider;
    dataProvider = CGImageGetDataProvider(imageRef);
    
    // データプロバイダから画像のbitmap生データ取得,从画面上的问データプロバイダ获取数据
    CFDataRef   data;
    UInt8*      buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    
    // 1ピクセルずつ画像を処理,各像素图像处理1
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8*  tmp;
            tmp = buffer + y * bytesPerRow + x * 4; // RGBAの4つ値をもっているので、1ピクセルごとに*4してずらす,RGBA等4个值的,所以每个像素挪动了* 4
            
            // RGB値を取得
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            
            switch (type) {
                case 1://モノクロ
                    // 輝度計算，亮度计算
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                    
                case 2://セピア
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                    
                case 3://色反転，颜色逆转
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                case 4://自定义，深蓝色
                    *(tmp + 0) = 46;
                    *(tmp + 1) = 168;
                    *(tmp + 2) = 215;
                    
                    break;
                case 5://自定义，深蓝色
                    
                    *(tmp + 0) = 66;
                    *(tmp + 1) = 181;
                    *(tmp + 2) = 240;
                    
                    break;
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
            
        }
    }
    
    // 効果を与えたデータ生成，生成数据的效果。
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    // 効果を与えたデータプロバイダを生成，效果的データプロバイダ生成
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    // 画像を生成
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                    colorSpace, bitmapInfo, effectedDataProvider,
                                    NULL, shouldInterpolate, intent);
    effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    // データの解放
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
}
//多图合成一张横着的图
+(UIImage *)addImage:(NSArray*)imageArr andVOrH:(int)vOrH{
    CGSize size;
    CGFloat i_width=0;
    CGFloat i_Height=0;
    NSMutableArray* x_wArray = [@[]mutableCopy];
    
    if (vOrH==0) {
        //计算出绘图的大小
        for (int n=0; n<imageArr.count; n++) {
            UIImage * image = imageArr[n];
            [x_wArray addObject:[NSNumber numberWithFloat:i_width]];
            
            i_width = i_width + image.size.width;
            i_Height = i_Height>image.size.height?i_Height:image.size.height;
            
        }
        
        //画布大小
        size = CGSizeMake(i_width, i_Height);
        UIGraphicsBeginImageContext(size);
        //绘制
        for (int n=0; n<imageArr.count; n++) {
            UIImage * image = imageArr[n];
            [image drawInRect:CGRectMake([x_wArray[n] floatValue], i_Height/2.-image.size.height/2., image.size.width, image.size.height)];
        }
        
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultingImage;
    }
    if (vOrH==1) {
        //计算出绘图的大小
        for (int n=0; n<imageArr.count; n++) {
            UIImage * image = imageArr[n];
            [x_wArray addObject:[NSNumber numberWithFloat:i_Height]];
//            
//            i_width = i_width + image.size.width;
//            i_Height = i_Height>image.size.height?i_Height:image.size.height;
            
            i_Height = i_Height + image.size.height;
            i_width = i_width>image.size.width?i_width:image.size.width;
            
        }
        
        //画布大小
        size = CGSizeMake(i_width, i_Height);
        UIGraphicsBeginImageContext(size);
        //绘制
        for (int n=0; n<imageArr.count; n++) {
            UIImage * image = imageArr[n];
            [image drawInRect:CGRectMake(i_width/2.-image.size.width/2., [x_wArray[n] floatValue],image.size.width, image.size.height)];
        }
        
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultingImage;
    
    }
    return nil;
}

//多图合成
- (UIImage *)addImage:(UIImage *)image1 withImage:(UIImage *)image2 rect1:(CGRect)rect1 rect2:(CGRect)rect2


{
    CGSize size = CGSizeMake(rect1.size.width+rect2.size.width, rect1.size.height);
    
    UIGraphicsBeginImageContext(size);
    
    [image1 drawInRect:rect1];
    [image2 drawInRect:rect2];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

//gif图合成

//gif的制作

//获取源数据image

+(NSString*)getGif:(NSArray*)array{
    
//    CGFloat duration;
    
    NSMutableArray *imgs = [NSMutableArray arrayWithArray:array];

    NSLog(@"多少张图片合成：%@",imgs);
    //图像目标

    CGImageDestinationRef destination;

    //创建输出路径
    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentStr = [document objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *textDirectory = [documentStr stringByAppendingPathComponent:@"gif"];
    [fileManager createDirectoryAtPath:textDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [textDirectory stringByAppendingPathComponent:@"test101.gif"];


    NSLog(@"%@",path);

    //创建CFURL对象
    /*
     CFURLCreateWithFileSystemPath(CFAllocatorRef allocator, CFStringRef filePath, CFURLPathStyle pathStyle, Boolean isDirectory)
     
     allocator : 分配器,通常使用kCFAllocatorDefault
     filePath : 路径
     pathStyle : 路径风格,我们就填写kCFURLPOSIXPathStyle 更多请打问号自己进去帮助看
     isDirectory : 一个布尔值,用于指定是否filePath被当作一个目录路径解决时相对路径组件
     */
    CFURLRef url = CFURLCreateWithFileSystemPath (
                                                  kCFAllocatorDefault,
                                                  (CFStringRef)path,
                                                  kCFURLPOSIXPathStyle,
                                                  false);

    //通过一个url返回图像目标
    destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imgs.count, NULL);

    //设置gif的信息,播放间隔时间,基本数据,和delay时间
    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1], (NSString *)kCGImagePropertyGIFDelayTime, nil]
                                     forKey:(NSString *)kCGImagePropertyGIFDictionary];

    //设置gif信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:array.count];

    [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];

    [dict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];

    [dict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];

    [dict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:dict
                                                              forKey:(NSString *)kCGImagePropertyGIFDictionary];
    //合成gif
    for (UIImage* dImg in imgs)
    {
        CGImageDestinationAddImage(destination, dImg.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifProperties);
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
    
    return path;
}

////1、透明偏移
//NSUInteger alphaOffset(NSUInteger x, NSUInteger y, NSUInteger w){return y * w * 4 + x * 4 + 0;}
//
////2、得到png图片字符数组值
//unsigned char *getBitmapFromImage (UIImage *image)
//{
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    if (colorSpace == NULL)
//    {
//        fprintf(stderr, "Error allocating color space\n");
//        return NULL;
//    }
//
//    CGSize size = image.size;
//    // void *bitmapData = malloc(size.width * size.height * 4);
//    unsigned char *bitmapData = calloc(size.width * size.height * 4, 1); // Courtesy of Dirk. Thanks!
//    if (bitmapData == NULL)
//    {
//        fprintf (stderr, "Error: Memory not allocated!");
//        CGColorSpaceRelease(colorSpace);
//        return NULL;
//    }
//
//    CGContextRef context = CGBitmapContextCreate (bitmapData, size.width, size.height, 8, size.width * 4, colorSpace, kCGImageAlphaPremultipliedFirst);
//    CGColorSpaceRelease(colorSpace );
//    if (context == NULL)
//    {
//        fprintf (stderr, "Error: Context not created!");
//        free (bitmapData);
//        return NULL;
//    }
//
//    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
//    CGContextDrawImage(context, rect, image.CGImage);
//    unsigned char *data = CGBitmapContextGetData(context);
//    CGContextRelease(context);
//
//    return data;
//}

// 测试是否点击到png的不透明部分
//- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    if (!CGRectContainsPoint(self.bounds, point)) return NO;
//    return (bytes[alphaOffset(point.x, point.y, self.image.size.width)] > 85);
//}

@end
