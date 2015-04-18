//
//  TRLoginViewController.m
//  WeiMiLan
//
//  Created by Mac on 14-7-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRLoginViewController.h"
#import "TRAboutUsViewController.h"

//#import "UdpClientSocket.h"


@interface TRLoginViewController ()
//@property(nonatomic,strong)UdpClientSocket* udpClientSocket;
@end

@implementation TRLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigation];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:SERVICE_NAME_LOGIN object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SERVICE_NAME_LOGIN object:nil];
}
-(void)receiveMessage:(NSNotification*)nofi{

    
    NSLog(@"%@",nofi.userInfo);
    
    if ([nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"CODE"] isEqualToString:@"0000"]) {
        
//        ApplicationDelegate.userName = nofi.userInfo[@"HEAD"][@"USER_NAME"];
//        
//        NSString * upurl = nofi.userInfo[@"BODY"][@"LOGIN_USER_RSP"][@"UPLOAD_URL"];
//        ApplicationDelegate.userID = [upurl stringByReplacingOccurrencesOfString:@"http://www.op89.com:8080/test/client-upload-pic?" withString:@""];
//        ApplicationDelegate.uploadUrl = [NSURL URLWithString:upurl];
//        
//        
//        [NSStandardUserDefaults setObject:nofi.userInfo[@"HEAD"][@"USER_NAME"] forKey:@"USER_NAME"];
//        [NSStandardUserDefaults synchronize];
        
       // [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
        
        [NSStandardUserDefaults setObject:nofi.userInfo forKey:@"USER_NAME"];
        [NSStandardUserDefaults setObject:self.passwordTextField.text forKey:nofi.userInfo[@"HEAD"][@"USER_NAME"]];
        [NSStandardUserDefaults synchronize];
        
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TRTabBarViewController"] animated:YES completion:^{
            
        }];

        
    }else{

    }
}


- (void)initNavigation
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.weChatNavigationBar=[[WeChatNavigationBar alloc] init];
    [self.view addSubview:self.weChatNavigationBar];
    self.weChatNavigationBar.titleLabel.text=@"登陆";
    [self.weChatNavigationBar.rightButton setImage:nil forState:UIControlStateNormal];
    self.weChatNavigationBar.rightButton.top=36;
    self.weChatNavigationBar.rightButton.width=44;
    [self.weChatNavigationBar.rightButton setTitle:@"注册" forState:0];
    [self.weChatNavigationBar.rightButton addTarget:self action:@selector(toRegister) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.weChatNavigationBar .leftButton addTarget:self action:@selector(exit)  forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)exit
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)toRegister
{
    [self performSegueWithIdentifier:@"toReg" sender:nil];

}


- (IBAction)loginAction:(UIButton *)sender
{
    //test  123456
    if (self.userNameTextField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        
        return;
    }
    if (self.passwordTextField.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        
        return;
    }
    
 
    NSString * sendMessage = [ApplicationDelegate.udpClientSocket
                              createXmlLoginUserName:self.userNameTextField.text
                              password:self.passwordTextField.text
                              serviceName:SERVICE_NAME_LOGIN
                              serviceType:SERVICE_TYPE_LOGIN
                              serviceCode:OS_TYPE_IOS];
    

    
    [ApplicationDelegate.udpClientSocket sendMessage:sendMessage];
    
}



- (IBAction)helpAction:(UIButton *)sender
{
    TRAboutUsViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"TRAboutUsViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
