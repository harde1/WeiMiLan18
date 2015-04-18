//
//  TRGoodsViewController.m
//  WeiMiLan
//
//  Created by Mac on 14-7-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRGoodsViewController.h"
#import "TRMemuCell.h"

#import "TRWeixin.h"
#import "KYAlbumViewController.h"
#import "TRTabBarViewController.h"
#import "UIImage+Util.h"
#import "TRBar.h"

#import "ALAssetsLibrary+CustomPhotoAlbum.h"
@interface TRGoodsViewController ()<UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)NSArray * product_pic;
@property(nonatomic,strong)NSDictionary * product_info;
@property (weak, nonatomic) IBOutlet UIScrollView *textScroll;

//题目
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *famousBrandLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic)TRWeixin * weixinView;

@property(strong,nonatomic)NSMutableArray * sendImageViewArray;


@property(strong,nonatomic)TRBar *chooseView;
//保存建立特殊相册
@property (strong, atomic) ALAssetsLibrary * library;



@property(nonatomic,strong)UITextField * userName;
@property(nonatomic,strong)UITextField * password;

@end

@implementation TRGoodsViewController
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)sendImageContent
{

    



    
    if ([ApplicationDelegate.userName isEqualToString:@""]) {
        [self login];
        return;
    }
    [MMProgressHUD showWithTitle:@"" status:@"分享中…"];
    [self.sendImageViewArray removeAllObjects];

    for (int n=0; n<self.product_pic.count; n++) {
            TRMemuCell *cell = (TRMemuCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:n inSection:0]];

            
            if (![cell.imageView.image isEqual:ApplicationDelegate.loadingImage]) {
                 [self.sendImageViewArray addObject:cell.imageView.image];
            }
            
           
    }
  UIImage * bigImage = [UIImage addImage:self.sendImageViewArray andVOrH:1];
    if (_delegate) {
         [_delegate sendImageContent:bigImage andImageDescription:self.product_info[@"DESCRIPTION"]];
        [MMProgressHUD dismissWithSuccess:@"成功"];
    }
   
}

- (void) sendGifContent{
    for (NSDictionary * albumDict in self.product_pic) {
        
        
        NSURL *url = [NSURL URLWithString:albumDict[@"PIC_URL"]];
        
        dispatch_queue_t queue =dispatch_queue_create("loadImage",NULL);
        dispatch_async(queue, ^{
            
            NSData *resultData = [NSData dataWithContentsOfURL:url];
            UIImage *img = [UIImage imageWithData:resultData];
            
            
            [self.sendImageViewArray addObject:img];
            if (self.sendImageViewArray.count==self.product_pic.count) {
                NSString * gifpath = [UIImage getGif:self.sendImageViewArray];
                NSLog(@"生产的gif:%@",gifpath);
                if (_delegate) {
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                         [_delegate sendGifContent:self.sendImageViewArray andFilePath:gifpath];
                    });
                   
                }
                
                
            }
            
            
        });
    }

}

- (void)sendFileContent
{
    if (_delegate) {
        [_delegate sendFileContent];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.library = [[ALAssetsLibrary alloc] init];
    self.sendImageViewArray = [@[]mutableCopy];
    self.delegate = ApplicationDelegate;
    self.myTextView.editable=NO;
    //发送请求
    NSString * sendMessage = [ApplicationDelegate.udpClientSocket
                              createXmlProductUserName:ApplicationDelegate.userName
                              productTypeId:@[self.productTypeId?self.productTypeId:@""]
                              serviceName:SERVICE_NAME_PRODUCT
                              serviceType:SERVICE_TYPE_PRODUCT
                              serviceCode:SERVICE_CODE_PRODUCT_PREVIEW];
    [ApplicationDelegate.udpClientSocket sendMessage:sendMessage];
//    [MMProgressHUD showWithTitle:@"" status:@"下载中…" cancelBlock:nil];
    
    
    //接收数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:SERVICE_NAME_PRODUCT object:nil];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TRMemuCell" bundle:nil] forCellWithReuseIdentifier:@"TRMemuCell"];
    
    [self initNavigation];
    
    //分享场景:朋友圈
     [_delegate changeScene:WXSceneTimeline];
   
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSArray * weixinBtn = [[NSBundle mainBundle]loadNibNamed:@"TRWeixin" owner:self options:nil];
    self.weixinView = [weixinBtn lastObject];
    self.weixinView.bottom = self.tabBarController.tabBar.bottom;
    self.weixinView.height = self.tabBarController.tabBar.height;
    //加载在屏幕
    [ApplicationDelegate.window addSubview:self.weixinView];
    
    [self.weixinView.btn addTarget:self action:@selector(sendImageContent) forControlEvents:UIControlEventTouchUpInside];
    TRTabBarViewController * tabVC =(TRTabBarViewController*) self.tabBarController;
    self.tabBarController.tabBar.hidden =YES;
    tabVC.customTabBarView.hidden = YES;
    
    
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.weixinView removeFromSuperview];
   
    
}


-(void)fenxiang:(UIButton *)btn{

    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    return NO;
}
-(void)receiveMessage:(NSNotification*)nofi{

    
    NSString* code = nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"CODE"];
    NSString* message=nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"MESSAGE"];
    NSString * serve_code = nofi.userInfo[@"HEAD"][@"SERVICE_CODE"];
    
    if ([serve_code isEqualToString:SERVICE_CODE_PRODUCT_PREVIEW]) {
        
    
    if ([code isEqualToString:@"0000"]) {
        self.product_pic = nofi.userInfo[@"BODY"][@"PRODUCT_RSP"][@"PRODUCT_PIC"];
        self.product_info = nofi.userInfo[@"BODY"][@"PRODUCT_RSP"][@"PRODUCT_INFO"];
        [self updataBrandData:self.product_info];
        
        [self.collectionView reloadData];
//        [MMProgressHUD dismissWithSuccess:message];
    }else{
//    [MMProgressHUD dismissWithError:message];
    }
    }
}


-(void)updataBrandData:(NSDictionary *)dict{
    self.titleNameLabel.text = [[dict[@"DESCRIPTION"] componentsSeparatedByString:@" "] objectAtIndex:0];
    
    
    self.descriptionLabel.text = dict[@"DESCRIPTION"];

  CGRect textRect =  [self.descriptionLabel.text boundingRectWithSize:self.descriptionLabel.size options:NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil];
    self.textScroll.contentSize = CGSizeMake(0, textRect.size.height);
    
    
    self.myTextView.text = dict[@"DESCRIPTION"];
//    self.mywebView.hidden = YES;
//    self.mywebView.layer.borderColor = [UIColor blackColor].CGColor;
//    self.mywebView.layer.borderWidth  =8;
//    
//    
//    NSString * content = [@"<div style=\"background:#000; color:#FFF\">" stringByAppendingString:dict[@"DESCRIPTION"]];
////    self.mywebView.backgroundColor = [UIColor blackColor];
//    [self.mywebView loadHTMLString:content baseURL:nil];
    
   
    
//    NSString *js = @"window.onload = function(){document.body.style.backgroundColor = '#3333';//#3333 is your color}";
//
//[self.mywebView stringByEvaluatingJavaScriptFromString:js];
    //登录查看
    if (![ApplicationDelegate.userName isEqualToString:@""]) {
        
        self.priceLabel.text = dict[@"PRICE"];
    }
//    self.priceLabel.text = dict[@"PRICE"];
    self.famousBrandLabel.text = dict[@"NAME"];

}


-(void)dealloc{

[[NSNotificationCenter defaultCenter]removeObserver:self name:SERVICE_NAME_PRODUCT object:nil];
   

}


-(void)gotoMainPage{
    
    
    NSLog(@"%d",self.tabBarController.selectedIndex);
    TRTabBarViewController * tabVC = (TRTabBarViewController *)self.tabBarController;
    [tabVC setSelectedIndex:0];
    
    [tabVC.customTabBarView selectItem:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
//
//     [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)initNavigation
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.weChatNavigationBar=[[WeChatNavigationBar alloc] init];
    [self.view addSubview:self.weChatNavigationBar];
    self.weChatNavigationBar.titleLabel.text=@"";
    [self.weChatNavigationBar .leftButton addTarget:self action:@selector(exit)  forControlEvents:UIControlEventTouchUpInside];
    
    [self.weChatNavigationBar.rightButton setImage:[UIImage imageNamed:@"coll收藏按钮"] forState:UIControlStateNormal];
    [self.weChatNavigationBar.rightButton setImage:[UIImage imageNamed:@"coll收藏按键按下"] forState:UIControlStateHighlighted];
    
    
    
    
//    self.weChatNavigationBar.rightButton.hidden = YES;
    [self.weChatNavigationBar.rightButton addTarget:self action:@selector(collectionAll)  forControlEvents:UIControlEventTouchUpInside];
    
    self.weChatNavigationBar.rightButton2.hidden = NO;
     [self.weChatNavigationBar.rightButton2 addTarget:self action:@selector(downAll)  forControlEvents:UIControlEventTouchUpInside];
    
     self.weChatNavigationBar.rightButton3.hidden = NO;
     [self.weChatNavigationBar.rightButton3 addTarget:self action:@selector(exit)  forControlEvents:UIControlEventTouchUpInside];
}

//收藏
-(void)collectionAll{
    
    if (self.productTypeId) {
        
  
    NSString * collectString = [ApplicationDelegate.udpClientSocket
                                createXmlProductUserName:ApplicationDelegate.userName
                                productTypeId:@[self.productTypeId]
                                serviceName:SERVICE_NAME_PRODUCT
                                serviceType:SERVICE_TYPE_PRODUCT
                                serviceCode:[NSString stringWithFormat:@"%d",DirectoryAddCollection]];
    
    [ApplicationDelegate.udpClientSocket sendMessage:collectString];
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
//下载
-(void)downAll{

    if ([ApplicationDelegate.userName isEqualToString:@""]) {
        [self login];
        
    }else{
    
        if (self.product_pic.count>0) {
            
            
            [MMProgressHUD showWithTitle:@"" status:@"相片保存中…" cancelBlock:^{}];
    //        NSLog(@"youduos 个：%d",self.product_pic.count);
            for (int n=0; n<self.product_pic.count; n++) {
                TRMemuCell *cell = (TRMemuCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:n inSection:0]];

                    UIImage * img =  cell.imageView.image;
                if (![img isEqual:ApplicationDelegate.loadingImage]) {
                    
               
                    [self.library saveImage:img toAlbum:self.titleNameLabel.text withCompletionBlock:^(NSError *error) {
                        
                        if (error!=nil) {
                            
                            NSLog(@"Big error: %@", [error description]);
                            return;
                        }
                        [MMProgressHUD dismissWithSuccess:@"成功"];
                    }];
                  
                    
                    

                }
            
                
            }
        }
    }
    
}

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

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)alertViewShow:(NSString*)message{
    
    UIAlertView * alterView = [[UIAlertView  alloc]initWithTitle:@"登录" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//     [alterView addButtonWithTitle:@"注册"];
    
    alterView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    self.userName = [alterView textFieldAtIndex:0];
    self.password = [alterView textFieldAtIndex:1];
    self.userName.delegate = self;
    self.password.delegate = self;
    
    [alterView show];
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        
        //        [self alertView:nil clickedButtonAtIndex:1];
    }
    return YES;
}


-(void)exit
{
 [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    [self.sendImageViewArray removeAllObjects];
    return self.product_pic.count;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TRMemuCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"TRMemuCell" forIndexPath:indexPath];
    [cell.imageView setImageWithURL:[NSURL URLWithString:self.product_pic[indexPath.row][@"PIC_URL"]] placeholderImage:ApplicationDelegate.loadingImage];
    

    
    cell.selectImageView.hidden= YES;
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.product_pic) {
        KYAlbumViewController * vc = [[KYAlbumViewController alloc]init];
        vc.album = self.product_pic;
        vc.isFromGood = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}


@end