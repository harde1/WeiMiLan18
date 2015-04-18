//
//  PublicDefault.h
//  FontManager
//
//  Created by 王颜龙 on 13-9-9.
//  Copyright (c) 2013年 longyan. All rights reserved.
//

#ifndef FontManager_PublicDefault_h
#define FontManager_PublicDefault_h

//颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

//读取PList文件
#define readPList(Name) [[NSBundle mainBundle]pathForResource:Name ofType:@"plist"]

//添加NSNotificationCenter
#define addNOT(Observer1,selector1,name1,object1) [[NSNotificationCenter defaultCenter]addObserver:Observer1 selector:selector1 name:name1 object:object1]
//删除NSNotificationCenter
#define RemoveNOT(Observer1,name1,object1) [[NSNotificationCenter defaultCenter]removeObserver:Observer1 name:name1 object:object1]
//发送NSNotificationCenter post请求
#define PostNOT(Name1,object1,userInfo1) [[NSNotificationCenter defaultCenter]postNotificationName:Name1 object:object1 userInfo:userInfo1]

//读取NSUserDefaults
#define GetUD(key1) [[NSUserDefaults standardUserDefaults]objectForKey:key1]
#define SetUD(Object1,key1) [[NSUserDefaults standardUserDefaults]setObject:Object1 forKey:key1]

//是否为iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//读取NSBundle文件
#define readNB(name,type) [[NSBundle mainBundle]pathForResource:name ofType:type]

//等待框
#define WAITVIEW [UIApplication sharedApplication].networkActivityIndicatorVisible

//判断设备型号
#define iOSValue [[[UIDevice currentDevice] systemVersion] floatValue]

//判断屏幕大小
#define kScreen [UIScreen mainScreen].scale

//屏幕位置长宽
#define kVX self.view.frame.origin.x
#define kVY self.view.frame.origin.y
#define kVW self.view.frame.size.width
#define kVH self.view.frame.size.height

//判断语言版本
#define kLanguage [[NSLocale preferredLanguages]objectAtIndex:0]

//取消NSLog
#ifndef __OPTIMIZE__
# define NSLog(...) NSLog(__VA_ARGS__)
//# define NSLog(...) {}
#else
# define NSLog(...) NSLog(__VA_ARGS__)
//# define NSLog(...) {}
#endif

#endif
