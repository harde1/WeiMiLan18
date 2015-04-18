//
//  TRFamousViewController.m
//  WeiMiLan
//
//  Created by cong on 14-7-26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRFamousViewController.h"
#import "TRGoodsViewController.h"
#import "TRMemuCell.h"
#import "PullCollectionView.h"

#import "TRTabBarViewController.h"
@interface TRFamousViewController ()<PullCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet PullCollectionView *collectionView;
@property(nonatomic,assign)int  pageNum;

@property(nonatomic,strong)NSMutableArray * chongfuIDs;

@property(nonatomic,assign)NSInteger oldNum;
@end

@implementation TRFamousViewController

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
    self.collectionView.pullTableIsRefreshing=NO;
}

- (void)pullCollectionViewDidTriggerLoadMore:(PullCollectionView*)pullCollectionView{
    
    pullCollectionView.pullTableIsLoadingMore= YES;
    
    [self updataMyData:[NSString stringWithFormat:@"%d",self.pageNum++]];
}
-(void)receiveMessage:(NSNotification*)nofi{
    //    NSLog(@"%@",[NSString replaceUnicode:nofi.userInfo.description]);
    NSString * message = nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"MESSAGE"];
    if ([nofi.userInfo[@"HEAD"][@"SERVICE_CODE"] isEqualToString:[NSString stringWithFormat:@"%d",DirectoryGoods]]) {
    
    if ([nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"CODE"] isEqualToString:@"0000"]) {
        //    SERVICE_CODE：1001：类型查询 1002：下载排行榜 1003:收藏夹 1004:添加收藏1005取消收藏  1008 上传目录 1009：品牌列表 1010:商品列表3006 产品推送 1011 海报 1012收藏排行榜 1013分享排行榜 1014一键分享
        DirectorySelect service_code = [nofi.userInfo[@"HEAD"][@"SERVICE_CODE"] intValue];
    
        if (service_code == DirectoryGoods) {
            
            
            if (self.famousArray.count==0) {
                
                
                if ([nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"] isKindOfClass:[NSDictionary class]]) {
                    
                    [self.famousArray addObject:nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"]];
                    
                    
                }else{
                self.famousArray = [NSMutableArray arrayWithArray:nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"]];
                    
                   
                }

            }else{
                if ([nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"] isKindOfClass:[NSDictionary class]]) {
                    
                    if (![self.chongfuIDs containsObject:nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"][@"ID"]]) {
                         [self.famousArray addObject:nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"]];
                    }
                   
                    
                    
                }else{

                    
                    for (NSDictionary * famousDict in nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"]) {
                        
                        if (![self.chongfuIDs containsObject:famousDict[@"ID"]]) {
                            [self.famousArray addObject:famousDict];
                        }
                       
                    }
                    
                    
                }
            
            
            }
            
            for (NSDictionary * famousDict in self.famousArray) {
                if (![self.chongfuIDs containsObject:famousDict[@"ID"]]) {
                    [self.chongfuIDs addObject:famousDict[@"ID"]];
                }
                
            }
            
            
            self.collectionView.pullTableIsRefreshing = NO;
             self.collectionView.pullTableIsLoadingMore = NO;
            if (self.oldNum==self.famousArray.count) {
                MMProgressHUDShowError(@"已无更多");
            }
            [self.collectionView reloadData];

        }
        
        
        [MMProgressHUD dismissWithSuccess:message];
    }else{
        [MMProgressHUD dismissWithError:message];
    }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.chongfuIDs = [@[] mutableCopy];
    self.famousArray =[@[] mutableCopy];
    
    self.collectionView.pullDelegate = self;
    self.pageNum = 1;
    self.collectionView.pullBackgroundColor = [UIColor blackColor];
    self.collectionView.pullTextColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TRMemuCell" bundle:nil] forCellWithReuseIdentifier:@"TRMemuCell"];
    
    self.collectionView.clearsContextBeforeDrawing = YES;
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:SERVICE_NAME_DIRECTORY object:nil];
    
    //加产品，加请求
    [self updataMyData:[NSString stringWithFormat:@"%d",self.pageNum]];
    
    
    
     [self initNavigation];
}

-(void)updataMyData:(NSString *)num{
    NSString *  sendMessage = [ApplicationDelegate.udpClientSocket
                               createXmlDirectoryUserName:ApplicationDelegate.userName
                               orderField:DIR_ORDER_FIELD_CREATEDATE
                               orderDirection:DIR_ORDER_DIRECTION_ASC
                               ids:nil
                               brandIds:@[self.famousID]
                               pageNum:num
                               serviceName:SERVICE_NAME_DIRECTORY
                               serviceType:SERVICE_TYPE_DIRECTORY
                               serviceCode:[NSString stringWithFormat:@"%d",DirectoryGoods]];
    
    [ApplicationDelegate.udpClientSocket sendMessage:sendMessage];
}

- (void)initNavigation
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.weChatNavigationBar=[[WeChatNavigationBar alloc] init];
    [self.view addSubview:self.weChatNavigationBar];
    self.weChatNavigationBar.titleLabel.text=self.title;
    [self.weChatNavigationBar .leftButton addTarget:self action:@selector(exit)  forControlEvents:UIControlEventTouchUpInside];
     [self.weChatNavigationBar.rightButton setHidden:YES];
    
}
-(void)exit
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.oldNum =self.famousArray.count;
    
    return self.famousArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TRMemuCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"TRMemuCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor grayColor];
//    cell.imageView.image = ApplicationDelegate.loadingImage;
//    NSDictionary * famousDict = self.famousArray[indexPath.row];
    
    NSLog(@"name:%d,%@",self.famousArray.count,self.famousArray);
    
   
         [cell.imageView setImageWithURL:[NSURL URLWithString:self.famousArray[indexPath.row][@"THUMBNAIL_URL"]] placeholderImage:ApplicationDelegate.loadingImage];
    
   
    cell.selectImageView.hidden = YES;
    cell.nameLabel.text=self.famousArray[indexPath.row][@"NAME"];
    

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    TRGoodsViewController * goodVc = (TRGoodsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"TRGoodsViewController"];
    goodVc.productTypeId = self.famousArray[indexPath.row][@"ID"];
    
    [self.navigationController pushViewController:goodVc animated:YES];
}


@end
