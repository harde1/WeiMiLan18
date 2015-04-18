//
//  TRListTableViewController.m
//  WeiMiLan
//
//  Created by cong on 14-7-20.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRListTableViewController.h"
#import "TRGoodsViewController.h"
#import "RankListCell.h"
@interface TRListTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray* listArry;
@end

@implementation TRListTableViewController

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
    [MMProgressHUD showWithTitle:@"" status:@"下载中…" cancelBlock:^{}];
    
}
-(void)receiveMessage:(NSNotification*)nofi{
    //    NSLog(@"%@",[NSString replaceUnicode:nofi.userInfo.description]);
    NSString * message = nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"MESSAGE"];
    if ([nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"CODE"] isEqualToString:@"0000"]) {

        DirectorySelect service_code = [nofi.userInfo[@"HEAD"][@"SERVICE_CODE"] intValue];
        switch (service_code) {
            case DirectorySearch://1001 类型查询
            {
               
                
            }
                break;
            case DirectoryDownload:
            {
                self.listArry = nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"];
                
                [self.tableView reloadData];
            }
                break;
            case  DirectoryCollection://1003
            {
//                self.listArry = nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"];
//                
//                [self.tableView reloadData];
            
            }
                
                break;
            case  DirectoryAddCollection:
                break;
            case  DirectoryDelCollection:
                break;
            case  DirectoryUpload://1008
                break;
            case  DirectoryFamousBrands:
                break;
            case   DirectoryGoods:  //商品列表 1010
            {
                
            }
                
                break;
            case  DirectoryPoster:
            {
                
                
            }
                break;
            case  DirectoryCollectionBillboard:
            {
                self.listArry = nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"];
                
                [self.tableView reloadData];
            }
                break;
            case  DirectoryShareBillboard:
            {
                self.listArry = nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"];
               
                
                [self.tableView reloadData];
            }
                break;
            case DirectoryShare:
                
                
                break;
            case DirectoryPush://3306
            {
                NSLog(@"3306");
                
            }
                break;
        }
        
        
        [MMProgressHUD dismissWithSuccess:message];
    }else{
        [MMProgressHUD dismissWithError:message];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        [self.tableView registerNib:[UINib nibWithNibName:@"RankListCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:SERVICE_NAME_DIRECTORY object:nil];
    
     [self initNavigation];
    switch (self.usage) {
            
            case myCollVC:
            self.weChatNavigationBar.titleLabel.text =  @"我的收藏";
             [self updateString:DirectoryCollection andPage:1 andIDs:nil];
            break;
            
        case sharedVC:
            
            self.weChatNavigationBar.titleLabel.text=@"分享排行榜";
            [self updateString:DirectoryShareBillboard andPage:1 andIDs:nil];
            break;
            
        case collectedVC:
            self.weChatNavigationBar.titleLabel.text=@"收藏排行榜";
            [self updateString:DirectoryCollectionBillboard andPage:1 andIDs:nil];
            break;
        case downVC:
            self.weChatNavigationBar.titleLabel.text=@"下载排行榜";
            [self updateString:DirectoryDownload andPage:1 andIDs:nil];
            break;
    }
  
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SERVICE_NAME_DIRECTORY object:nil];

}
- (void)initNavigation
{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.weChatNavigationBar=[[WeChatNavigationBar alloc] init];
    [self.view addSubview:self.weChatNavigationBar];
    self.weChatNavigationBar.titleLabel.text=@"排行榜";
      [self.weChatNavigationBar.rightButton setImage:nil forState:0];
    [self.weChatNavigationBar .leftButton addTarget:self action:@selector(exit)  forControlEvents:UIControlEventTouchUpInside];
    
    
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

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.listArry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RankListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    cell.kindLabel.text =self.listArry[indexPath.row][@"BRAND_NAME"];
    cell.nameLabel.text =self.listArry[indexPath.row][@"NAME"];

    cell.timesLabel.text = self.listArry[indexPath.row][@"COUNT"];
    
    
    
    
    return cell;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *l=[[UILabel alloc] init];
    l.backgroundColor=[UIColor blackColor];
    l.textColor=[UIColor redColor];
    l.font=[UIFont boldSystemFontOfSize:14.0f];
    switch (self.usage) {
        case sharedVC:
            l.text=@" 商品名称                                    种类      分享次数";
            break;
            
        case collectedVC:
            l.text=@" 商品名称                                    类型      收藏次数";
            break;
        
            
        case downVC:
            l.text=@" 商品名称                                    类型      下载次数";
            break;
        default:
            break;
    }
    
    return l;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    NSLog(@"mmmmmm:%@",self.listArry);
    
    TRGoodsViewController * goodVc = (TRGoodsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"TRGoodsViewController"];
    goodVc.productTypeId = self.listArry[indexPath.row][@"ID"];

    [self.navigationController pushViewController:goodVc animated:YES];
}


@end
