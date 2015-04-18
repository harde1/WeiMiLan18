//
//  TRMineViewController.m
//  WeiMiLan
//
//  Created by Mac on 14-7-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRMineViewController.h"
#import "MineCell.h"
#import "TRListTableViewController.h"
#import "TRLoginViewController.h"
#import "TRTabBarViewController.h"
#import "TRChangePWViewcontroller.h"
#import "TRSendViewController.h"
#import "TRMyCollectViewController.h"
@interface TRMineViewController ()<UIAlertViewDelegate,UITextFieldDelegate>
@property (strong,nonatomic)NSArray *names;
@property(nonatomic,assign)BOOL isLoading;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)UITextField * userName;
@property(nonatomic,strong)UITextField * password;
@end

@implementation TRMineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    TRTabBarViewController * tabVC =(TRTabBarViewController*) self.tabBarController;
    
    self.tabBarController.tabBar.hidden =NO;
    tabVC.customTabBarView.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigation];
    

    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    [self layoutView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}
-(void)gotoMainPage{
    
    
    NSLog(@"%d",self.tabBarController.selectedIndex);
    TRTabBarViewController * tabVC = (TRTabBarViewController *)self.tabBarController;
    [tabVC setSelectedIndex:0];
    
    [tabVC.customTabBarView selectItem:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma 布置导航，背景
-(void)layoutView{
    self.tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景1"]];
    self.names=@[@"上传",@"最新动态",@"我的收藏",@"分享排行",@"收藏排行",@"下载排行",@"修改密码",@"切换用户",@"关于微米兰"];
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90)];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(100, 0, 90, 85)];
    image.image=wImage(@"logo1.png");
    [headView addSubview:image];
    self.tableView.tableHeaderView=headView;
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}
- (void)initNavigation
{

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.weChatNavigationBar=[[WeChatNavigationBar alloc] init];
    [self.view addSubview:self.weChatNavigationBar];
    self.weChatNavigationBar.titleLabel.text=@"我的";
    //self.names=@[@"上传",@"最新动态",@"分享排行",@"收藏排行",@"下载排行",@"修改密码",@"切换用户",@"关于微米兰"];
    [self.weChatNavigationBar.rightButton setImage:nil forState:0];
    [self.weChatNavigationBar.leftButton addTarget:self action:@selector(gotoMainPage) forControlEvents:UIControlEventTouchUpInside];
    self.weChatNavigationBar.rightButton.hidden = YES;
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    MineCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.image.image=[UIImage imageNamed:[NSString stringWithFormat:@"7_2%d.png",indexPath.row]];
    
    cell.label.text=self.names[indexPath.row];
    cell.label.textColor=[UIColor whiteColor];
    UIView *v=[[UIView alloc] init];
    v.backgroundColor=[UIColor blackColor];
    cell.selectedBackgroundView=v;
    
    
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            
        {
            
            NSLog(@"--------%@",ApplicationDelegate.userName);
            if ( [ApplicationDelegate.userName isEqualToString:@""]) {
                
                
                [self login];
                
            }else{
          
            
            [self performSegueWithIdentifier:@"toSend" sender:indexPath];
            }
        }
            break;
        case 1:
            [self performSegueWithIdentifier:@"toTRNewGoodsViewController" sender:indexPath];
            break;
        case 2:
            
        {
            
            NSLog(@"--------%@",ApplicationDelegate.userName);
            if ( [ApplicationDelegate.userName isEqualToString:@""]) {
                
                
                [self login];
                
            }else{
                
                
               [self performSegueWithIdentifier:@"toMyCollect" sender:indexPath];
            }
        }
            
            
            break;
        case 2+1:
            [self performSegueWithIdentifier:@"toList" sender:indexPath];
            break;
        case 3+1:
            [self performSegueWithIdentifier:@"toList" sender:indexPath];
            break;
        case 4+1:
            [self performSegueWithIdentifier:@"toList" sender:indexPath];
            break;
        case 5+1:
            [self performSegueWithIdentifier:@"toTRChangPassWordViewController" sender:indexPath];
            break;
        case 6+1:
        {
            TRLoginViewController *lVC=[self.storyboard instantiateViewControllerWithIdentifier:@"TRLoginViewController"];
            //[self presentViewController:lVC animated:YES completion:nil];
            [self.navigationController pushViewController:lVC animated:YES];
        
        }
            break;
        case 7+1:
            [self performSegueWithIdentifier:@"toTRAboutUsViewController" sender:indexPath];
            break;
        default:
            break;
    }
    

    
}

-(void)login{
    UIAlertView * alterView = [[UIAlertView  alloc]initWithTitle:@"尚未登录" message:@"请输入登录信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //     [alterView addButtonWithTitle:@"注册"];
    alterView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    self.userName = [alterView textFieldAtIndex:0];
    self.password = [alterView textFieldAtIndex:1];
    
    self.userName.delegate = self;
    self.password.delegate = self;
    
    [alterView show];
    
}

#pragma mark 登陆
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            //取消
            
            break;
            
        case 1:
            //登录
        {
            
            
            if ([self.userName.text isEqualToString:@""]) {
                
                
                [self performSelector:@selector(alertViewShow:) withObject:@"登录名不能为空" afterDelay:.5];
                return;
            }
            if ([self.password.text isEqualToString:@""]) {
                
                
                [self performSelector:@selector(alertViewShow:) withObject:@"密码不能为空" afterDelay:.5];
                return;
            }
            
            NSString * sendMessage = [ApplicationDelegate.udpClientSocket
                                      createXmlLoginUserName:self.userName.text
                                      password:self.password.text
                                      serviceName:SERVICE_NAME_LOGIN
                                      serviceType:SERVICE_TYPE_LOGIN
                                      serviceCode:OS_TYPE_IOS];
            
            
            [ApplicationDelegate.udpClientSocket sendMessage:sendMessage];
            
            
            
            
        }
            break;
            
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath * indexPath = (NSIndexPath*)sender;

    switch (indexPath.row) {
        case 0:

       
            break;
            
            case 2:
        {
//            TRListTableViewController * listVC =(TRListTableViewController*) segue.destinationViewController;
//            listVC.usage = myCollVC;
        }
            break;
        case 2+1:
        {
        TRListTableViewController * listVC =(TRListTableViewController*) segue.destinationViewController;
            listVC.usage = sharedVC;
        }
            
            
            break;
        case 3+1:
        {
       TRListTableViewController * listVC =(TRListTableViewController*) segue.destinationViewController;
        listVC.usage = collectedVC;
        }
            break;
        case 4+1:
        {
            
    TRListTableViewController * listVC =(TRListTableViewController*) segue.destinationViewController;
        listVC.usage = downVC;
        }
            break;
            
            case 5+1:
        {
        
        }
            break;
            
        default:
            break;
    }
    
    
   
    

}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    UITextField *text1=[alertView textFieldAtIndex:0];
//    UITextField *text2=[alertView textFieldAtIndex:1];
//    switch (alertView.tag) {
//        case 1:
//        {
//            if (buttonIndex==1) {
//                if ([text1.text isEqualToString:@"123"] && [text2.text isEqualToString:@"123" ]) {
//                    UpLoadViewController *upLoad=[[[UpLoadViewController alloc]init]autorelease];
//                    [self.view.window.rootViewController presentViewController:upLoad animated:YES completion:nil];
//                    self.isLoading=YES;
//                }
//            }
//            
//        }
//            break;
//            
//        case 2:
//        {
//            if (buttonIndex==1) {
//                if ([text1.text isEqualToString:@"123"] && [text2.text isEqualToString:@"123" ]) {
//                    UpdateViewController *update=[[UpdateViewController alloc]init];
//                    //[self presentViewController:update animated:YES completion:nil];
//                    [self.view.window.rootViewController presentViewController:update animated:YES completion:nil];
//                    self.isLoading=YES;
//                }
//            }
//            
//            
//        }
//            break;
//    }
//    
//}

@end
