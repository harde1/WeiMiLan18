//
//  TRRegisterViewController.m
//  WeiMiLan
//
//  Created by cong on 14-7-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRRegisterViewController.h"

@interface TRRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *zhanghaoTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property(nonatomic,assign)BOOL hidden;

@end

@implementation TRRegisterViewController

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
- (IBAction)registerBtn:(UIButton *)sender {
    
    [MMProgressHUD showWithTitle:@"注册中…" status:@""];
    if ([self.zhanghaoTF.text isEqualToString:@""]) {
        
        [MMProgressHUD dismissWithError:@"请输入帐号"];
        return;
    }
    if ([self.passwordTF.text isEqualToString:@""]) {
        
        [MMProgressHUD dismissWithError:@"请输入密码"];
        return;
    }
    if ([self.nameTF.text isEqualToString:@""]) {
        
        [MMProgressHUD dismissWithError:@"请输入姓名"];
        return;
    }
    
    if ([self.phoneTF.text isEqualToString:@""]) {
        
        [MMProgressHUD dismissWithError:@"请输入电话号码"];
        return;
    }
    
    //<?xml version='1.0' encoding='UTF-8' ?><MYAPP><HEAD><USER_NAME>空间</USER_NAME><MAC>78:F7:BE:27:AD:09</MAC><SERVICE_NAME>resigter</SERVICE_NAME><SERVICE_TYPE>5</SERVICE_TYPE><SERVICE_CODE></SERVICE_CODE><ACTION_CODE>0</ACTION_CODE><TIME_STAMP>20140724155736</TIME_STAMP><TIME_EXPIRE>20140724160236</TIME_EXPIRE><SERIAL_NUMBER></SERIAL_NUMBER></HEAD><BODY><REGISTER_USER><LOGIN_NAME>空间</LOGIN_NAME><PASS_WORD>gighui</PASS_WORD><NAME>寂寞</NAME><PHONE>18812345670</PHONE><MAC>78:F7:BE:27:AD:09</MAC><REGION></REGION></REGISTER_USER></BODY></MYAPP>
    
    NSString * regiString = [ApplicationDelegate.udpClientSocket
                             createXmlRegisterUserName:self.zhanghaoTF.text
                             password:self.passwordTF.text
                             name:self.nameTF.text
                             phone:self.phoneTF.text
                             serviceName:SERVICE_NAME_REGISTER
                             serviceType:SERVICE_TYPE_REGISTER
                             serviceCode:@""];
    
    
    [ApplicationDelegate.udpClientSocket sendMessage:regiString];
    
    
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
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMessage:)
                                                 name:SERVICE_NAME_REGISTER
                                               object:nil];
    
    
    //如果用户设置了号码，就可以获取
    if ([NSStandardUserDefaults objectForKey:@"SBFormattedPhoneNumber"]) {
        self.phoneTF.text = [NSStandardUserDefaults objectForKey:@"SBFormattedPhoneNumber"];
    }
    // Do any additional setup after loading the view.
}
- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.hidden == YES) {
        return;
    }
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    
    NSLog(@"y:%g~~~~%g",y,[self getFirstResponder].frame.origin.y);
    if ([self getFirstResponder].frame.origin.y>y) {
        self.view.bottom =y;
    }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.hidden == YES) {
        return;
    }
    
    self.view.top = 0;
   
}


- (IBAction)tap:(UITapGestureRecognizer *)sender {
}
@end
