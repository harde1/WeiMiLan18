//
//  TRAppDelegate.m
//  WeiMiLan
//
//  Created by Mac on 14-7-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRAppDelegate.h"
#import "UIImage+Util.h"
@implementation TRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.userName=@"";
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    NSLog(@"沙箱位置：%@",NSHomeDirectory());
    //加载图片
    OLImage *o;
    NSString *str=[[NSBundle mainBundle] pathForResource:@"loading2" ofType:@"gif"];
    NSData *data=[NSData dataWithContentsOfFile:str];
    o=[[OLImage alloc] initWithData:data];
    self.loadingImage = o;
    
    //创建udpspcket
    self.upSocket=[[AsyncUdpSocket alloc]init];
    //随便绑定端口
    [self.upSocket bindToPort:8000 error:Nil];
    //是否广播
    [self.upSocket enableBroadcast:YES error:nil];
    //不断接收
    [self.upSocket receiveWithTimeout:-1 tag:0];
    
//    if ([NSStandardUserDefaults objectForKey:@"USER_NAME"]) {
//        self.userName = [NSStandardUserDefaults objectForKey:@"USER_NAME"];
//        
//        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TRTabBarViewController"];
//    }
    
//    wx4290415ed7173ad1
    //向微信注册
    [WXApi registerApp:@"wx4290415ed7173ad1" withDescription:@"demo 2.0"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushContent:) name:SERVICE_NAME_RECOMMEND object:nil];
    
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    return YES;
}

#pragma mark MobClick
- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SERVICE_NAME_RECOMMEND object:nil];
}

-(void)pushContent:(NSNotification*)nofi{
//如果是推送内容，处理
    
    
    //1、提取内容
//    NSString * title = nofi.userInfo[@"BODY"][@"RECOMMEND_SEND"][@"RECOMMEND"][@"TITLE"];
//    NSString * create_date =  nofi.userInfo[@"BODY"][@"RECOMMEND_SEND"][@"RECOMMEND"][@"CREATE_DATE"];
//    NSString * push_ID = nofi.userInfo[@"BODY"][@"RECOMMEND_SEND"][@"RECOMMEND"][@"ID"];
//    NSString * level = nofi.userInfo[@"BODY"][@"RECOMMEND_SEND"][@"RECOMMEND"][@"LEVEL"];
//    NSString * read = nofi.userInfo[@"BODY"][@"RECOMMEND_SEND"][@"RECOMMEND"][@"READ"];
    
    if ([nofi.userInfo[@"HEAD"][@"SERVICE_CODE"] intValue]<3005) {
        return;
    }
    //3005\3006
    NSMutableDictionary * pushDict;
    if ([NSStandardUserDefaults objectForKey:@"pushFromServer"]) {
        pushDict = [NSMutableDictionary dictionaryWithDictionary:[NSStandardUserDefaults objectForKey:@"pushFromServer"]];
    }else{
        
        pushDict = [@{}mutableCopy];
        
    }
    
    NSString * server_code = nofi.userInfo[@"HEAD"][@"SERVICE_CODE"];
    
//    NSString * content = nofi.userInfo[@"BODY"][@"RECOMMEND_SEND"][@"RECOMMEND"][@"CONTENT"];
    NSMutableArray * array3005_6;
    NSMutableArray * containIDs;
    if ([pushDict objectForKey:server_code]) {
        array3005_6 = [NSMutableArray arrayWithArray:[NSStandardUserDefaults objectForKey:@"pushFromServer"][server_code]];
        
    }else{
        
        array3005_6 = [@[]mutableCopy];
    }
    
    //加一个id判断数组
    if ([NSStandardUserDefaults objectForKey:[NSString stringWithFormat:@"containIDs&&%@",server_code]]) {
        containIDs = [NSMutableArray arrayWithArray:[NSStandardUserDefaults objectForKey:[NSString stringWithFormat:@"containIDs&&%@",server_code]]];
    }else{
        
        containIDs = [@[]mutableCopy];
    }
    
    //分别保存两种
    NSDictionary * recommend = nofi.userInfo[@"BODY"][@"RECOMMEND_SEND"][@"RECOMMEND"];
    
    //如果没有相同的ID
    NSLog(@"contain:%@",containIDs);
    if (![containIDs containsObject:recommend[@"ID"]]) {
        [array3005_6 addObject:recommend];
        [pushDict setObject:array3005_6 forKey:server_code];
        [containIDs addObject:recommend[@"ID"]];
    }
    
[NSStandardUserDefaults setObject:containIDs forKey:[NSString stringWithFormat:@"containIDs&&%@",server_code]];
    
   //{3005:[字典{ID：……}]，3006：[字典{ID：……}]}
    
    
    [NSStandardUserDefaults setObject:pushDict forKey:@"pushFromServer"];
    [NSStandardUserDefaults synchronize];
   
    NSMutableArray * pushArr = [@[]mutableCopy];
    [pushArr addObjectsFromArray:pushDict[@"3005"]];
     [pushArr addObjectsFromArray:pushDict[@"3006"]];
    for (NSDictionary * dict in pushArr) {
        
        [self pushMessage:dict[@"TITLE"] andtime:5 andNum:pushArr.count];
    }

}

-(void)pushMessage:(NSString *)message andtime:(int)time andNum:(int)num{

    //8************
    //设置20秒之后
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:time];
    
    /*
     
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     
     [formatter setDateFormat:@"HH:mm:ss"];
     
     NSDate *now = [formatter dateFromString:@"15:00:00"];//触发通知的时间
     
     */
    
    //chuagjian
    
    //    一个本地推送
    
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    
    if (noti) {
        
        //设置推送时间
        
        noti.fireDate = date;//=now
        
        //设置时区
        
        noti.timeZone = [NSTimeZone defaultTimeZone];
        
        //设置重复间隔
        
        noti.repeatInterval = NSDayCalendarUnit;
        
        //推送声音
        
        noti.soundName = UILocalNotificationDefaultSoundName;
        
        //内容
        
        noti.alertBody = message;
        
        //显示在icon上的红色圈中的数子
        
        noti.applicationIconBadgeNumber = num;
        
        //设置userinfo 方便在之后需要撤销的时候使用
        
        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
        
        noti.userInfo = infoDic;
        
        //添加推送到uiapplication
        
        UIApplication *app = [UIApplication sharedApplication];
        
//        [app presentLocalNotificationNow:noti];
        [app scheduleLocalNotification:noti];
        
    }

}
- (id)init{
    if(self = [super init]){
        _scene = WXSceneTimeline;
    }
    return self;
}
-(void) changeScene:(NSInteger)scene
{
    _scene = scene;
}
- (void)sendFileContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"ML.png";
    message.description = @"Pro CoreData";
    [message setThumbImage:[UIImage imageNamed:@"1"]];
    UIImage * image = [UIImage imageNamed:@"1"];
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = @"pdf";
//    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ML" ofType:@"pdf"];
    
//    ext.fileData = [NSData dataWithContentsOfFile:filePath];
    
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        
        data = UIImageJPEGRepresentation(image, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(image);
    }
    ext.fileData = data;
    
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void) sendImageContent:(UIImage *)image andImageDescription:(NSString*)description
{
    WXMediaMessage *message = [WXMediaMessage message];
    
    UIImage * thumbImage = [UIImage scaleToSize:CGSizeMake(100, 60) for:image];
    //32k
     NSData *imageData = UIImageJPEGRepresentation(thumbImage, 1);
    //大小控制
    float m = 0.01;
    float n = 1.0;
    while ((unsigned long)imageData.length>1024*20) {
        n = n - m;
        imageData = UIImageJPEGRepresentation(image,n);
        NSLog(@"数据大小：%lu",(unsigned long)imageData.length);
    }
    NSLog(@"数据最终大小：%lu",(unsigned long)imageData.length);
    [message setThumbImage:[UIImage imageWithData:imageData]];
    
    WXImageObject *ext = [WXImageObject object];

    ext.imageData = UIImagePNGRepresentation(image);
    NSLog(@"发送图片大小：%lu",(unsigned long)ext.imageData.length);
    if (ext.imageData.length>1024*1024*10) {
        //超出10M
        NSLog(@"发送图片大小超出10M");
        [MMProgressHUD showWithTitle:@"" status:@"大小超出10M,启动压缩"];
        float m = 0.01;
        float n = 1.0;
        
        imageData = ext.imageData;
        
        while ((unsigned long)imageData.length>1024*1024*10) {
            n = n - m;
            imageData = UIImageJPEGRepresentation(image,n);
            NSLog(@"数据大小：%lu",(unsigned long)imageData.length);
        }
        NSLog(@"数据最终大小：%lu",(unsigned long)imageData.length);
        ext.imageData = imageData;
        [MMProgressHUD dismissWithSuccess:@"压缩成功，准备跳转"];

    }
    

    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.text = description;
    req.message = message;
    req.scene = _scene;
    
    
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:UIPasteboardNameGeneral create:YES];
    
    pasteboard.string=@"复制文字";

    [WXApi sendReq:req];
    
}


-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];

    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    
    }
}



- (void)sendGifContent:(NSArray *)array andFilePath:(NSString *)filePath
{
    WXMediaMessage *message = [WXMediaMessage message];
//    [message setThumbImage:[UIImage imageNamed:@"res6thumb.png"]];
    ;
    
    UIImage * image =array[0];
    //32k
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    //大小控制
    float m = 0.1;
    float n = 1.0;
    while ((unsigned long)imageData.length>1024*20) {
        n = n - m;
        imageData = UIImageJPEGRepresentation(image,n);
        NSLog(@"数据大小：%lu",(unsigned long)imageData.length);
    }
    NSLog(@"数据最终大小：%lu",(unsigned long)imageData.length);
    [message setThumbImage:[UIImage imageWithData:imageData]];
    
    
    WXEmoticonObject *ext = [WXEmoticonObject object];

    ext.emoticonData = [NSData dataWithContentsOfFile:filePath] ;
    NSLog(@"大小是：%lu",(unsigned long)ext.emoticonData.length);
   
    
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}
-(UdpClientSocket *)udpClientSocket
{
    
    return [UdpClientSocket sharedUdpClientSocket];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

//判断是否安装微信
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    if (!isSuc) {
        [SVProgressHUD showSuccessWithStatus:@"没有安装微信"];
    }
    
    
    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}

#pragma mark WXApiDelegate


// 从微信返回时调用
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle;
        if (_scene==0) {
            strTitle=@"分享好友";
        }
        if (_scene==1) {
            strTitle=@"分享朋友圈";
        }
        NSString *strMsgs;
        switch (resp.errCode) {
            case 0:
                strMsgs=@"发送成功";
                break;
            case -1:
                strMsgs=@"普通错误类型";
                break;
            case -2:
                strMsgs=@"用户点击取消并返回";
                break;
            case -3:
                strMsgs=@"取消发送";
                break;
            case -4:
                strMsgs=@"授权失败";
                break;
            case -5:
                strMsgs=@"微信不支持";
                break;
                
            default:
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsgs delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification
{
  
    application.applicationIconBadgeNumber -= 1;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
