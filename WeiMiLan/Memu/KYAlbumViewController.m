//
//  DemoViewController.m
//  SlideImageView
//
//  Created by rd on 12-12-17.
//  Copyright (c) 2012年 LXJ_成都. All rights reserved.
//

#import "KYAlbumViewController.h"
#import "UIImage+Util.h"
#import "TRMemuViewController.h"
@interface KYAlbumViewController ()<UIActionSheetDelegate>{
UIScrollView *imageScrollView;
UIPageControl *pageControl;
}   
@property(strong,nonatomic)NSMutableArray* ivArray;
@end

@implementation KYAlbumViewController


-(void)showZanView{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:Nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"保存手机",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    actionSheet.backgroundColor = [UIColor blackColor];
    actionSheet.delegate =self;
    [actionSheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    

    switch (buttonIndex) {
//        case 0:
//             NSLog(@"赞");
////            [self thumbAction];
//            
//            break;
//        case 1:
//           NSLog(@"收藏");
//            
////            [self starTopicAction];
//            break;
//        case 2:
//            NSLog(@"分享");
//            break;
        case 0:
             NSLog(@"保存手机");
            NSLog(@"点中了那个张%d",pageControl.currentPage);
            UIImageView * iv = self.ivArray[pageControl.currentPage];
            UIImageWriteToSavedPhotosAlbum(iv.image, nil, nil,nil);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存储照片成功"
                                  
                                                            message:@"您已将照片存储于图片库中，打开照片程序即可查看。"
                                  
                                                           delegate:self
                                  
                                                  cancelButtonTitle:@"OK"
                                  
                                                  otherButtonTitles:nil];
            
            [alert show];
            break;
//
    }
    
}


//添加UIScrollView
-(void)addScrollView {
    
    imageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, self.view.height)];
    imageScrollView.backgroundColor = [UIColor clearColor];
    imageScrollView.contentSize = CGSizeMake(self.view.width*self.album.count, 0);    // 设置内容大小
    imageScrollView.delegate = self;
    imageScrollView.pagingEnabled = YES;
    imageScrollView.showsHorizontalScrollIndicator = NO;//滚动的时候是否有水平的滚动条，默认是有的
    imageScrollView.showsVerticalScrollIndicator = NO;
    
    
    
    for (int i = 0; i < self.album.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.width, 0, self.view.width, self.view.height)];
        NSDictionary * dict = self.album[i];;
        if (self.isFromGood) {
            dict = self.album[i];
            
            [imageView setImageWithURL:[NSURL URLWithString:dict[@"PIC_URL"]] placeholderImage:ApplicationDelegate.loadingImage];
        }else{
        
            imageView.image = dict[@"image"];
        }
      
        imageView.tag = 110 + i;
        imageView.userInteractionEnabled=YES;//与用户交互
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageScrollView addSubview:imageView];
        //图片上的字
        UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(20, kUI_SCREEN_HEIGHT-100, 280, 50)];
        l.textColor=[UIColor whiteColor];
        l.backgroundColor=[UIColor clearColor];
        
        
        if (self.isFromGood) {
            if ([dict[@"NAME"] isEqual:[NSNull null]]) {
                
            }else{
                l.text=dict[@"NAME"]?dict[@"NAME"]:@"";
            }
        }else{
        
            if ([dict[@"name"] isEqual:[NSNull null]]) {
                
            }else{
                l.text=dict[@"name"]?dict[@"name"]:@"";
            }
        }
       
            [imageView addSubview:l];
        
        
        //为UIImageView添加点击手势
//        UITapGestureRecognizer *tap;
//        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//        tap.numberOfTapsRequired = 1;//tap次数
//        tap.numberOfTouchesRequired = 1;//手指数
//        [imageView addGestureRecognizer:tap];
//        [self.ivArray addObject:imageView];
        
    }
    
    [self.view addSubview:imageScrollView];
}

//添加PageControl
-(void) addPageControl {
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, 440, 320, 40)];
    pageControl.center = CGPointMake(self.view.center.x, self.view.height-70);
    pageControl.numberOfPages = self.album.count;//页数（几个圆圈）
    pageControl.tag = 101;
    pageControl.currentPage = 0;
    
    [self.view addSubview:pageControl];
    
}

//单击图片之后响应的
-(void) tap: (UITapGestureRecognizer*)sender{
    
    NSLog(@"tap %ld image",(long)pageControl.currentPage);
    
   
    
}

//滚动视图的代理方法－ scrollview 减速停止
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int current = scrollView.contentOffset.x/self.view.width;
    NSLog(@"current:%d",current);
    pageControl.currentPage = current;
//     self.title = [NSString stringWithFormat:@"%d/%d",pageControl.currentPage+1,self.album.count];
    
    self.weChatNavigationBar.titleLabel.text = self.album[pageControl.currentPage][@"NAME"];
    self.weChatNavigationBar.titleLabel.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    TRTabBarViewController * tabVC =(TRTabBarViewController*) self.tabBarController;
    self.tabBarController.tabBar.hidden =NO;
    tabVC.customTabBarView.hidden = NO;
  
    

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    TRTabBarViewController * tabVC =(TRTabBarViewController*) self.tabBarController;
    self.tabBarController.tabBar.hidden =YES;
    tabVC.customTabBarView.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    self.ivArray = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    [self addScrollView];
    [self addPageControl];

    
    
    [self initNavigation];
}
-(void)gotoMainPage{

    
    NSLog(@"%d",self.tabBarController.selectedIndex);
    TRTabBarViewController * tabVC = (TRTabBarViewController *)self.tabBarController;
    [tabVC setSelectedIndex:0];
    
    [tabVC.customTabBarView selectItem:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    [self.navigationController popViewControllerAnimated:YES];
  
}
- (void)initNavigation
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.weChatNavigationBar=[[WeChatNavigationBar alloc] init];
    [self.view addSubview:self.weChatNavigationBar];
//    self.weChatNavigationBar.titleLabel.text=self.album[0][@"NAME"];
    
    self.weChatNavigationBar.titleLabel.text=@"";
    [self.weChatNavigationBar .leftButton addTarget:self action:@selector(exit)  forControlEvents:UIControlEventTouchUpInside];
    UIImage * imge =[UIImage imageNamed:@"down下载按钮"];
    [self.weChatNavigationBar.rightButton setImage:imge forState:UIControlStateNormal];
    [self.weChatNavigationBar.rightButton setImage:[UIImage imageNamed:@"down下载按键按下"] forState:UIControlStateHighlighted];
    
    [self.weChatNavigationBar.rightButton addTarget:self action:@selector(showZanView) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (!self.isFromGood) {
        
        self.weChatNavigationBar.rightButton.height=44;
        self.weChatNavigationBar.rightButton.width=44;
        [self.weChatNavigationBar.rightButton setImage:[UIImage imageNamed:@"icon_shanchu_unfocused"] forState:UIControlStateNormal];
        [self.weChatNavigationBar.rightButton setImage:[UIImage imageNamed:@"icon_shanchu_unfocused"] forState:UIControlStateHighlighted];
        [self.weChatNavigationBar.rightButton removeTarget:self action:@selector(showZanView) forControlEvents:UIControlEventTouchUpInside];
        [self.weChatNavigationBar.rightButton addTarget:self action:@selector(delImage) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)delImage{
    
    NSMutableArray * newAlum = [NSMutableArray arrayWithArray:self.album];
    
    
    [newAlum removeObject:self.album[pageControl.currentPage]];
    
    
    self.album = newAlum;
    
    if (self.delegate) {
         [self.delegate delImageFromArray:self.album];
    }
   
    if (self.album.count==0) {
        
        [self exit];
        return;
    }

    [imageScrollView removeFromSuperview];
    [pageControl removeFromSuperview];
    
    
    

    [self addScrollView];
    [self addPageControl];
    
    [self initNavigation];

}
-(void)exit
{
    
  [self.navigationController popViewControllerAnimated:YES];
}
@end
