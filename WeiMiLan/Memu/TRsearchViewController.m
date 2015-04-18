//
//  TRsearchViewController.m
//  WeiMiLan
//
//  Created by cong on 14-8-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRsearchViewController.h"

@interface TRsearchViewController ()

@end

@implementation TRsearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)gotoMainPage{
    
    
    //    NSLog(@"%d",self.tabBarController.selectedIndex);
    //    TRTabBarViewController * tabVC = (TRTabBarViewController *)self.tabBarController;
    //    [tabVC setSelectedIndex:0];
    //
    //    [tabVC.customTabBarView selectItem:0];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)initNavigation
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.weChatNavigationBar=[[WeChatNavigationBar alloc] init];
    [self.view addSubview:self.weChatNavigationBar];
    //    self.weChatNavigationBar.titleLabel.text=self.album[0][@"NAME"];
    
    self.weChatNavigationBar.titleLabel.text=@"";
    [self.weChatNavigationBar .leftButton addTarget:self action:@selector(gotoMainPage)  forControlEvents:UIControlEventTouchUpInside];
//    UIImage * imge =[UIImage imageNamed:@"down下载按钮"];
//    [self.weChatNavigationBar.rightButton setImage:imge forState:UIControlStateNormal];
//    [self.weChatNavigationBar.rightButton setImage:[UIImage imageNamed:@"down下载按键按下"] forState:UIControlStateHighlighted];
//    
//    [self.weChatNavigationBar.rightButton addTarget:self action:@selector(showZanView) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigation];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
