//
//  IIIViewController.m
//  IIILocalizedIndexDemo
//
//  Created by sehone on 1/23/13.
//  Copyright (c) 2013 sehone. All rights reserved.
//

#import "IIIViewController.h"
#import "IIILocalizedIndex.h"
#import "TRGoodsViewController.h"

#import "TRFamousViewController.h"
#import "TRTabBarViewController.h"
#import "TRSearchView.h"
@interface IIIViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) NSDictionary *data;

@property (strong, nonatomic) NSArray *oldKeys;
@property (strong, nonatomic) NSDictionary *oldData;


@property(strong,nonatomic)NSArray* receiveArray;

@property(strong,nonatomic)NSMutableDictionary * findIdbyNameDict;


@property(strong,nonatomic)NSArray * sendArray;
@property(copy,nonatomic)NSString * sendTitle;
@property(nonatomic,copy)NSString * famousID;

@property(nonatomic,strong)TRSearchView * searchView;

@property(nonatomic,assign)NSInteger isfirstComin;
@end

@implementation IIIViewController
@synthesize data = _data;


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}
- (void)initNavigation
{
    self.tabBarController.tabBar.hidden= NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.weChatNavigationBar=[[WeChatNavigationBar alloc] init];
    [self.view addSubview:self.weChatNavigationBar];
    self.weChatNavigationBar.titleLabel.text=@"品牌";
    self.weChatNavigationBar.rightButton.hidden=YES;
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TRSearchView" owner:self options:nil];
    self.searchView = nibObjects[0];
    self.searchView.bottom = self.weChatNavigationBar.bottom;
    self.searchView.height = self.weChatNavigationBar.height;
    [self.view addSubview:self.searchView];
    self.searchView.hidden = YES;
    [self.searchView.cancelBtn addTarget:self action:@selector(hideSearchView:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView.searBtn addTarget:self action:@selector(searchResult:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.weChatNavigationBar.rightButton  addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)search:(UIButton *)btn{
   
        self.searchView.hidden = !self.searchView.hidden;
    
   
    
}
-(void)searchResult:(UIButton *)btn{
    NSLog(@"搜索内容%@",self.searchView.textF.text);
  
    [self.searchView.textF resignFirstResponder];
    if (!self.findIdbyNameDict) {
        return;
    }
   
    NSMutableArray * rowChineseName = [@[]mutableCopy];
    for (NSDictionary * famousDict in self.receiveArray) {
        NSString * contentString =[[NSString replaceUnicode:famousDict.description] uppercaseString];
        NSString * keyString = [self.searchView.textF.text uppercaseString];
        NSLog(@"搜索内容：%@",contentString);
        if ([contentString rangeOfString:keyString].location !=NSNotFound) {
            [rowChineseName addObject:famousDict[@"NAME"]];
            [self.findIdbyNameDict setObject:famousDict forKey:famousDict[@"NAME"]];
        }
      
    }
    
    NSArray *arr = [NSArray arrayWithArray:rowChineseName];
    
    
    if (arr.count==0) {
        
        [SVProgressHUD showErrorWithStatus:@"没有相关内容"];
        return;
    }
    //保存一下旧的
    if (self.isfirstComin++==1) {
        self.oldData = _data;
        self.keys = _keys;
    }
    
    
    //汉字排序
    self.data = [IIILocalizedIndex indexed:arr];
    
    _keys = [self.data.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    
    
  
    
    [self.tableView reloadData];
    
    
}

-(void)hideSearchView:(UIButton *)btn{
    
    btn.superview.hidden = !btn.superview.hidden;
    
    if (btn.superview.hidden) {
        
        if (_oldData&&_oldData.count>0) {
            _data = self.oldData;
            _keys = self.keys;
            [self.tableView reloadData];
        }
        
    }
}
-(void)viewDidLoad{
    [super viewDidLoad];
    // Custom initialization
    self.isfirstComin = 1;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景1"]];
    NSArray *arr = [self getData];
    self.data = [IIILocalizedIndex indexed:arr];
    self.keys = [self.data.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.alpha = .7;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景1"]];
    
    
    if ([_tableView respondsToSelector:@selector(setSectionIndexColor:)]) { _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor whiteColor];
    }
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:SERVICE_NAME_DIRECTORY object:nil];
    
    [self initNavigation];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
    TRTabBarViewController * tabVC =(TRTabBarViewController*) self.tabBarController;
    
    self.tabBarController.tabBar.hidden =NO;
    tabVC.customTabBarView.hidden = NO;
    
}

-(void)exit
{
    
   [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SERVICE_NAME_DIRECTORY object:nil];
}
-(void)receiveMessage:(NSNotification*)nofi{
  
    
    NSString * message = nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"MESSAGE"];
    
    if ([nofi.userInfo[@"HEAD"][@"SERVICE_CODE"] isEqualToString:@"1009"]) {
        
 
    
    if ([nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"CODE"] isEqualToString:@"0000"]) {
        //    SERVICE_CODE：1001：类型查询 1002：下载排行榜 1003:收藏夹 1004:添加收藏1005取消收藏  1008 上传目录 1009：品牌列表 1010:商品列表3006 产品推送 1011 海报 1012收藏排行榜 1013分享排行榜 1014一键分享
        DirectorySelect service_code = [nofi.userInfo[@"HEAD"][@"SERVICE_CODE"] intValue];
        //名牌
        if (service_code == DirectoryFamousBrands) {
            
            
            //按拼音排序好就放到数组，有section数组放pinyin首字母，row放内容，先排序好row,提取section
            self.receiveArray = nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"];
            
            NSMutableArray * rowChineseName = [@[]mutableCopy];
            self.findIdbyNameDict = [@{}mutableCopy];
            for (NSDictionary * famousDict in self.receiveArray) {
                [rowChineseName addObject:famousDict[@"NAME"]];
                [self.findIdbyNameDict setObject:famousDict forKey:famousDict[@"NAME"]];
            }
            
            NSArray *arr = [NSArray arrayWithArray:rowChineseName];
            //汉字排序
            self.data = [IIILocalizedIndex indexed:arr];
            
            _keys = [self.data.allKeys sortedArrayUsingSelector:@selector(compare:)];
            
            
            
//            NSLog(@"data:%@,\nkey:%@",[NSString replaceUnicode:[self.data description]],_keys);
            
            [self.tableView reloadData];
        }
        
        [MMProgressHUD dismissWithSuccess:message];
    }else{
        [MMProgressHUD dismissWithError:message];
    }
       }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"TRFamousViewController"]) {
        TRFamousViewController* famousVC = segue.destinationViewController;
 
        famousVC.title = self.sendTitle;
        famousVC.famousID =self.famousID;
        
        
        
    }
}



#pragma mark - Table view controller data source & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
         return self.keys.count;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
   
        NSString *key = [self.keys objectAtIndex:section];
        NSArray *arr = [self.data objectForKey:key];
        return arr.count;
   
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
   
        return [self.keys objectAtIndex:section];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"commonCell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
        int section = indexPath.section;
        int row = indexPath.row;
       
        
        NSArray *arr = [self.data objectForKey:[self.keys objectAtIndex:section]];
        cell.textLabel.text = [arr objectAtIndex:row];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.backgroundColor = [UIColor clearColor];
        
        
        UIView * colorView = [[UIView alloc]initWithFrame:CGRectMake(15, 33, 290, 1)];
        colorView.backgroundColor = [UIColor orangeColor];
        colorView.alpha = .7;
        [cell.contentView addSubview:colorView];
        return cell;
   
    
   
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
   
        
         return self.keys;
        
   
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
        UILabel * v = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        v.text = [self tableView:tableView titleForHeaderInSection:section];
        
        v.backgroundColor = [UIColor grayColor];
          return v;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
        
   
NSArray *arr = [self.data objectForKey:[self.keys objectAtIndex:indexPath.section]];
    
    NSString * namePinpai = arr[indexPath.row];
    NSDictionary * p_id = self.findIdbyNameDict[namePinpai];

    
    self.sendTitle = namePinpai;
    
    self.famousID = p_id[@"ID"];
     [self performSegueWithIdentifier:@"TRFamousViewController" sender:nil];
   
}


# pragma mark - Data source

- (NSArray *)getData {
//    NSArray *arr = [NSArray arrayWithObjects:
//                    @"Nuovo cinema Paradiso",
//                    @"12 Angry Men",
//                    @"The Dark Knight",
//                    @"Inception",
//                    @"The Godfather",
//                    @"3 Idiots",
//                    @"Les choristes",
//                    @"となりのトトロ",
//                    @"Léon",
//                    @"ラピュタ",
//                    @"活着",
//                    @"The Sound Of Music",
//                    @"Toy Story",
//                    @"Up",
//                    @"B计划",
//                    @"Singin' in the Rain",
//                    @"A Beautiful Mind",
//                    @"让子弹飞",
//                    @"Gone with the Wind",
//                    @"One Flew Over the Cuckoo's Nest",
//                    @"七人の侍",
//                    @"无间道",
//                    @"Wreck-It Ralph",
//                    @"Big Fish",
//                    @"Braveheart",
//                    @"阳光灿烂的日子",
//                    @"Le grand bleu",
//                    @"The Matrix",
//                    @"东成西就",
//                    @"羅生門",
//                    @"緃横四海",
//                    @"東邪西毒",
//                    @"Öko",
//                    nil];
    NSArray * arr = @[];
    
    return arr;
}

@end
