//
//  UdpClientSocket.m
//  WeiMiLan
//
//  Created by cong on 14-7-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "UdpClientSocket.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
//#import "XMLReader.h"
//#import "XMLParser.h"
#import "NSString+XMLParser.h"
#import "XMLDictionary.h"
#import "TRAlertView.h"

//不想写那么多代码了
#define xmlparser_startDocument(string) xmlDirectory=[xmlDirectory stringByAppendingString:[NSString startDocument:string]];
#define xmlparser_startTag(string) xmlDirectory=[xmlDirectory stringByAppendingString:[NSString startTag:string]];
#define xmlparser_endTag(string) xmlDirectory=[xmlDirectory stringByAppendingString:[NSString endTag:string]];

#define xmlparser_createXmlHead(userName,serviceName,serviceType,serviceCode) xmlDirectory=[xmlDirectory stringByAppendingString:[self createXmlHeadUserName:userName serviceName:serviceName serviceType:serviceType serviceCode:serviceCode]];
#define xmlparser_text(string) xmlDirectory=[xmlDirectory stringByAppendingString:string];

@implementation UdpClientSocket



+ (UdpClientSocket *)sharedUdpClientSocket
{
    static UdpClientSocket *sharedAccountUdpClientSocketInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountUdpClientSocketInstance = [[self alloc] init];
        [ApplicationDelegate.upSocket setDelegate:self];
    });
    
    
    return sharedAccountUdpClientSocketInstance;
}

-(void)sendMessage:(NSString *)message{
[ApplicationDelegate.upSocket setDelegate:self];
//    //要发送的明码报文
//    NSString * sendString =@"<?xml version='1.0' encoding='UTF-8' ?><MYAPP><HEAD><USER_NAME>test</USER_NAME><MAC>78:F7:BE:27:AD:09</MAC><SERVICE_NAME>login</SERVICE_NAME><SERVICE_TYPE>0</SERVICE_TYPE><SERVICE_CODE></SERVICE_CODE><ACTION_CODE>0</ACTION_CODE><TIME_STAMP>20140717204046</TIME_STAMP><TIME_EXPIRE>20140722204546</TIME_EXPIRE></HEAD><BODY><LOGIN_USER_REQ><USER_NAME>test</USER_NAME><USER_PASSWORD>123456</USER_PASSWORD><MAC>78:F7:BE:27:AD:09</MAC><REGION></REGION><OS_TYPE>0</OS_TYPE></LOGIN_USER_REQ></BODY></MYAPP>";
    
    
    
    NSLog(@"发送的内容：\n%@",[message stringByReplacingOccurrencesOfString:@"><" withString:@">\n<"]);
    //报文UTF-8
    NSData* data1=[message dataUsingEncoding:NSUTF8StringEncoding];
    //报文gzip压缩
    NSData* data = [LFCGzipUtility gzipData:data1];
    //发送到服务器
    [ApplicationDelegate.upSocket sendData:data toHost:HOST port:HOST_PORT_NUM withTimeout:-1 tag:0];

}


//接收信息
-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    

    //gzip解压
    NSData *xmlData=[LFCGzipUtility ungzipData:data];
    
    //转化为字符串
    NSString* info=[[NSString alloc]initWithData:xmlData encoding:NSUTF8StringEncoding];
    
    NSLog(@"xml:%@",info);
    id infomation = info;
    
    
    
    self.receiveMessage =[NSMutableDictionary dictionaryWithDictionary: [NSDictionary dictionaryWithXMLString:info]];
	 NSLog(@"dict:%@",[NSString replaceUnicode:self.receiveMessage.description]);

        
        
    [[NSNotificationCenter defaultCenter]postNotificationName:self.receiveMessage[@"HEAD"][@"SERVICE_NAME"] object:nil userInfo:self.receiveMessage];
        

        
        if (![self.receiveMessage[@"HEAD"][@"SERVICE_NAME"] isEqualToString:SERVICE_NAME_RECOMMEND]) {
            //如果等于心跳
            if ([self.receiveMessage[@"HEAD"][@"SERVICE_NAME"] isEqualToString:SERVICE_NAME_CONNECTION]) {
                NSString * sendMsg = [ApplicationDelegate.udpClientSocket
                                      createXmlConnectionUserName:ApplicationDelegate.userName message:@"OK" serviceName:SERVICE_NAME_CONNECTION serviceType:SERVICE_TYPE_CONNECTION serviceCode:@""];
                [ApplicationDelegate.udpClientSocket sendMessage:sendMsg];
                
            }else if([self.receiveMessage[@"HEAD"][@"SERVICE_NAME"] isEqualToString:SERVICE_NAME_LOGIN]){
                  //用户未登录
                if ([self.receiveMessage[@"BODY"][@"MESSAGE_INFO"][@"CODE"] isEqualToString:@"0002"]) {
                    UIAlertView * alterView = [[UIAlertView  alloc]initWithTitle:@"登录" message:@"请输入登录信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                   
                    
                    alterView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
                    
                    self.userName = [alterView textFieldAtIndex:0];
                    self.password = [alterView textFieldAtIndex:1];
                    
                    self.userName.delegate = self;
                    self.password.delegate = self;
                    
                    [alterView show];
                }else if ([self.receiveMessage[@"BODY"][@"MESSAGE_INFO"][@"CODE"] isEqualToString:@"0000"]){
                    MMProgressHUDShowSuccess(@"成功");
                    
                    if ([self.receiveMessage[@"HEAD"][@"SERVICE_NAME"] isEqualToString:SERVICE_NAME_LOGIN]) {
                        ApplicationDelegate.userName = self.receiveMessage[@"HEAD"][@"USER_NAME"];
                        
                        NSString * upurl = self.receiveMessage[@"BODY"][@"LOGIN_USER_RSP"][@"UPLOAD_URL"];
                        ApplicationDelegate.userID = [upurl stringByReplacingOccurrencesOfString:@"http://www.op89.com:8080/test/client-upload-pic?" withString:@""];
                        ApplicationDelegate.uploadUrl = [NSURL URLWithString:upurl];
                        
                        
                        [NSStandardUserDefaults setObject:self.receiveMessage forKey:@"USER_NAME"];
                        if (self.password.text) {
                             [NSStandardUserDefaults setObject:self.password.text forKey:self.receiveMessage[@"HEAD"][@"USER_NAME"]];
                        }
                       
                        NSLog(@"保存的密码:%@",[NSStandardUserDefaults objectForKey:self.receiveMessage[@"HEAD"][@"USER_NAME"]]);
                        
                        [NSStandardUserDefaults synchronize];
                    }
                    
                    
                    
                    
                }else{
                 MMProgressHUDShowError(self.receiveMessage[@"BODY"][@"MESSAGE_INFO"][@"MESSAGE"]);
                
                }
              



            }else{
//其他
                
                
            }
        }else{
            NSLog(@"推送的内容：%@",self.receiveMessage[@"BODY"][@"RECOMMEND_SEND"][@"RECOMMEND"][@"TITLE"]);
            
            
            
//         [MMProgressHUD showWithTitle:@"推送通知" status:self.receiveMessage[@"BODY"][@"RECOMMEND_SEND"][@"RECOMMEND"][@"TITLE"] cancelBlock:^{}];
        }
        
       

    [sock receiveWithTimeout:-1 tag:0];
    
    return YES;
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
            
            
            
            break;
        default:
            break;
    }

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

-(void)alertViewShow:(NSString*)message{
 
    UIAlertView * alterView = [[UIAlertView  alloc]initWithTitle:@"登录" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    
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
//摇啊摇
-(void)lockAnimationForView:(UIView*)view
{
    CALayer *lbl = [view layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-10, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+10, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [lbl addAnimation:animation forKey:nil];
}
-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    //无法发送时,返回的异常提示信息  do something
    NSLog(@"error1");
}


/**
 *  生成head
 *
 *  @param userName    用户名
 *  @param serviceName 服务名
 *  @param serviceType Action_ 客户端还是服务器  login
 *  @param serviceCode OS_IOS 安卓还是IOS
 *
 *  @return 生成head
 */
-(NSString *)createXmlHeadUserName:(NSString*)userName serviceName:(NSString*)serviceName serviceType:(NSString*)serviceType serviceCode:(NSString*) serviceCode{
   
    NSString * xmlCode = @"";
 
    xmlCode = [NSString stringWithFormat:@"<HEAD><USER_NAME>%@</USER_NAME><MAC>%@</MAC><SERVICE_NAME>%@</SERVICE_NAME><SERVICE_TYPE>%@</SERVICE_TYPE><SERVICE_CODE>%@</SERVICE_CODE><ACTION_CODE>%@</ACTION_CODE><TIME_STAMP>%@</TIME_STAMP><TIME_EXPIRE>%@</TIME_EXPIRE></HEAD>",userName,[self macaddress],serviceName,serviceType,serviceCode,ACTION_CODE_CLIENT,[self currentTime],[self getTimeString:UDP_TIME_EXPIRE]];
    
    return xmlCode;
}


/**
 *  登录
 *
 *  @param userName    登录名
 *  @param password    密码
 *  @param serviceName 服务事件名，如：login
 *  @param serviceType Action_ 客户端还是服务器
 *  @param serviceCode OS_IOS 安卓还是IOS
 
 NSString * sendString =@"<?xml version='1.0' encoding='UTF-8' ?><MYAPP><HEAD><USER_NAME>test</USER_NAME><MAC>78:F7:BE:27:AD:09</MAC><SERVICE_NAME>login</SERVICE_NAME><SERVICE_TYPE>0</SERVICE_TYPE><SERVICE_CODE></SERVICE_CODE><ACTION_CODE>0</ACTION_CODE><TIME_STAMP>20140717204046</TIME_STAMP><TIME_EXPIRE>20140722204546</TIME_EXPIRE></HEAD><BODY><LOGIN_USER_REQ><USER_NAME>test</USER_NAME><USER_PASSWORD>123456</USER_PASSWORD><MAC>78:F7:BE:27:AD:09</MAC><REGION></REGION><OS_TYPE>0</OS_TYPE></LOGIN_USER_REQ></BODY></MYAPP>";
 */
-(NSString *)createXmlLoginUserName:(NSString *)userName password:(NSString *)password serviceName:(NSString *)serviceName serviceType:(NSString *)serviceType serviceCode:(NSString *)serviceCode{

    NSString * XmlLogin = @"";
    //登录
    //登记手机所在地址。精确到城市
    //登记手机mac地址
    
    XmlLogin = [NSString stringWithFormat:@"<BODY><LOGIN_USER_REQ><USER_NAME>%@</USER_NAME><USER_PASSWORD>%@</USER_PASSWORD><MAC>%@</MAC><REGION></REGION><OS_TYPE>%@</OS_TYPE></LOGIN_USER_REQ></BODY>",userName,password,[self macaddress],OS_TYPE_IOS];
    //加头
    XmlLogin = [[self createXmlHeadUserName:userName serviceName:serviceName serviceType:serviceType serviceCode:serviceCode] stringByAppendingString:XmlLogin];
    //加myapp
    XmlLogin = [NSString stringWithFormat:@"<%@>%@</%@>",XML_ROOT,XmlLogin,XML_ROOT];
    //加UTF-8
    XmlLogin = [@"<?xml version='1.0' encoding='UTF-8' ?>" stringByAppendingString:XmlLogin];
    
    
    return XmlLogin;

}

/**
 *  目录
 *
 *  @param userName       用户名
 *  @param orderField     不知道是什么
 *  @param orderDirection 排序
 *  @param ids            如：DIR_ORDER_FIELD_CREATEDATE
 *  @param pageNum        页码
 *  @param serviceName    SERVICE_NAME_DIRECTORY
 *  @param serviceType    OS_TYPE_IOS
 *  @param serviceCode    目录时：@"1008"  登录时：OS_TYPE_IOS
 *
 @"<?xml version='1.0' encoding='UTF-8' ?><MYAPP><HEAD><USER_NAME>harde1</USER_NAME><MAC>78:F7:BE:27:AD:09</MAC><SERVICE_NAME>productType</SERVICE_NAME><SERVICE_TYPE>1</SERVICE_TYPE><SERVICE_CODE>1010</SERVICE_CODE><ACTION_CODE>0</ACTION_CODE><TIME_STAMP>20140719133945</TIME_STAMP><TIME_EXPIRE>20140719134445</TIME_EXPIRE></HEAD><BODY><PACKAGE_REQ><ORDER_FIELD>createDate</ORDER_FIELD><ORDER_DIRECTION>1</ORDER_DIRECTION><ID>2214</ID><PAGE_NUM>1</PAGE_NUM></PACKAGE_REQ></BODY></MYAPP>"
 
 *  @return 目录
 */
-(NSString *)createXmlDirectoryUserName:(NSString *)userName
                             orderField:(NSString *)orderField
                         orderDirection:(NSString *)orderDirection
                                    ids:(NSArray *)ids
                               brandIds:(NSArray*)brandIds
                                pageNum:(NSString *)pageNum
                            serviceName:(NSString *)serviceName
                            serviceType:(NSString *)serviceType
                            serviceCode:(NSString *)serviceCode{

//<ID>2214</ID>
    //参考：<BODY><PACKAGE_REQ><ORDER_FIELD>createDate</ORDER_FIELD><ORDER_DIRECTION>1</ORDER_DIRECTION><PAGE_NUM>1</PAGE_NUM></PACKAGE_REQ></BODY></MYAPP>
    NSString * xmlDirectory = @"";
    
    
    xmlparser_startDocument(@"UTF-8")
    

    xmlparser_startTag(XML_ROOT)
    xmlparser_createXmlHead(userName, serviceName, serviceType, serviceCode)
    xmlparser_startTag(XML_BODY)
    xmlparser_startTag(PACKAGE_REQ)
    if (orderField) {
        xmlparser_startTag(PRODUCT_TYPE_ORDER_FIELD)
        xmlparser_text(orderField)
        xmlparser_endTag(PRODUCT_TYPE_ORDER_FIELD)
    }
  
    if (orderDirection) {
        xmlparser_startTag(PRODUCT_TYPE_ORDER_DIRECTION)
        xmlparser_text(orderDirection)
        xmlparser_endTag(PRODUCT_TYPE_ORDER_DIRECTION)
    }
   
    
    if (ids) {
        for (int i=0; i<ids.count; i++) {
            xmlparser_startTag(XML_ID)
            xmlparser_text(ids[i])
            xmlparser_endTag(XML_ID)
        }
    }
    
    
    if (brandIds) {
        for (int i=0; i<brandIds.count; i++) {
            xmlparser_startTag(XML_BRANDID)
            xmlparser_text(brandIds[i])
            xmlparser_endTag(XML_BRANDID)
        }
    }
    
    if (pageNum) {
        xmlparser_startTag(@"PAGE_NUM")
        xmlparser_text(pageNum)
        xmlparser_endTag(@"PAGE_NUM")
    }
    xmlparser_endTag(PACKAGE_REQ)
    xmlparser_endTag(XML_BODY)
    xmlparser_endTag(XML_ROOT)
    
    

    
    return xmlDirectory;
}

//搜索
-(NSString *)createXmlSearchUserName:(NSString *)userName
                          orderField:(NSString *)orderField
                      orderDirection:(NSString *)orderDirection
                                 ids:(NSArray *)ids
                             pageNum:(NSString *)pageNum
                         serviceName:(NSString *)serviceName
                         serviceType:(NSString *)serviceType
                         serviceCode:(NSString *)serviceCode
                         searchParam:(NSString *)searchParam {
    NSString * xmlDirectory = @"";
//    xmlSerializer.setOutput(xmlWriter);
    
   xmlparser_startDocument(@"UTF-8")
    xmlparser_startTag(XML_ROOT)
    
    
   xmlparser_createXmlHead(userName, serviceName, serviceType, serviceCode)
    
   xmlparser_startTag(XML_BODY)
    
    xmlparser_startTag(PACKAGE_REQ)

    xmlparser_startTag(PRODUCT_TYPE_ORDER_FIELD)
//    xmlSerializer.startTag("", XMLParser.PRODUCT_TYPE_ORDER_FIELD);
    xmlparser_text(orderField)
//    xmlSerializer.text(orderField);
    xmlparser_endTag(PRODUCT_TYPE_ORDER_FIELD)
//    xmlSerializer.endTag("", XMLParser.PRODUCT_TYPE_ORDER_FIELD);
    xmlparser_startTag(PRODUCT_TYPE_ORDER_DIRECTION)
//    xmlSerializer.startTag("", XMLParser.PRODUCT_TYPE_ORDER_DIRECTION);
    xmlparser_text(orderDirection)
//    xmlSerializer.text(orderDirection);
    xmlparser_endTag(PRODUCT_TYPE_ORDER_DIRECTION)
//    xmlSerializer.endTag("", XMLParser.PRODUCT_TYPE_ORDER_DIRECTION);
    
    if (ids) {
        for (int i=0; i<ids.count; i++) {
            xmlparser_startTag(XML_ID)
            xmlparser_text(ids[i])
            xmlparser_endTag(XML_ID)
        }
    }
    if (pageNum) {
        xmlparser_startTag(@"PAGE_NUM")
        xmlparser_text(pageNum)
        xmlparser_endTag(@"PAGE_NUM")
    }
    
    xmlparser_startTag(XML_NAME)
//    xmlSerializer.startTag("", XMLParser.XML_NAME);
    xmlparser_text(searchParam)
//    xmlSerializer.text(searchParam);
    xmlparser_endTag(XML_NAME)
//    xmlSerializer.endTag("", XMLParser.XML_NAME);
    xmlparser_endTag(PACKAGE_REQ)
//    xmlSerializer.endTag("", XMLParser.PACKAGE_REQ);
    xmlparser_endTag(XML_BODY)
//    xmlSerializer.endTag("", XMLParser.XML_BODY);
    xmlparser_endTag(XML_ROOT)
//    xmlSerializer.endTag("", XMLParser.XML_ROOT);
    
//    xmlSerializer.endDocument();
    
    return xmlDirectory;
}

//产品
-(NSString *)createXmlProductUserName:(NSString *)userName
                        productTypeId:(NSArray *)productTypeId
                          serviceName:(NSString *)serviceName
                          serviceType:(NSString *)serviceType
                          serviceCode:(NSString *)serviceCode{
    
     NSString * xmlDirectory = @"";
    
    xmlparser_startDocument(@"UTF-8")
    xmlparser_startTag(XML_ROOT)
    
    
//    <SERIAL_NUMBER></SERIAL_NUMBER>
    xmlparser_createXmlHead(userName, serviceName, serviceType, serviceCode)
    
    xmlparser_startTag(XML_BODY);
    
    xmlparser_startTag(PRODUCT_REQ);
    
    
    if (productTypeId.count>0) {
        for (int n=0; n<productTypeId.count; n++) {
            xmlparser_startTag(PRODUCT_TYPE_ID);
            xmlparser_text(productTypeId[n]);
            xmlparser_endTag(PRODUCT_TYPE_ID);
        }
       
    }
   
    
    
    xmlparser_endTag(PRODUCT_REQ);
    
    xmlparser_endTag(XML_BODY);
    
    xmlparser_endTag(XML_ROOT);
    
    return xmlDirectory;
}


-(NSString*)getTimeString:(NSTimeInterval)t{
     NSTimeInterval time=[NSDate timeIntervalSinceReferenceDate];
    time = time + t;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *str = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:time]];
    
//    NSLog(@"将来时间：%@",str);
    return str;
}

//下载
-(NSString *)createXmlDownload:(NSArray*)downArray{

 NSString * xmlDirectory = @"";
    

    xmlparser_startDocument(@"UTF-8");
    xmlparser_startTag(XML_ROOT);
    
    xmlparser_startTag(XML_BODY);
    
    xmlparser_startTag(XML_DOWNLOAD_DATA);
    
    
    for(int i=0;i<downArray.count;i++) {
       NSDictionary * map = downArray[i];
        
        xmlparser_startTag(XML_DOWNLOAD);
        
        xmlparser_startTag(XML_NAME);
        xmlparser_text(map[@"name"]);
        xmlparser_endTag(XML_NAME);
        
        xmlparser_startTag(@"ICON");
        xmlparser_text(map[@"icon"]);
        xmlparser_endTag(@"ICON");
        
        xmlparser_startTag(XML_URI);
        xmlparser_text(map[@"uri"]);
        xmlparser_endTag(XML_URI);
        
        xmlparser_startTag(XML_CREATE_DATE);
        xmlparser_text(map[@"date"]);
        xmlparser_endTag(XML_CREATE_DATE);
        
        xmlparser_startTag(XML_FILE_SIZE);
        xmlparser_text(map[@"size"]);
        xmlparser_endTag(XML_FILE_SIZE);
        
        xmlparser_startTag(XML_TYPE);
        xmlparser_text(map[@"type"]);
        xmlparser_endTag(XML_TYPE);
        
        xmlparser_endTag(XML_DOWNLOAD);
    }
    
    
    xmlparser_endTag(XML_DOWNLOAD_DATA);
    
    xmlparser_endTag(XML_BODY);
    
    xmlparser_endTag(XML_ROOT);
    
    
    return xmlDirectory;
}


//心跳
-(NSString *)createXmlConnectionUserName:(NSString*)userName
                                message:(NSString*) message
                                serviceName:(NSString*) serviceName
                                serviceType:(NSString*) serviceType
                                serviceCode:(NSString*) serviceCode{
    
    NSString * xmlDirectory = @"";

    
    
    xmlparser_startDocument(@"UTF-8");
    xmlparser_startTag(XML_ROOT);
    
    xmlparser_createXmlHead(userName, serviceName, serviceType, serviceCode);
    
    xmlparser_startTag(XML_BODY);
    
    xmlparser_startTag(HEARTBEAT_ACK);
    
    xmlparser_startTag(XML_MESSAGE);
    xmlparser_text(message);
    xmlparser_endTag(XML_MESSAGE);
    
    
    xmlparser_endTag(HEARTBEAT_ACK);
    
    xmlparser_endTag(XML_BODY);
    
    xmlparser_endTag(XML_ROOT);
    return xmlDirectory;
}

//<?xml version='1.0' encoding='UTF-8' ?><MYAPP><HEAD><USER_NAME>空间</USER_NAME><MAC>78:F7:BE:27:AD:09</MAC><SERVICE_NAME>resigter</SERVICE_NAME><SERVICE_TYPE>5</SERVICE_TYPE><SERVICE_CODE></SERVICE_CODE><ACTION_CODE>0</ACTION_CODE><TIME_STAMP>20140724155736</TIME_STAMP><TIME_EXPIRE>20140724160236</TIME_EXPIRE><SERIAL_NUMBER></SERIAL_NUMBER></HEAD><BODY><REGISTER_USER><LOGIN_NAME>空间</LOGIN_NAME><PASS_WORD>gighui</PASS_WORD><NAME>寂寞</NAME><PHONE>18812345670</PHONE><MAC>78:F7:BE:27:AD:09</MAC><REGION></REGION></REGISTER_USER></BODY></MYAPP>

//注册
-(NSString *)createXmlRegisterUserName:(NSString*)userName
                              password:(NSString*)password
                                  name:(NSString*)name
                                 phone:(NSString*)phone
                           serviceName:(NSString*)serviceName
                           serviceType:(NSString*)serviceType
                           serviceCode:(NSString*)serviceCode {
 NSString * xmlDirectory = @"";
    
    
    xmlparser_startDocument(@"UTF-8");
    xmlparser_startTag(XML_ROOT);
    
    
    xmlparser_createXmlHead(userName, serviceName, serviceType, serviceCode);
    
    xmlparser_startTag(XML_BODY);
    
    
    xmlparser_startTag(REGISTER_USER);
    
    xmlparser_startTag(REGISTER_LOGIN_NAME);
    xmlparser_text(userName);
    xmlparser_endTag(REGISTER_LOGIN_NAME);
    
    xmlparser_startTag(REGISTER_PASS_WORD);
    xmlparser_text(password);
    xmlparser_endTag(REGISTER_PASS_WORD);
    
    xmlparser_startTag(REGISTER_NAME);
    xmlparser_text(name);
    xmlparser_endTag(REGISTER_NAME);
    
    xmlparser_startTag(REGISTER_PHONE);
    xmlparser_text(phone);
    xmlparser_endTag(REGISTER_PHONE);
    
    xmlparser_startTag(XML_MAC);
    
    xmlparser_text([self macaddress]);
    
    xmlparser_endTag(XML_MAC);
    
    /*if(!TextUtils.isEmpty(MyApplication.getInstance().getCityName())) {
     MyApplication.getInstance().setCityName("深圳");
     }*/
    
    xmlparser_startTag(REGISTER_REGION);
    xmlparser_text(@"广州");
    xmlparser_endTag(REGISTER_REGION);
    
    xmlparser_endTag(REGISTER_USER);
    xmlparser_endTag(XML_BODY);
    xmlparser_endTag(XML_ROOT);

    return xmlDirectory;
}
//修改密码
-(NSString *)createXmlModifyPasswrodUserName:(NSString*)userName
                                 OldPassword:(NSString*)oldPassword
                                 NewPassword:(NSString*)newPassword
                                 serviceName:(NSString*)serviceName
                                 serviceType:(NSString*)serviceType
                                 serviceCode:(NSString*)serviceCode{
NSString * xmlDirectory = @"";

    xmlparser_startDocument(@"UTF-8");
    xmlparser_startTag(XML_ROOT);
    
    
    xmlparser_createXmlHead(userName, serviceName, serviceType, serviceCode);
    xmlparser_startTag(XML_BODY);
    
    
    xmlparser_startTag(@"CHG_PASSWORD");
    
    xmlparser_startTag(@"LOGIN_NAME");
    xmlparser_text(userName);
    xmlparser_endTag(@"LOGIN_NAME");
    
    xmlparser_startTag(@"OLD_PASSWORD");
    xmlparser_text(oldPassword);
    xmlparser_endTag( @"OLD_PASSWORD");
    
    xmlparser_startTag(@"NEW_PASSWORD");
    xmlparser_text(newPassword);
    xmlparser_endTag(@"NEW_PASSWORD");
    
    
    xmlparser_endTag(@"CHG_PASSWORD");
    
    xmlparser_endTag(XML_BODY);
    
    xmlparser_endTag(XML_ROOT);
    
    return xmlDirectory;
}
//推荐
-(NSString *)createXmlRecommendUserName:(NSString*)userName
                                    ids:(NSArray *)ids
                            serviceName:(NSString*)serviceName
                            serviceType:(NSString*)serviceType
                            serviceCode:(NSString*)serviceCode{
    
  NSString * xmlDirectory = @"";
   
    
    xmlparser_startDocument(@"UTF-8");
    xmlparser_startTag(XML_ROOT);
    
     xmlparser_createXmlHead(userName, serviceName, serviceType, serviceCode);
    
    xmlparser_startTag(XML_BODY);
    
    xmlparser_startTag(RECOMMEND_RECEIVE);
    
    if(ids.count>0) {
        for(int i=0;i<ids.count;i++) {
            xmlparser_startTag(XML_ID);
            xmlparser_text(ids[i]);
            xmlparser_endTag(XML_ID);
        }
    }
    
    xmlparser_endTag(RECOMMEND_RECEIVE);
    
    xmlparser_endTag(XML_BODY);
    
    xmlparser_endTag(XML_ROOT);
    
   
 
    return xmlDirectory;
}



-(NSString *)currentTime{

     NSTimeInterval time=[NSDate timeIntervalSinceReferenceDate];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *str = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:time]];
    
//    NSLog(@"当前时间：%@",str);
    return str;
}
/**
 *  获取MAC
 *
 *  @return mac字符串
 */
- (NSString *) macaddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSLog(@"outString:%@", [outstring uppercaseString]);
    
    free(buf);
    
    return [outstring uppercaseString];
}


//根据经纬度 查找地址

- (void)getAddress:(NSString *)aLongitude withLatitude:(NSString *)aLatitude withBlock:(void(^)(id result))callback {
    
//    callbackBlock = callback;
    
    NSString *url = @"http://maps.googleapis.com/maps/api/geocode/json";
    
    NSString *coordinateStr = [NSString stringWithFormat:@"%@,%@",aLatitude,aLongitude];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:@"true" forKey:@"sensor"];
    
    [params setValue:@"cn" forKey:@"language"];
    
    [params setObject:coordinateStr forKey:@"latlng"];
    
    NSString *tempParamStr = [self addParametersToRequest:params];
    
    NSString *tempUrl = [NSString stringWithFormat:@"%@?%@",url,tempParamStr];
    
    NSMutableURLRequest *operationRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:tempUrl]];
    
    
    
    NSURLConnection *operationConnection = [[NSURLConnection alloc] initWithRequest:operationRequest delegate:self startImmediately:NO];
    
    [operationConnection start];
    
}



- (NSString *)addParametersToRequest:(NSMutableDictionary*)parameters {
    
    NSMutableArray *paramStringsArray = [NSMutableArray arrayWithCapacity:[[parameters allKeys] count]];
    
    
    
    for(NSString *key in [parameters allKeys]) {
        
        NSObject *paramValue = [parameters valueForKey:key];
        
		if ([paramValue isKindOfClass:[NSString class]]) {
            NSString * ss ;//=[((NSString *)paramValue)  encodeWithCoder:nil];
			[paramStringsArray addObject:[NSString stringWithFormat:@"%@=%@", key, ss]];
            
		} else {
            
			[paramStringsArray addObject:[NSString stringWithFormat:@"%@=%@", key, paramValue]];
            
		}
        
    }
    
    
    
    NSString *paramsString = [paramStringsArray componentsJoinedByString:@"&"];
    
    return paramsString;
    
}



@end
