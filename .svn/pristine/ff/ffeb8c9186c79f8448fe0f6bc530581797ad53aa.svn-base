//
//  TRChangePWViewcontroller.m
//  WeiMiLan
//
//  Created by cong on 14-7-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRChangePWViewcontroller.h"

@interface TRChangePWViewcontroller ()
@property (weak, nonatomic) IBOutlet UITextField *yuanPWTF;
@property (weak, nonatomic) IBOutlet UITextField *password_new;
@property (weak, nonatomic) IBOutlet UITextField *password_sure;

@end

@implementation TRChangePWViewcontroller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)dismissBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (IBAction)sureBtn:(UIButton *)sender {
    
    [MMProgressHUD showWithTitle:@"" status:@"修改密码"];
    if ([self.yuanPWTF.text isEqualToString:@""]) {
        
         [MMProgressHUD dismissWithError:@"请输入原密码"];
        return;
    }
    if ([self.password_new.text isEqualToString:@""]) {
        
         [MMProgressHUD dismissWithError:@"请输入新密码"];
        return;
    }
    
    if ([self.password_sure.text isEqualToString:@""]) {
        
         [MMProgressHUD dismissWithError:@"请确认新密码"];
        return;
    }
    
    NSString * sendMessage = [ApplicationDelegate.udpClientSocket createXmlModifyPasswrodUserName:ApplicationDelegate.userName OldPassword:self.yuanPWTF.text NewPassword:self.password_new.text serviceName:SERVICE_NAME_CHANGEPW serviceType:SERVICE_TYPE_CHANEPW serviceCode:@""];
    
    
    
    
    [ApplicationDelegate.udpClientSocket sendMessage:sendMessage];
}

-(void)receiveMessage:(NSNotification*)nofi{
    NSString* code = nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"CODE"];
    NSString* message=nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"MESSAGE"];
    if ([code isEqualToString:@"0000"]) {
        
        [MMProgressHUD dismissWithSuccess:message];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [MMProgressHUD dismissWithError:message];
    }
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMessage:)
                                                 name:SERVICE_NAME_CHANGEPW
                                               object:nil];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (IBAction)hiddenKeyBoard:(id)sender {
    
    
    [[self getFirstResponder] resignFirstResponder];
}

-(UITextField *)getFirstResponder{
    for (UIView * view in self.view.subviews) {
        if ([view isMemberOfClass:[UITextField class]]) {
            
            if ([view isFirstResponder]) {
                
                return (UITextField *)view;
            }
            
        }
    }
    return nil;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
