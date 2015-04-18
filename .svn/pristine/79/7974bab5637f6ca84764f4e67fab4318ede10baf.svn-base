//
//  TRAppDelegate.h
//  WeiMiLan
//
//  Created by Mac on 14-7-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UdpClientSocket.h"
#import "WXApi.h"
#import "OLImage.h"
@interface TRAppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
    enum WXScene _scene;
}

@property (strong, nonatomic) UIWindow *window;
//UDP
@property(nonatomic,strong)AsyncUdpSocket* upSocket;
//集成socket
@property(nonatomic,strong)UdpClientSocket* udpClientSocket;

@property(nonatomic,copy)NSString * userName;
@property(nonatomic,copy)NSString * userID;
@property(nonatomic,strong)NSURL * uploadUrl;


@property(nonatomic,strong)OLImage * loadingImage;
@end
