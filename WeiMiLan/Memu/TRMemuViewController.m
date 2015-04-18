//
//  TRMemuViewController.m
//  WeiMiLan
//
//  Created by Mac on 14-7-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRMemuViewController.h"
#import "PlayBillView.h"
#import "TRMemuCell.h"
#import "TRGoodsViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "TRActionView.h"

#import "PullCollectionView.h"

#import "TRSearchView.h"
@interface TRMemuViewController ()<PullCollectionViewDelegate>

@property(retain,nonatomic)UIScrollView *smallScroll;
@property(strong,nonatomic)UIButton *chooseBtn;
/**
 *  不同种类的collectionView
 */
@property(strong,nonatomic)PullCollectionView *ladyBag;  //女包
@property(strong,nonatomic)PullCollectionView *manBag;  //男包
@property(strong,nonatomic)PullCollectionView *clothing;//衣服
@property(strong,nonatomic)PullCollectionView *shoe;  //鞋子
@property(strong,nonatomic)PullCollectionView *Watch; //手表
@property(strong,nonatomic)PullCollectionView *belt;  //皮带
@property(strong,nonatomic)PullCollectionView *wallet;//钱包
@property(strong,nonatomic)PullCollectionView *ornament;//饰品
@property(strong,nonatomic)PullCollectionView *glasses;//眼镜

@property(strong,nonatomic)PullCollectionView *currentCollectionView;
/**
 *数据
 */
@property(strong,nonatomic)NSMutableArray *haibaoArray;//海报
@property(strong,nonatomic)NSMutableArray *goodsArray;//商品列表
@property(strong,nonatomic)NSMutableDictionary * goodsListDictByName;//通过Name找到商品的类别ID


@property(strong,nonatomic)NSMutableDictionary * collectionViewDictByName;


@property(nonatomic,assign)NSInteger count;//登录次数
@property(strong,nonatomic)NSMutableArray *currentArray;

@property(nonatomic,strong)NSMutableDictionary* alredaySelectArray;

@property(nonatomic,assign)NSInteger section;

@property(nonatomic,assign)NSInteger number;

@property(nonatomic)CGPoint currentSet;

//保存建立特殊相册
@property (strong, atomic) ALAssetsLibrary * library;

/**
 *  下载VIEW
 */
@property(nonatomic,strong)TRActionView * p_actionView;


@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)UIScrollView * homeScrollView;

@property(nonatomic)CGPoint currtentPoint;



@property(nonatomic,strong)TRSearchView * searchView;



@end

@implementation TRMemuViewController
@synthesize smallScroll;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)pullCollectionViewDidTriggerRefresh:(PullCollectionView *)pullCollectionView{
    pullCollectionView.pullTableIsRefreshing=YES;
[self performSelector:@selector(reflushNow) withObject:nil afterDelay:2.];
}
-(void)reflushNow{
    [self getCurrentCollectionView].pullTableIsRefreshing=NO;
}

- (void)pullCollectionViewDidTriggerLoadMore:(PullCollectionView*)pullCollectionView{
    
[self updateString:DirectoryGoods andPage:self.pageNum++ andIDs:@[self.goodsListDictByName[self.weChatNavigationBar.titleLabel.text][@"ID"]]];
   
    pullCollectionView.pullTableIsLoadingMore= YES;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.currentSet=self.Bigscroll.contentOffset;
    TRTabBarViewController * tabVC = (TRTabBarViewController *)self.tabBarController;
    
    tabVC.menuView.hidden = YES;
}
-(void)posetText:(NSTimer *)t{
   
    
    NSDictionary * jj = @{
                          @"BODY" :     @{
                                  @"RECOMMEND_SEND" : @{
                                          @"RECOMMEND" : @{
                                                  @"CONTENT":@"http://www.op89.com/app/recommendDetail?id=54",
                                                  @"CREATE_DATE" : @"20140727160812",
                                                  @"ID" : [NSString stringWithFormat:@"%d",self.number++],
                                                  @"LEVEL" : @"4",
                                                  @"READ" : @"0",
                                                  @"TITLE" : @"测试推送11"
                                                  }
                                          }
                                  },
                          @"HEAD" :     @{
                                  @"ACTION_CODE" : @"1",
                                  @"SERVICE_CODE" : @"3005",
                                  @"SERVICE_NAME" : @"recommend",
                                  @"SERVICE_TYPE" : @"3",
                                  @"TIME_EXPIRE" : @"20140727165653",
                                  @"TIME_STAMP" : @"20140727164653"
                                  },
                          @"__name" : @"MYAPP"
                          
                          };
    [[NSNotificationCenter defaultCenter]postNotificationName:SERVICE_NAME_RECOMMEND object:nil userInfo:jj];
}
#pragma mark 初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currtentPoint=CGPointMake(0, 0);
    
    self.number = 2002;
   
    //post测试,推送
//    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(posetText:) userInfo:nil repeats:YES];
    if ([NSStandardUserDefaults objectForKey:@"USER_NAME"]) {
        
        NSDictionary * receiveMessage = [NSStandardUserDefaults objectForKey:@"USER_NAME"];
        
        ApplicationDelegate.userName = receiveMessage[@"HEAD"][@"USER_NAME"];
        
        NSString * upurl = receiveMessage[@"BODY"][@"LOGIN_USER_RSP"][@"UPLOAD_URL"];
        ApplicationDelegate.userID = [upurl stringByReplacingOccurrencesOfString:@"http://www.op89.com:8080/test/client-upload-pic?" withString:@""];
        ApplicationDelegate.uploadUrl = [NSURL URLWithString:upurl];
        
        NSLog(@"密码：%@",[NSStandardUserDefaults objectForKey:receiveMessage[@"HEAD"][@"USER_NAME"]]);
        
        if ([NSStandardUserDefaults objectForKey:receiveMessage[@"HEAD"][@"USER_NAME"]]) {
            NSString * sendMessage = [ApplicationDelegate.udpClientSocket
                                      createXmlLoginUserName:receiveMessage[@"HEAD"][@"USER_NAME"]
                                      password:[NSStandardUserDefaults objectForKey:receiveMessage[@"HEAD"][@"USER_NAME"]]
                                      serviceName:SERVICE_NAME_LOGIN
                                      serviceType:SERVICE_TYPE_LOGIN
                                      serviceCode:OS_TYPE_IOS];
            
            [ApplicationDelegate.udpClientSocket sendMessage:sendMessage];
            
            
            
            //Http登录
            //http://www.op89.com/app/Interface/Login?USER_NAME=harde1&USER_PASSWORD=123456
            NSString *URLTmp = @"http://www.op89.com/app/Interface/Login?USER_NAME=%@&USER_PASSWORD=%@";
            
            URLTmp = [NSString stringWithFormat:URLTmp,receiveMessage[@"HEAD"][@"USER_NAME"],[NSStandardUserDefaults objectForKey:receiveMessage[@"HEAD"][@"USER_NAME"]]];
            NSString *URLTmp1 = [URLTmp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  //转码成UTF-8  否则可能会出现错误
            URLTmp = URLTmp1;
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLTmp]];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Success: %@", operation.responseString);
                
                NSString *requestTmp = [NSString stringWithString:operation.responseString];
                NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                //系统自带JSON解析
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                
                
               
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Failure: %@",error);

                MMProgressHUDShowError(@"提交失败，请重试");
                
            }];
            [operation start];
            
        }
        
    }

    
    self.pageNum=1;
    self.library = [[ALAssetsLibrary alloc] init];
    self.alredaySelectArray = [@{}mutableCopy];
    
    self.tabBar=(TRTabBarViewController *)self.tabBarController;
    self.tabBar.delegate=self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:SERVICE_NAME_DIRECTORY object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:SERVICE_NAME_PRODUCT object:nil];
    
    _section = 1;
    self.collectionViewDictByName = [NSMutableDictionary dictionary];
    self.count = 0;
    [self initNavigation];
    [self layoutScrollView];
    [self showChooseView];
    [self showSaveActionView];
    [self.weChatNavigationBar.titleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
 
    //搜索框
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TRSearchView" owner:self options:nil];
    self.searchView = nibObjects[0];
    self.searchView.bottom = self.weChatNavigationBar.bottom;
    self.searchView.height = self.weChatNavigationBar.height;
//    self.view.alpha = 1;
    [self.view addSubview:self.searchView];
    
    self.searchView.hidden=YES;
    
    
    [self.searchView.cancelBtn addTarget:self action:@selector(hideSearchView:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView.searBtn addTarget:self action:@selector(searchResult:) forControlEvents:UIControlEventTouchUpInside];
    
//    TRTabBarViewController * tabVC =(TRTabBarViewController*) self.tabBarController;
//    tabVC.hidesBottomBarWhenPushed=YES;
}

-(void)showSaveActionView{

   
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TRActionView" owner:self options:nil];
    self.p_actionView = [nibObjects objectAtIndex:0];
    self.p_actionView.hidden = YES;
    
    self.p_actionView.bottom = self.tabBarController.tabBar.bottom;
    self.p_actionView.height = self.tabBarController.tabBar.height;
//加载在屏幕
    [ApplicationDelegate.window addSubview:self.p_actionView];
    
    
    
    [self.p_actionView.saveBtn addTarget:self action:@selector(downImageToAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.p_actionView.collBtn addTarget:self action:@selector(myCollection) forControlEvents:UIControlEventTouchUpInside];
    
    
    

}


- (void)initNavigation
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.weChatNavigationBar=[[WeChatNavigationBar alloc] init];
    [self.view addSubview:self.weChatNavigationBar];
    self.weChatNavigationBar.titleLabel.text=@"";
    self.weChatNavigationBar.rightButton.left=230;
    
    [self.weChatNavigationBar.rightButton addTarget:self action:@selector(downImageToAlbum) forControlEvents:UIControlEventTouchUpInside];
    self.chooseBtn=[[UIButton alloc] initWithFrame:CGRectMake(260, 27, 30, 30)];
    self.chooseBtn.left=self.weChatNavigationBar.rightButton.right+10;
    [self.chooseBtn setImage:[UIImage imageNamed:@"选择"] forState:0];
   // self.chooseBtn.hidden=YES;
    [self.weChatNavigationBar addSubview:self.chooseBtn];
    self.weChatNavigationBar.rightButton.hidden=YES;
    [self.chooseBtn addTarget:self action:@selector(hidenChooseView) forControlEvents:UIControlEventTouchUpInside];
    
 
    
    
    //搜索框
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TRSearchView" owner:self options:nil];
    self.searchView = nibObjects[0];

    self.searchView.bottom = self.weChatNavigationBar.bottom;
   
    [ApplicationDelegate.window addSubview:self.searchView];
    self.view.backgroundColor = [UIColor blackColor];
    self.searchView.hidden=YES;
    
    
    [self.searchView.cancelBtn addTarget:self action:@selector(hideSearchView:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView.searBtn addTarget:self action:@selector(searchResult:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    [self.weChatNavigationBar.rightButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
   
}
-(void)searchResult:(UIButton *)btn{


    [self performSegueWithIdentifier:@"tosearchVC" sender:nil];
}


-(void)search:(UIButton *)btn{
   
    self.searchView.hidden = !self.searchView.hidden;

    

}
-(void)hideSearchView:(UIButton *)btn{

    btn.superview.hidden = !btn.superview.hidden;
    
    

}
-(void)showChooseView
{

    self.chooseView=[[TRBar alloc] init];
    [self.chooseView.leftButton setTitle:@"取消" forState:0];
    self.chooseView.titleLabel.text=@"请选择";
    [self.chooseView.rightButton setTitle:@"全选" forState:0];
    self.chooseView.frame=self.weChatNavigationBar.bounds;
    [self.weChatNavigationBar addSubview:self.chooseView];
    
    self.chooseView.hidden = YES;
    [self.chooseView.leftButton addTarget:self action:@selector(hidenChooseView) forControlEvents:UIControlEventTouchUpInside];

     [self.chooseView.rightButton addTarget:self action:@selector(quanxuan) forControlEvents:UIControlEventTouchUpInside];

    
}

-(void)myCollection{
    NSMutableArray * selectArray = [@[]mutableCopy];
    
    for (NSDictionary * idDict in self.currentArray) {
        if ([[self.alredaySelectArray objectForKey:[NSString stringWithFormat:@"%@",idDict[@"ID"]]] boolValue]) {
//            [self.alredaySelectArray setObject:@NO forKey:[NSString stringWithFormat:@"%@",idDict[@"ID"]]];
            [selectArray addObject:idDict[@"ID"]];
            
        }
    }
    
    
    
    NSString * collectString = [ApplicationDelegate.udpClientSocket
                                createXmlProductUserName:ApplicationDelegate.userName
                                productTypeId:selectArray
                                serviceName:SERVICE_NAME_PRODUCT
                                serviceType:SERVICE_TYPE_PRODUCT
                                serviceCode:[NSString stringWithFormat:@"%d",DirectoryAddCollection]];
    
    [ApplicationDelegate.udpClientSocket sendMessage:collectString];

}
-(void)quanxuan{
   
    
  
    for (int n=0; n<self.currentArray.count; n++) {

        [self.alredaySelectArray setObject:@YES forKey:[NSString stringWithFormat:@"%@",self.currentArray[n][@"ID"]]];
       
    }

    [[self getCurrentCollectionView] reloadData];


   
}

-(void)reflushColl{
_section = 1;
[[self getCurrentCollectionView] reloadData];

}
-(void)hidenChooseView
{
    
    
    if (self.chooseView.hidden) {
        self.chooseView.hidden=NO;
    }else{
        self.chooseView.hidden= YES;
        [self.alredaySelectArray removeAllObjects];
    }
    self.p_actionView.hidden = self.chooseView.hidden;
    [self getCurrentCollectionView].allowsMultipleSelection = !self.chooseView.hidden;
    
    
  
   
    for (int n=0; n<self.currentArray.count; n++) {
        
        [self.alredaySelectArray setObject:@NO forKey:[NSString stringWithFormat:@"%@",self.currentArray[n][@"ID"]]];
        
    }
    
    [[self getCurrentCollectionView] reloadData];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    NSArray * goods = self.goodsListDictByName[self.weChatNavigationBar.titleLabel.text][[NSString stringWithFormat:@"%@&&PACKAGE_RSP",self.weChatNavigationBar.titleLabel.text]][@"PACKAGE"];
    if (![self.weChatNavigationBar.titleLabel.text isEqualToString:@"商品列表"]&&!goods) {
//         self.weChatNavigationBar.rightButton.hidden = NO;
//        self.weChatNavigationBar.rightButton2.hidden = NO;
        
        
        //类型查询
       
    }else{
//        self.weChatNavigationBar.rightButton.hidden = YES;
//    self.weChatNavigationBar.rightButton2.hidden = YES;
    }
    
}
-(void)dealloc{

[[NSNotificationCenter defaultCenter] removeObserver:self name:SERVICE_NAME_DIRECTORY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SERVICE_NAME_PRODUCT object:nil];
    [self.weChatNavigationBar.titleLabel removeObserver:self forKeyPath:@"text"];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
}
-(void)receiveMessage:(NSNotification*)nofi{
//    NSLog(@"%@",[NSString replaceUnicode:nofi.userInfo.description]);
    NSString * message = nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"MESSAGE"];
    if ([nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"CODE"] isEqualToString:@"0000"]) {
         //    SERVICE_CODE：1001：类型查询 1002：下载排行榜 1003:收藏夹 1004:添加收藏1005取消收藏  1008 上传目录 1009：品牌列表 1010:商品列表3006 产品推送 1011 海报 1012收藏排行榜 1013分享排行榜 1014一键分享
        DirectorySelect service_code = [nofi.userInfo[@"HEAD"][@"SERVICE_CODE"] intValue];
        switch (service_code) {
            case DirectorySearch://1001 类型查询
            {
                self.goodsArray = nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"];
                
                //初始化
                //首次登录
                if (self.count++==0) {

                }
               
                NSMutableArray* array;
                if (!self.goodsListDictByName) {
                self.goodsListDictByName = [NSMutableDictionary dictionary];
                    array = [NSMutableArray array];
                    for (int n=0 ; n< self.goodsArray.count;n++) {
                        [array addObject:self.goodsArray[n][@"ID"]];
                        NSMutableDictionary * goodsList = [NSMutableDictionary dictionaryWithDictionary:self.goodsArray[n]];
                        //字典结构：ID，NAME，女包&&PACKAGE_RSP{@[],page_info}
                        
                        [goodsList setObject:@{} forKey:[NSString stringWithFormat:@"%@&&PACKAGE_RSP",self.goodsArray[n][@"NAME"]]];
                        [self.goodsListDictByName setObject:goodsList forKey:self.goodsArray[n][@"NAME"]];
                        
                        
                        
                    }
                    
                }
                
               
                
                
            //更新每一个栏目,2219,更新全部 ,更新当前标题下的数据，除了商品列表
                if (![self.weChatNavigationBar.titleLabel.text isEqualToString:@"商品列表"]) {
                    
                    NSLog(@"请求第%d页数据",self.pageNum);
                     [self updateString:DirectoryGoods andPage:1 andIDs:@[self.goodsListDictByName[self.weChatNavigationBar.titleLabel.text][@"ID"]]];
                }
//                [MMProgressHUD dismissWithSuccess:message];
                
            }
                break;
            case DirectoryDownload:
                break;
            case  DirectoryCollection:
                break;
            case  DirectoryAddCollection:
//                [MMProgressHUD showWithStatus:@"收藏成功"];
                MMProgressHUDShowSuccess(@"收藏成功");
                
                
                break;
            case  DirectoryDelCollection:
                break;
            case  DirectoryUpload://1008
                break;
            case  DirectoryFamousBrands:
                break;
            case   DirectoryGoods:  //商品列表 1010
            {
            //商品列表详情
                if (![self.weChatNavigationBar.titleLabel.text isEqualToString:@"商品列表"]) {
                    NSMutableDictionary * package_rsp = [NSMutableDictionary dictionaryWithDictionary:nofi.userInfo[@"BODY"][@"PACKAGE_RSP"]];
                    
                    //提取第一个dict
                    NSMutableDictionary * new_goodsDict = [NSMutableDictionary dictionaryWithDictionary:self.goodsListDictByName[self.weChatNavigationBar.titleLabel.text]];
                    
                    //把描述添加进去
                    [package_rsp setObject:nofi.userInfo[@"BODY"][@"PAGE_INFO"] forKey:@"PAGE_INFO"];
                    
                    NSDictionary * name_PACKAGE_RSP = self.goodsListDictByName[self.weChatNavigationBar.titleLabel.text][[NSString stringWithFormat:@"%@&&PACKAGE_RSP",self.weChatNavigationBar.titleLabel.text]];
                    
                    if (name_PACKAGE_RSP.count>0) {
                        NSMutableDictionary * new_new_goodsDict = [NSMutableDictionary dictionaryWithDictionary:name_PACKAGE_RSP];
                        
                        
                        NSMutableArray * new_package_rsp = [NSMutableArray arrayWithArray:new_new_goodsDict[@"PACKAGE"]];
                        
                        
                        [new_package_rsp addObjectsFromArray:package_rsp[@"PACKAGE"]];
                        
                        
                        //代替package
                        [new_new_goodsDict setObject:new_package_rsp forKey:@"PACKAGE"];
                        
                        package_rsp = new_new_goodsDict;
                        
                        
                    }else{
                        //最里面要修改的内容加进去，不是数组而是字典
                       
                    }
                    
                    [new_goodsDict setObject:package_rsp forKey:[NSString stringWithFormat:@"%@&&PACKAGE_RSP",self.weChatNavigationBar.titleLabel.text]];
                    [self.goodsListDictByName setObject:new_goodsDict forKey:self.weChatNavigationBar.titleLabel.text];
                   
                    
//                    NSLog(@"当前的列别：%@",[NSString replaceUnicode:self.goodsListDictByName.description]);
                    
                    
                    
                    
                    self.currentCollectionView = (PullCollectionView *)self.collectionViewDictByName[self.weChatNavigationBar.titleLabel.text];
                    
                    
                    [NSStandardUserDefaults setObject:self.goodsListDictByName forKey:@"缓存商品数据"];
                    [NSStandardUserDefaults synchronize];
                    
                    [self getCurrentCollectionView].pullTableIsRefreshing= NO;
                    [self getCurrentCollectionView].pullTableIsLoadingMore= NO;
                    
                    
                    
                    [self.currentCollectionView reloadData];

                    
                }
            
            }
                
                break;
            case  DirectoryPoster:
            {
                //接收数据
                self.haibaoArray = nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"];

                if (self.haibaoArray.count>0) {
                    //滚动海报
                    for (UIView * v in smallScroll.subviews) {
                        if ([v isMemberOfClass:[OLImageView class]]) {
                            OLImageView * olIV = (OLImageView*)v;
                            [olIV setImageWithURL:[NSURL URLWithString:self.haibaoArray[0][@"THUMBNAIL_URL"]] placeholderImage:ApplicationDelegate.loadingImage];
                        }
                    }


                    int m = 0;
                    for (int n=0; n< self.homeScrollView.subviews.count; n++) {

                        UIView * v =  self.homeScrollView.subviews[n];
                        if ([v isMemberOfClass:[PlayBillView class]]) {
                            PlayBillView * haibaoIv = (PlayBillView *)v;
                            //THUMBNAIL_URL
                            //6张图片，其实应该有八张
                            NSURL * url = [NSURL URLWithString:self.haibaoArray[m++%self.homeScrollView.subviews.count+1][@"THUMBNAIL_URL"]];
                            NSLog(@"第%d个海报：%@",m,url);


                            
                            //首页数据，海报
                            [haibaoIv setImageWithURL:url placeholderImage:ApplicationDelegate.loadingImage];
                            haibaoIv.title = self.haibaoArray[n+1][@"DESCRIPTION"];
                        }
                    }
                }
            
            }
                break;
            case  DirectoryCollectionBillboard:
                break;
            case  DirectoryShareBillboard:
                break;
            case DirectoryShare:
                break;
            case DirectoryPush://3306
            {
                NSLog(@"3306");
            
            }
                break;
                
            case DirectoryOneKeyShare://2002
            {
                NSLog(@"2002");
                
                [MMProgressHUD showWithTitle:@"" status:@"相片保存中…" cancelBlock:^{}];

                for (NSDictionary * albumDict in nofi.userInfo[@"BODY"][@"PRODUCT_RSP"][@"PRODUCT_PIC"]) {
                    
             
                
                NSURL *url = [NSURL URLWithString:albumDict[@"PIC_URL"]];
                
                dispatch_queue_t queue =dispatch_queue_create("loadImage",NULL);
                dispatch_async(queue, ^{
                    
                    NSData *resultData = [NSData dataWithContentsOfURL:url];
                    UIImage *img = [UIImage imageWithData:resultData];
                    
                //下面是保存的,保存不放在这里，放在接收数据的那边NAME
                    [self.library saveImage:img toAlbum:nofi.userInfo[@"BODY"][@"PRODUCT_RSP"][@"PRODUCT_INFO"][@"NAME"] withCompletionBlock:^(NSError *error) {

                        if (error!=nil) {
                             [MMProgressHUD dismissWithError:@"失败"];
                            NSLog(@"Big error: %@", [error description]);
                            return;
                        }
                        
//                        MMProgressHUDShowSuccess(@"成功");
                        [MMProgressHUD dismissWithSuccess:@"成功"];
                        
                    }];
                            dispatch_sync(dispatch_get_main_queue(), ^{
       
                            });
                            
                    });
                
                }
                
//                 [MMProgressHUD dismissWithSuccess:@""];
               
            }
                break;
        }
        
        
       
    }else{
//        [MMProgressHUD dismissWithError:message];
    }
    
//    [self getCurrentCollectionView].pullTableIsRefreshing = NO;
//  [self getCurrentCollectionView].pullTableIsLoadingMore = NO;
}

-(void)reloadCollectionView{

    for (UIView * v in _Bigscroll.subviews) {
        if ([v isMemberOfClass:[PullCollectionView class]]) {
            PullCollectionView * collectionV= (PullCollectionView *)v;
            [collectionV reloadData];
        }
    }
    

}
-(void)updateGoodsMemu{
//18688859030
    
    /**
     *SERVICE_TYPE:1
     *SERVICE_CODE：1001：类型查询 1002：下载排行榜 1003:收藏夹 1004:添加收藏1005取消收藏  1008 上传目录 1009：品牌列表 1010:商品列表3006 产品推送 1011 海报 1012收藏排行榜 1013分享排行榜 1014一键分享
     */
    
    //更新海报
    [self updateString:DirectoryPoster andPage:1 andIDs:nil];
  
    
}



-(void)updateString:(DirectorySelect)diret andPage:(int)pageNum andIDs:(NSArray*)ids{
    NSString *  sendMessage = [ApplicationDelegate.udpClientSocket
                               createXmlDirectoryUserName:ApplicationDelegate.userName
                               orderField:DIR_ORDER_FIELD_CREATEDATE
                               orderDirection:DIR_ORDER_DIRECTION_ASC
                               ids:ids
                               brandIds:nil
                               pageNum:[NSString stringWithFormat:@"%d",pageNum]
                               serviceName:SERVICE_NAME_DIRECTORY
                               serviceType:SERVICE_TYPE_DIRECTORY
                               serviceCode:[NSString stringWithFormat:@"%d",diret]];
    
    [ApplicationDelegate.udpClientSocket sendMessage:sendMessage];
    
    
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MMProgressHUD showWithTitle:@"" status:@"下载中…" cancelBlock:^{}];

}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;

}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.Bigscroll.contentOffset = CGPointMake(0, 0);
    self.Bigscroll.contentOffset=self.currentSet;
    [self updateGoodsMemu];
    
    
    TRTabBarViewController * tabVC =(TRTabBarViewController*) self.tabBarController;
    
    self.tabBarController.tabBar.hidden =NO;
    tabVC.customTabBarView.hidden = NO;

}

#pragma mark 菜单栏 delegate
- (void)menuViewDidSelecte:(NSInteger) index
{
   

   self.currentSet=CGPointMake(320+320*index, 0);
}

-(void)setCurrentSet:(CGPoint)currentSet
{
    _currentSet=currentSet;
   
    TRTabBarViewController * tabVC = (TRTabBarViewController*)self.tabBarController;
    
    tabVC.menuView.hidden = YES;
    //切换列表
    
    
    if (currentSet.x==320*0) {
        self.weChatNavigationBar.titleLabel.text=@"";
         self.weChatNavigationBar.rightButton.hidden = YES;
    }else{
         self.weChatNavigationBar.rightButton.hidden = NO;
         [self updateString:DirectorySearch andPage:1 andIDs:nil];
        
        
        
        
    if (currentSet.x==320*1) {
        self.weChatNavigationBar.titleLabel.text=@"女包";
    }
    if (currentSet.x==320*2) {
        self.weChatNavigationBar.titleLabel.text=@"男包";
    }
    if (currentSet.x==320*3) {
        self.weChatNavigationBar.titleLabel.text=@"服装";
    }
    if (currentSet.x==320*4) {
        self.weChatNavigationBar.titleLabel.text=@"鞋子";
    }
    if (currentSet.x==320*5) {
        self.weChatNavigationBar.titleLabel.text=@"手表";
    }
    if (currentSet.x==320*6) {
        self.weChatNavigationBar.titleLabel.text=@"皮带";
    }
    if (currentSet.x==320*7) {
        self.weChatNavigationBar.titleLabel.text=@"钱夹";
    }
    if (currentSet.x==320*8) {
        self.weChatNavigationBar.titleLabel.text=@"丝巾饰品";
    }
    if (currentSet.x==320*9) {
        self.weChatNavigationBar.titleLabel.text=@"眼镜";
    }

    }
   [self.view insertSubview:self.searchView atIndex:1000];
     [_Bigscroll setContentOffset:_currentSet animated:YES];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint targetContentOffset = scrollView.contentOffset;
    
    if (targetContentOffset.y==0) {
        
   
    if (targetContentOffset.x==320*0) {
        
        self.weChatNavigationBar.titleLabel.text=@"";
        
        self.weChatNavigationBar.rightButton.hidden = YES;
    }else{
        
        
         [self updateString:DirectorySearch andPage:1 andIDs:nil];
        
        self.weChatNavigationBar.rightButton.hidden = NO;
    if (targetContentOffset.x==320*1) {
        
        self.weChatNavigationBar.titleLabel.text=@"女包";
        
    }
    if (targetContentOffset.x==320*2) {
        self.weChatNavigationBar.titleLabel.text=@"男包";
    }
    if (targetContentOffset.x==320*3) {
        self.weChatNavigationBar.titleLabel.text=@"服装";
    }
    if (targetContentOffset.x==320*4) {
        self.weChatNavigationBar.titleLabel.text=@"鞋子";
    }
    if (targetContentOffset.x==320*5) {
        self.weChatNavigationBar.titleLabel.text=@"手表";
    }
    if (targetContentOffset.x==320*6) {
        self.weChatNavigationBar.titleLabel.text=@"皮带";
    }
    if (targetContentOffset.x==320*7) {
        self.weChatNavigationBar.titleLabel.text=@"钱夹";
    }
    if (targetContentOffset.x==320*8) {
        self.weChatNavigationBar.titleLabel.text=@"丝巾饰品";
    }
    if (targetContentOffset.x==320*9) {
        self.weChatNavigationBar.titleLabel.text=@"眼镜";
    }
    }
    
         }
    TRTabBarViewController * tabVC = (TRTabBarViewController*)self.tabBarController;
    
    tabVC.menuView.hidden = YES;


}     // called when scroll view grinds to a halt





-(void)jumptoXiangqing:(UITapGestureRecognizer*)tap{
    UIView * v = tap.view;
    //从下标记为1开始
    if (self.haibaoArray[v.tag][@"ID"]) {
        TRGoodsViewController * goodVc = [self.storyboard instantiateViewControllerWithIdentifier:@"TRGoodsViewController"];
        goodVc.productTypeId = self.haibaoArray[v.tag][@"ID"];
//        goodVc.productTypeId = @"1111";
        [self.navigationController pushViewController:goodVc animated:YES];
    }
    
    

}
#pragma 设置scrollview
-(void)layoutScrollView{
    NSArray *arr=@[@"ad01.png",@"ad04.png",@"ad05.png"];
    //大的scrollview
    _Bigscroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 61, self.view.frame.size.width, self.view.bounds.size.height-87)];
    _Bigscroll.contentSize=CGSizeMake(self.view.frame.size.width*10, self.view.bounds.size.height-87);//0设置禁止垂直滚动
    _Bigscroll.pagingEnabled=YES;
    _Bigscroll.delegate=self;
    
    //小海报头
    smallScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 136)];
    smallScroll.pagingEnabled=YES;
    smallScroll.contentSize=CGSizeMake(self.view.frame.size.width*3, 136);
    for (int i=0; i<3; i++) {
        OLImageView *SamllImageView=[[OLImageView alloc]initWithFrame:CGRectMake(smallScroll.frame.size.width*i, 0, smallScroll.frame.size.width, smallScroll.frame.size.height)];
       // SamllImageView.image=[UIImage imageNamed:arr[i]];
        SamllImageView.backgroundColor = [UIColor blackColor];
        SamllImageView.contentMode = UIViewContentModeScaleToFill;
        SamllImageView.clipsToBounds = YES;
//        SamllImageView.tag = 1;
        SamllImageView.userInteractionEnabled = YES;
        [smallScroll addSubview:SamllImageView];
        //大海报没有事件
       // UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumptoXiangqing:)];
        //[SamllImageView addGestureRecognizer:tap];
    }
    
    smallScroll.showsHorizontalScrollIndicator=NO;
    _Bigscroll.showsHorizontalScrollIndicator=NO;
    _Bigscroll.showsVerticalScrollIndicator=NO;
    _Bigscroll.backgroundColor = [UIColor blackColor];
    [_Bigscroll addSubview:smallScroll];
    [self.view addSubview:_Bigscroll];
  //  [self.view insertSubview:_Bigscroll belowSubview:self.tabBarView];
    //下面的六张图片
    //下面的六张图片
    //海报
    
   
    self.homeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, smallScroll.bottom, 320, _Bigscroll.height-smallScroll.height)];
     self.homeScrollView.backgroundColor = [UIColor blackColor];
    
    self.homeScrollView.showsHorizontalScrollIndicator=NO;
    self.homeScrollView.showsHorizontalScrollIndicator=NO;
    self.homeScrollView.showsVerticalScrollIndicator=NO;
    
    self.homeScrollView.contentSize = CGSizeMake(320, (self.view.width-10)/2. * 4 +5*4);
    self.homeScrollView.scrollEnabled = YES;
    [_Bigscroll addSubview: self.homeScrollView];
    for (int i=0; i<8; i++) {

       
         
         NSInteger index              = i % 2;
         NSInteger page               = i / 2;
         NSInteger imageView_width    = (self.view.width-2)/2.;
         NSInteger imageView_Height   = imageView_width;
         NSInteger Width_Space        = 2.5;
         NSInteger Height_Space       = 2.5;
         NSInteger Start_X            = 0;
         NSInteger Start_Y            = 5;
         
       
        PlayBillView *playBill=[[PlayBillView alloc]initWithFrame:CGRectMake(index * (imageView_width + Width_Space) + Start_X, page  * (imageView_Height + Height_Space)+Start_Y, imageView_width, imageView_Height)];
        playBill.backgroundColor=[UIColor whiteColor];
        
        
        
        playBill.contentMode = UIViewContentModeScaleAspectFill;
        playBill.clipsToBounds = YES;
        [ self.homeScrollView addSubview:playBill];
        playBill.layer.borderWidth=2;
        playBill.layer.borderColor=[UIColor blackColor].CGColor;
        
        //加载图片url
        
        //触发跳转
        playBill.tag=i+1;
        playBill.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumptoXiangqing:)];
        [playBill addGestureRecognizer:tap];
        
    }
    
    

    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(158.5, 156);
    layout.minimumInteritemSpacing=1;
    layout.minimumLineSpacing=2;
    
    //女包
    self.ladyBag=[[PullCollectionView alloc] initWithFrame:CGRectMake(_Bigscroll.frame.size.width, 0, _Bigscroll.frame.size.width, _Bigscroll.frame.size.height) collectionViewLayout:layout];
    
    self.ladyBag.tag = 1;
    self.ladyBag.dataSource=self;
    self.ladyBag.delegate=self;
    self.ladyBag.pullDelegate = self;
    
   
    //    pullCollectionView.pullArrowImage = [UIImage imageNamed:@"grayArrow"];
    self.ladyBag.pullBackgroundColor = [UIColor blackColor];
    self.ladyBag.pullTextColor = [UIColor whiteColor];
//    [self.ladyBag configWithRefresh:NO AndWithLoadMore:NO];
    [self.ladyBag registerNib:[UINib nibWithNibName:@"TRMemuCell" bundle:nil] forCellWithReuseIdentifier:@"TRMemuCell"];
    [_Bigscroll addSubview:self.ladyBag];
    //男包
    self.manBag=[[PullCollectionView alloc] initWithFrame:CGRectMake(_Bigscroll.frame.size.width*2, 0, _Bigscroll.frame.size.width, _Bigscroll.frame.size.height) collectionViewLayout:layout];
    self.manBag.tag = 2;
    self.manBag.dataSource=self;
    self.manBag.delegate=self;
    self.manBag.pullDelegate = self;
    
    self.manBag.pullBackgroundColor = [UIColor blackColor];
    self.manBag.pullTextColor = [UIColor whiteColor];
    [self.manBag registerNib:[UINib nibWithNibName:@"TRMemuCell" bundle:nil] forCellWithReuseIdentifier:@"TRMemuCell"];
    [_Bigscroll addSubview:self.manBag];
    //衣服
    self.clothing=[[PullCollectionView alloc] initWithFrame:CGRectMake(_Bigscroll.frame.size.width*3, 0, _Bigscroll.frame.size.width, _Bigscroll.frame.size.height) collectionViewLayout:layout];
    self.clothing.tag = 3;
    self.clothing.dataSource=self;
    self.clothing.delegate=self;
    self.clothing.pullDelegate = self;
    self.clothing.pullBackgroundColor = [UIColor blackColor];
    self.clothing.pullTextColor = [UIColor whiteColor];
    [self.clothing registerNib:[UINib nibWithNibName:@"TRMemuCell" bundle:nil] forCellWithReuseIdentifier:@"TRMemuCell"];
    [_Bigscroll addSubview:self.clothing];
    //鞋子
    self.shoe=[[PullCollectionView alloc] initWithFrame:CGRectMake(_Bigscroll.frame.size.width*4, 0, _Bigscroll.frame.size.width, _Bigscroll.frame.size.height) collectionViewLayout:layout];
    self.shoe.tag = 4;
    self.shoe.dataSource=self;
    self.shoe.delegate=self;
    self.shoe.pullDelegate = self;
    self.shoe.pullBackgroundColor = [UIColor blackColor];
    self.shoe.pullTextColor = [UIColor whiteColor];
    [self.shoe registerNib:[UINib nibWithNibName:@"TRMemuCell" bundle:nil] forCellWithReuseIdentifier:@"TRMemuCell"];
    [_Bigscroll addSubview:self.shoe];
    
    self.Watch=[[PullCollectionView alloc] initWithFrame:CGRectMake(_Bigscroll.frame.size.width*5, 0, _Bigscroll.frame.size.width, _Bigscroll.frame.size.height) collectionViewLayout:layout];
    self.Watch.tag = 5;
    self.Watch.dataSource=self;
    self.Watch.delegate=self;
    self.Watch.pullDelegate = self;
    self.Watch.pullBackgroundColor = [UIColor blackColor];
    self.Watch.pullTextColor = [UIColor whiteColor];
    [self.Watch registerNib:[UINib nibWithNibName:@"TRMemuCell" bundle:nil] forCellWithReuseIdentifier:@"TRMemuCell"];
    [_Bigscroll addSubview:self.Watch];
    
    self.belt=[[PullCollectionView alloc] initWithFrame:CGRectMake(_Bigscroll.frame.size.width*6, 0, _Bigscroll.frame.size.width, _Bigscroll.frame.size.height) collectionViewLayout:layout];
    self.belt.tag = 6;
    self.belt.dataSource=self;
    self.belt.delegate=self;
    self.belt.pullDelegate = self;
    self.belt.pullBackgroundColor = [UIColor blackColor];
    self.belt.pullTextColor = [UIColor whiteColor];
    [self.belt registerNib:[UINib nibWithNibName:@"TRMemuCell" bundle:nil] forCellWithReuseIdentifier:@"TRMemuCell"];
    [_Bigscroll addSubview:self.belt];
    
    self.wallet=[[PullCollectionView alloc] initWithFrame:CGRectMake(_Bigscroll.frame.size.width*7, 0, _Bigscroll.frame.size.width, _Bigscroll.frame.size.height) collectionViewLayout:layout];
    
    self.wallet.tag = 7;
    self.wallet.dataSource=self;
    self.wallet.delegate=self;
    self.wallet.pullDelegate = self;
    self.wallet.pullBackgroundColor = [UIColor blackColor];
    self.wallet.pullTextColor = [UIColor whiteColor];

    [self.wallet registerNib:[UINib nibWithNibName:@"TRMemuCell" bundle:nil] forCellWithReuseIdentifier:@"TRMemuCell"];
    [_Bigscroll addSubview:self.wallet];
    
    self.ornament=[[PullCollectionView alloc] initWithFrame:CGRectMake(_Bigscroll.frame.size.width*8, 0, _Bigscroll.frame.size.width, _Bigscroll.frame.size.height) collectionViewLayout:layout];
    self.ornament.tag = 8;
    self.ornament.dataSource=self;
    self.ornament.delegate=self;
    self.ornament.pullDelegate = self;
    self.ornament.pullBackgroundColor = [UIColor blackColor];
    self.ornament.pullTextColor = [UIColor whiteColor];
    [self.ornament registerNib:[UINib nibWithNibName:@"TRMemuCell" bundle:nil] forCellWithReuseIdentifier:@"TRMemuCell"];
    [_Bigscroll addSubview:self.ornament];
    
    self.glasses=[[PullCollectionView alloc] initWithFrame:CGRectMake(_Bigscroll.frame.size.width*9, 0, _Bigscroll.frame.size.width, _Bigscroll.frame.size.height) collectionViewLayout:layout];
    self.glasses.tag = 9;
    self.glasses.dataSource=self;
    self.glasses.delegate=self;
    self.glasses.pullDelegate = self;
    self.glasses.pullBackgroundColor = [UIColor blackColor];
    self.glasses.pullTextColor = [UIColor whiteColor];
    [self.glasses registerNib:[UINib nibWithNibName:@"TRMemuCell" bundle:nil] forCellWithReuseIdentifier:@"TRMemuCell"];
    [_Bigscroll addSubview:self.glasses];
    
       self.collectionViewDictByName = [@{
                                       @"女包":_ladyBag,
                                       @"男包":_manBag,
                                       @"服装":_clothing,
                                       @"鞋子":_shoe,
                                       @"手表":_Watch,
                                       @"皮带":_belt,
                                       @"钱夹":_wallet,
                                       @"丝巾饰品":_ornament,
                                       @"眼镜":_glasses
                                       } mutableCopy];
    
    
    for (int i=0; i<6; i++) {
    //  PullCollectionView
        

    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return _section;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
/*
 "女包" =     {
 ID = 2218;
 NAME = "女包";
 "女包&&PACKAGE_RSP" =         {
             PACKAGE =             (
             {
             ID = 6663;
             NAME = "DG3270黑色";
             "THUMBNAIL_URL" = "http://www.op89.com:8080/test/getIcoUrl?type=2&&id=6663";
             },
             {
             ID = 6662;
             NAME = "60533-7";
             "THUMBNAIL_URL" = "http://www.op89.com:8080/test/getIcoUrl?type=2&&id=6662";
             },
             {
             ID = 6661;
             NAME = "9902黑色";
             "THUMBNAIL_URL" = "http://www.op89.com:8080/test/getIcoUrl?type=2&&id=6661";
             },
             {
             ID = 6660;
             NAME = "39256901淡紫";
             "THUMBNAIL_URL" = "http://www.op89.com:8080/test/getIcoUrl?type=2&&id=6660";
             },
             {
             ID = 6643;
             NAME = "M41046紫丁香";
             "THUMBNAIL_URL" = "http://www.op89.com:8080/test/getIcoUrl?type=2&&id=6643";
             },
             {
             ID = 6644;
             NAME = "M9462红色";
             "THUMBNAIL_URL" = "http://www.op89.com:8080/test/getIcoUrl?type=2&&id=6644";
             }
             );
             "PAGE_INFO" =             {
             COUNT = 1446;
             NEXT = 2;
             NUMBER = 1;
             PAGES = 241;
             };
 };
 };
 
 */
    //多选
    
    
    self.currentArray = self.goodsListDictByName[self.weChatNavigationBar.titleLabel.text][[NSString stringWithFormat:@"%@&&PACKAGE_RSP",self.weChatNavigationBar.titleLabel.text]][@"PACKAGE"];
    
    
    for (NSDictionary * idDict in self.currentArray) {
        if (![self.alredaySelectArray objectForKey:[NSString stringWithFormat:@"%@",idDict[@"ID"]]]) {
            [self.alredaySelectArray setObject:@NO forKey:[NSString stringWithFormat:@"%@",idDict[@"ID"]]];

        }
    }
//    return 13;
    return self.currentArray.count;

}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray * goods = self.currentArray;
    
    TRMemuCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"TRMemuCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor grayColor];
    cell.imageView.image = [UIImage imageNamed:@"1"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:goods[indexPath.row][@"THUMBNAIL_URL"]] placeholderImage:ApplicationDelegate.loadingImage];
    cell.nameLabel.text=goods[indexPath.row][@"NAME"];
   

    cell.selectImageView.hidden = self.chooseView.hidden;
//    NSLog(@"隐藏不：%d",cell.selectImageView.hidden);
    if ([[self.alredaySelectArray objectForKey:[NSString stringWithFormat:@"%@",self.currentArray[indexPath.row][@"ID"]]] boolValue]) {

        
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        //狠奇怪，要在这里触发事件
        cell.selected=YES;
//        [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
   
    
    return cell;

}






-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.chooseView.hidden) {
        if (self.currentArray.count>indexPath.row) {
             [self performSegueWithIdentifier:@"toGoods" sender:indexPath];
        }
        
       

    }else{
    
    
   
        
        [self.alredaySelectArray setObject:@YES forKey:[NSString stringWithFormat:@"%@",self.currentArray[indexPath.row][@"ID"]]];
        
        
       
    }
    
   
    
    
    
    
  //  [self prepareForSegue:@"toGoods" sender:nil];
    
}
/*Cell已经选择时回调*/
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    
[self.alredaySelectArray setObject:@NO forKey:[NSString stringWithFormat:@"%@",self.currentArray[indexPath.row][@"ID"]]];
    
}
/*Cell未选择时回调*/
//-(void)selectCellForCollectionView:(UICollectionView*)collection atIndexPath:(NSIndexPath*)indexPath
//{
//  if (!self.chooseView.hidden) {
//    
//    [collection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//    
//    [self collectionView:collection didSelectItemAtIndexPath:indexPath];
//  }
//}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"tosearchVC"]) {
        
    }else{
        self.currentArray = self.goodsListDictByName[self.weChatNavigationBar.titleLabel.text][[NSString stringWithFormat:@"%@&&PACKAGE_RSP",self.weChatNavigationBar.titleLabel.text]][@"PACKAGE"];
        NSIndexPath * indexPath = (NSIndexPath*)sender;
        
        
        TRGoodsViewController * goodVc = (TRGoodsViewController*)segue.destinationViewController;
        goodVc.productTypeId = self.currentArray[indexPath.row][@"ID"];
    
    }

    
}

-(PullCollectionView *)getCurrentCollectionView{

    PullCollectionView * collect;
   
    if ([self.weChatNavigationBar.titleLabel.text isEqualToString:@"女包"]) {
        
        collect = self.ladyBag;
        
    }
    if ([self.weChatNavigationBar.titleLabel.text isEqualToString:@"男包"]) {
        collect = self.manBag;
    }
    if ([self.weChatNavigationBar.titleLabel.text isEqualToString:@"服装"]) {
        collect = self.clothing;
    }
    if ([self.weChatNavigationBar.titleLabel.text isEqualToString:@"鞋子"]) {
        collect = self.shoe;
    }
    if ([self.weChatNavigationBar.titleLabel.text isEqualToString:@"手表"]) {
        collect = self.Watch;
    }
    if ([self.weChatNavigationBar.titleLabel.text isEqualToString:@"皮带"]) {
       collect = self.belt;
    }
    if ([self.weChatNavigationBar.titleLabel.text isEqualToString:@"钱夹"]) {
       collect = self.wallet ;
    }
    if ([self.weChatNavigationBar.titleLabel.text isEqualToString:@"丝巾饰品"]) {
        collect = self.ornament;
    }
    if ([self.weChatNavigationBar.titleLabel.text isEqualToString:@"眼镜"]) {
        collect = self.glasses;
    }
    
    

    return collect;
}

-(void)downImageToAlbum{

//    NSMutableArray * images = [@[]mutableCopy];
//    for (int n=0; n<self.currentArray.count; n++) {
//        PullCollectionView * coll = [self getCurrentCollectionView];
//       NSIndexPath * indexPath =  [NSIndexPath indexPathForRow:n inSection:0];
//        TRMemuCell * cell = (TRMemuCell *)[coll cellForItemAtIndexPath:indexPath];
//        if (cell.selected) {
////            [images addObject:cell.imageView.image];
////            UIImageWriteToSavedPhotosAlbum(cell.imageView.image, nil, nil,nil);
//            
//            /**
//             *
//             
//             
//            <?xml version='1.0' encoding='UTF-8' ?><MYAPP><HEAD><USER_NAME></USER_NAME><MAC>78:F7:BE:27:AD:09</MAC><SERVICE_NAME>product</SERVICE_NAME><SERVICE_TYPE>2</SERVICE_TYPE><SERVICE_CODE>2002</SERVICE_CODE><ACTION_CODE>0</ACTION_CODE><TIME_STAMP>20140723183722</TIME_STAMP><TIME_EXPIRE>20140723184222</TIME_EXPIRE><SERIAL_NUMBER></SERIAL_NUMBER></HEAD>
//             
//             <BODY><PRODUCT_REQ><ID>6925</ID></PRODUCT_REQ></BODY></MYAPP>
//
//             */
//            
//            NSString * sendString = [ApplicationDelegate.udpClientSocket
//                                     createXmlProductUserName:ApplicationDelegate.userName
//                                     productTypeId:@[self.currentArray[n][@"ID"]]
//                                     serviceName:SERVICE_NAME_PRODUCT
//                                     serviceType:SERVICE_TYPE_PRODUCT
//                                     serviceCode:@"2002"];
//            
//            
//            [ApplicationDelegate.udpClientSocket sendMessage:sendString];
//            
//            
//        }
//    }
    NSArray* allKeysArr = [self.alredaySelectArray allKeys];
    for(NSString* key in allKeysArr)
    {
        if ([self.alredaySelectArray[key] boolValue]) {
            NSString * sendString = [ApplicationDelegate.udpClientSocket
                                     createXmlProductUserName:ApplicationDelegate.userName
                                     productTypeId:@[key]
                                     serviceName:SERVICE_NAME_PRODUCT
                                     serviceType:SERVICE_TYPE_PRODUCT
                                     serviceCode:@"2002"];
            
            
            [ApplicationDelegate.udpClientSocket sendMessage:sendString];
        }
        
    }
    
    

}
@end
