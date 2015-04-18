//
//  TRNewGoodsViewController.m
//  WeiMiLan
//
//  Created by Mac on 14-7-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRNewGoodsViewController.h"
#import "TRGoodsViewController.h"
@interface TRNewGoodsViewController ()

@property(nonatomic,strong)NSMutableDictionary * pushDict;
@property(nonatomic,strong)NSArray * array3005;
@property(nonatomic,strong)NSArray * array3006;
@property(nonatomic,strong)NSMutableArray * currentArray;
@end

@implementation TRNewGoodsViewController

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
//    self.pushArray = [@[]mutableCopy];
    //接收数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:SERVICE_NAME_RECOMMEND object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TRNewGoodsCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self initNavigation];
    self.currentArray = [@[]mutableCopy];
    self.pushDict = [NSStandardUserDefaults objectForKey:@"pushFromServer"];
   self.array3005 = self.pushDict[@"3005"];
    self.array3006 = self.pushDict[@"3006"];
    
    [self.currentArray addObjectsFromArray:self.array3005];
     [self.currentArray addObjectsFromArray:self.array3006];
//    NSString *  sendMessage = [ApplicationDelegate.udpClientSocket
//                               createXmlRecommendUserName:ApplicationDelegate.userName
//                               ids:@[@""]
//                               serviceName:SERVICE_NAME_RECOMMEND
//                               serviceType:SERVICE_TYPE_RECOMMEND
//                               serviceCode:@"3002"];
//    
//    sendMessage = [ApplicationDelegate.udpClientSocket createXmlDirectoryUserName:ApplicationDelegate.userName orderField:DIR_ORDER_FIELD_CREATEDATE orderDirection:DIR_ORDER_DIRECTION_ASC ids:nil brandIds:nil pageNum:@"1" serviceName:SERVICE_NAME_RECOMMEND serviceType:SERVICE_TYPE_RECOMMEND serviceCode:@"3001"];
    
//    sendMessage = @"<MYAPP><HEAD><USER_NAME>harde1</USER_NAME><MAC>3C:15:C2:BA:31:48</MAC><SERVICE_NAME>recommend</SERVICE_NAME><SERVICE_TYPE>3</SERVICE_TYPE><SERVICE_CODE>3006</SERVICE_CODE><ACTION_CODE>0</ACTION_CODE><TIME_STAMP>20140727155216</TIME_STAMP><TIME_EXPIRE>20140728155216</TIME_EXPIRE></HEAD><BODY><RECOMMEND_RECEIVE><ID></ID></RECOMMEND_RECEIVE></BODY></MYAPP>";
    
//    sendMessage = @"<?xml version='1.0' encoding='UTF-8' ?><MYAPP><HEAD><USER_NAME>harde1</USER_NAME><MAC>3C:15:C2:BA:31:48</MAC><SERVICE_NAME>recommend</SERVICE_NAME><SERVICE_TYPE>3</SERVICE_TYPE><SERVICE_CODE>3006</SERVICE_CODE><ACTION_CODE>0</ACTION_CODE><TIME_STAMP>20140727154456</TIME_STAMP><TIME_EXPIRE>20140728154456</TIME_EXPIRE></HEAD>";
//    //<?xml version='1.0' encoding='UTF-8' ?><MYAPP><HEAD><USER_NAME>harde1</USER_NAME><MAC>3C:15:C2:BA:31:48</MAC><SERVICE_NAME>recommend</SERVICE_NAME><SERVICE_TYPE>3</SERVICE_TYPE><SERVICE_CODE>3006</SERVICE_CODE><ACTION_CODE>0</ACTION_CODE><TIME_STAMP>20140727151930</TIME_STAMP><TIME_EXPIRE>20140728151930</TIME_EXPIRE></HEAD><BODY><RECOMMEND_RECEIVE>
//    <ID>3001</ID>
//    </RECOMMEND_RECEIVE></BODY></MYAPP>
////    sendMessage = [ApplicationDelegate.udpClientSocket createXmlHeadUserName:ApplicationDelegate.userName serviceName:<#(NSString *)#> serviceType:<#(NSString *)#> serviceCode:<#(NSString *)#>];
    
    
//    [ApplicationDelegate.udpClientSocket sendMessage:sendMessage];
   
    
}
-(void)receiveMessage:(NSNotification*)nofi{
    
    
    NSString* code = nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"CODE"];
    NSString* message=nofi.userInfo[@"BODY"][@"MESSAGE_INFO"][@"MESSAGE"];
    if ([code isEqualToString:@"0000"]) {
        DirectorySelect service_code = [nofi.userInfo[@"HEAD"][@"SERVICE_CODE"] intValue];
        //名牌
        if (service_code == DirectoryPush) {
            [MMProgressHUD showWithTitle:@"" status:@"没有内容"];
        
        
        }
        
        
        [MMProgressHUD dismissWithSuccess:message];
    }else{
        [MMProgressHUD dismissWithError:message];
    }
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SERVICE_NAME_RECOMMEND object:nil];
}

- (void)initNavigation
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.weChatNavigationBar=[[WeChatNavigationBar alloc] init];
    [self.view addSubview:self.weChatNavigationBar];
    self.weChatNavigationBar.titleLabel.text=@"最新动态";
    [self.weChatNavigationBar.rightButton setImage:nil forState:0];
    [self.weChatNavigationBar .leftButton addTarget:self action:@selector(exit)  forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)exit
{
    
   [self.navigationController popViewControllerAnimated:YES]; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return self.currentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRNewGoodsCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary * pushContent;
    NSString * content;
//    if (self.array3005.count>0 && indexPath.row<self.array3005.count) {
//        pushContent = self.array3005[indexPath.row];
//        content = pushContent[@"CONTENT"];
//    }else if (self.array3006.count>0){
//        //3005 4 index 3 4-4=0
//     pushContent = self.array3006[indexPath.row-self.array3005.count];
//    
//    }
    
    pushContent = self.currentArray[indexPath.row];
    if (pushContent[@"CONTENT"]) {
         content = pushContent[@"CONTENT"];
    }
   
    NSString * title = pushContent[@"TITLE"];
    NSString * create_date =  pushContent[@"CREATE_DATE"];
    NSString * push_ID = pushContent[@"ID"];
    NSString * level = pushContent[@"LEVEL"];
    NSString * read = pushContent[@"READ"];
    
    
    cell.nameLabel.text = title;
    cell.timeLabel.text = [self getTime:create_date];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


//    SERVICE_CODE：3001：接收确认 3002：同步 3003：阅读 3004:消息详情
    NSString * sendMsg = [ApplicationDelegate.udpClientSocket
                          createXmlRecommendUserName:ApplicationDelegate.userName
                          ids:@[self.currentArray[indexPath.row][@"ID"]]
                          serviceName:SERVICE_NAME_RECOMMEND
                          serviceType:SERVICE_TYPE_RECOMMEND
                          serviceCode:@"3004"];
    
    [ApplicationDelegate.udpClientSocket sendMessage:sendMsg];
    
//    [self.navigationController pushViewController:goodVc animated:YES];
}

-(NSString *)getTime:(NSString *)time{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
//    [inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDate* inputDate = [inputFormatter dateFromString:time];
    
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    NSString *str = [outputFormatter stringFromDate:inputDate];
    
    return str;
}
@end
