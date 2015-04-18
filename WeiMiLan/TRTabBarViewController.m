//
//  TRTabBarViewController.m
//  WeiMiLan
//
//  Created by Mac on 14-7-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRTabBarViewController.h"
#import "MenuView.h"


@interface TRTabBarViewController ()

@end

@implementation TRTabBarViewController

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
    self.delegate=self;
    [self initTabbarView];
    [self menuClicked];
     [self occurMenu];
//    [self.tabBar addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];


    // Do any additional setup after loading the view.
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    
//    if (self.customTabBarView.hidden) {
//        self.customTabBarView.hidden=NO;
//    }else
//        self.customTabBarView.hidden = YES;
//
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
   _menuView.hidden=YES;
}

-(void)initTabbarView{
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomTabBarView" owner:self options:nil];
    self.customTabBarView = [nibObjects objectAtIndex:0];
    self.customTabBarView.delegate = self;
    [self.customTabBarView initView];
    
    CGRect r = self.customTabBarView.frame;
    r.origin.y = self.view.frame.size.height - self.customTabBarView.frame.size.height ;
    self.customTabBarView.frame = r;
    [self.view addSubview:self.customTabBarView];
}

#pragma mark CustomTabBarViewDelegate

-(void)buttonWasSelected:(NSInteger)index {
    
    

    
    
    NSLog(@"选择：%d",index);
    UIViewController * vc = self.tabBarController.viewControllers[index];
    [vc.navigationController popToRootViewControllerAnimated:YES];
    
    
    
    [self setSelectedIndex:index];
    
    if (self.selectedIndex==0) {

        
        if (_menuView.hidden==YES) {
            _menuView.hidden=NO;
        }else
        {
            _menuView.hidden=YES;
        
        }

    }
    
    if (self.selectedIndex==1) {
        _menuView.hidden=YES;
    }

    if (self.selectedIndex==2) {
        _menuView.hidden=YES;
    }
}



#pragma 显示菜单
-(void)occurMenu{
    CGRect frame=_menuView.frame;
    frame.origin.y=self.view.frame.size.height/2-2;
    _menuView.frame=frame;
    
}
#pragma 菜单按钮
-(void)menuClicked{
    NSArray *images=@[@"女包.png",@"男包.png",@"服装.png",@"鞋子.png",@"腕表.png",@"皮带.png",@"钱夹.png",@"饰品.png",@"眼镜.png"];
    _menuView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 237)];
    
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _menuView.frame.size.width, _menuView.frame.size.height)];
    image.image=wImage(@"背景.png");
    for (int i=0; i<9; i++) {
        MenuView *menuView=[[MenuView alloc]init];
        if (i<3) {
            menuView.frame=CGRectMake(_menuView.frame.size.width/3*i, 0, self.view.frame.size.width/3, _menuView.frame.size.height/3);
        }
        
        if (i>=3) {
            menuView.frame= CGRectMake(_menuView.frame.size.width/3*(i%3),_menuView.frame.size.height/3, self.view.frame.size.width/3, _menuView.frame.size.height/3);
            if (i>=6) {
                menuView.frame=CGRectMake(_menuView.frame.size.width/3*(i%6),_menuView.frame.size.height/3*2, self.view.frame.size.width/3, _menuView.frame.size.height/3);
            }
            
        }
        
        // NSLog(@"==%f,%f",menuView.frame.origin.x,menuView.frame.origin.y);
        menuView.layer.borderWidth=0.6;
        menuView.layer.borderColor=[UIColor grayColor].CGColor;
        
        menuView.tag=i;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked:)];
        [menuView addGestureRecognizer:tap];
        NSString *str=images[i];
        NSArray *name=[str componentsSeparatedByString:@"."];
        
        [menuView layoutMenuImage:images[i] andTitle:name[0]];
        //view.backgroundColor=[UIColor blackColor];
        [image addSubview:menuView];
        
        image.userInteractionEnabled=YES;
        
    }
    [_menuView addSubview:image];
    [self.view addSubview:_menuView];
    
    
    //NSLog(@"===%@",_menuView);
    
}

- (void)tapClicked:(UITapGestureRecognizer *)tap
{
    UIView *v=tap.view;

    [self.delegate menuViewDidSelecte:v.tag];

    

}



@end
