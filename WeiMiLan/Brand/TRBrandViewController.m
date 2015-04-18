//
//  TRBrandViewController.m
//  WeiMiLan
//
//  Created by Mac on 14-7-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRBrandViewController.h"
#import "IIILocalizedIndex.h"

@interface TRBrandViewController ()
@property (strong,nonatomic)NSMutableArray *toBeReturned;
@property(strong,nonatomic) NSArray *sections;
@property(strong,nonatomic) NSArray *rows;

@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) NSDictionary *data;

@property(strong,nonatomic)NSArray* receiveArray;
@end

@implementation TRBrandViewController
@synthesize data = _data;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    self.weChatNavigationBar.rightButton.hidden=YES;
      [self.weChatNavigationBar.rightButton setImage:nil forState:0];
    self.weChatNavigationBar.titleLabel.text=@"品牌";
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigation];
    
    NSString *  sendMessage = [ApplicationDelegate.udpClientSocket
                               createXmlDirectoryUserName:ApplicationDelegate.userName
                               orderField:DIR_ORDER_FIELD_CREATEDATE
                               orderDirection:DIR_ORDER_DIRECTION_ASC
                               ids:nil
                               brandIds:nil
                               pageNum:@"1"
                               serviceName:SERVICE_NAME_DIRECTORY
                               serviceType:SERVICE_TYPE_DIRECTORY
                               serviceCode:@"1009"];
    
    [ApplicationDelegate.udpClientSocket sendMessage:sendMessage];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:SERVICE_NAME_DIRECTORY object:nil];
    
    
    _sections = @[@"A", @"D", @"F", @"M", @"N", @"O", @"Z"];
    
    _rows = @[@[@"adam", @"alfred", @"ain", @"abdul", @"anastazja", @"angelica"],
             @[@"dennis" , @"deamon", @"destiny", @"dragon", @"dry", @"debug", @"drums"],
             @[@"Fredric", @"France", @"friends", @"family", @"fatish", @"funeral"],
             @[@"Mark", @"Madeline"],
             @[@"Nemesis", @"nemo", @"name"],
             @[@"Obama", @"Oprah", @"Omen", @"OMG OMG OMG", @"O-Zone", @"Ontario"],
             @[@"Zeus", @"Zebra", @"zed"]];
    
    _indexBar.delegate = self;
   
}

-(void)dealloc{
[[NSNotificationCenter defaultCenter] removeObserver:self name:SERVICE_NAME_DIRECTORY object:nil];
}
-(void)receiveMessage:(NSNotification*)nofi{
    //    NSLog(@"%@",[NSString replaceUnicode:nofi.userInfo.description]);
    NSString * message = nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"MESSAGE"];
    if ([nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"CODE"] isEqualToString:@"0000"]) {
        //    SERVICE_CODE：1001：类型查询 1002：下载排行榜 1003:收藏夹 1004:添加收藏1005取消收藏  1008 上传目录 1009：品牌列表 1010:商品列表3006 产品推送 1011 海报 1012收藏排行榜 1013分享排行榜 1014一键分享
        DirectorySelect service_code = [nofi.userInfo[@"HEAD"][@"SERVICE_CODE"] intValue];
        //名牌
        if (service_code == DirectoryFamousBrands) {
         
            
            //按拼音排序好就放到数组，有section数组放pinyin首字母，row放内容，先排序好row,提取section
            self.receiveArray = nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"];
            
            NSMutableArray * rowChineseName = [@[]mutableCopy];
            for (NSDictionary * famousDict in self.receiveArray) {
                [rowChineseName addObject:famousDict[@"NAME"]];
            }
            
            
            //汉字排序
            self.data = [IIILocalizedIndex indexed:rowChineseName];
//            _rows = rowChineseName;
            _rows = [self.data.allKeys sortedArrayUsingSelector:@selector(compare:)];
            
            
            
            [self.plainTableView reloadData];
        }
        
        
        [MMProgressHUD dismissWithSuccess:message];
    }else{
        [MMProgressHUD dismissWithError:message];
    }
    
}
#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [_indexBar setIndexes:_sections]; // to always have exact number of sections in table and indexBar
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_rows[section] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _sections[section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"TableViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell.textLabel setText:_rows[indexPath.section][indexPath.row]];
    return cell;
}

#pragma mark - AIMTableViewIndexBarDelegate

- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index{
    if ([_plainTableView numberOfSections] > index && index > -1){   // for safety, should always be YES
        [_plainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}


@end
