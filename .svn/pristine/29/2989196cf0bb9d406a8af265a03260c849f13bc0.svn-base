//
//  UdpClientSocket.h
//  WeiMiLan
//
//  Created by cong on 14-7-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//


#import <GHUnitIOS/GHUnit.h>
//#import "XMLParser.h"
#import "TBXML.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
@interface UdpClientSocket : GHAsyncTestCase<UIAlertViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)TBXML * tb;
@property(nonatomic,strong)NSMutableDictionary * receiveMessage;

@property(nonatomic,strong)UITextField * userName;
@property(nonatomic,strong)UITextField * password;


//保存建立特殊相册
@property (strong, atomic) ALAssetsLibrary * library;
+ (UdpClientSocket *)sharedUdpClientSocket;
-(void)sendMessage:(NSString *)message;


//生产Head
-(NSString *)createXmlHeadUserName:(NSString*)userName
                       serviceName:(NSString*)serviceName
                       serviceType:(NSString*)serviceType
                       serviceCode:(NSString*) serviceCode;
//登录
-(NSString *)createXmlLoginUserName:(NSString *)userName
                           password:(NSString *)password
                        serviceName:(NSString *)serviceName
                        serviceType:(NSString *)serviceType
                        serviceCode:(NSString *)serviceCode;
//目录
-(NSString *)createXmlDirectoryUserName:(NSString *)userName
                             orderField:(NSString *)orderField
                         orderDirection:(NSString *)orderDirection
                                    ids:(NSArray *)ids
                               brandIds:(NSArray*)brandIds
                                pageNum:(NSString *)pageNum
                            serviceName:(NSString *)serviceName
                            serviceType:(NSString *)serviceType
                            serviceCode:(NSString *)serviceCode;
//产品
-(NSString *)createXmlProductUserName:(NSString *)userName
                        productTypeId:(NSArray *)productTypeId
                          serviceName:(NSString *)serviceName
                          serviceType:(NSString *)serviceType
                          serviceCode:(NSString *)serviceCode;

//注册
-(NSString *)createXmlRegisterUserName:(NSString*)userName
                              password:(NSString*)password
                                  name:(NSString*)name
                                 phone:(NSString*)phone
                           serviceName:(NSString*)serviceName
                           serviceType:(NSString*)serviceType
                           serviceCode:(NSString*)serviceCode;

//修改密码
-(NSString *)createXmlModifyPasswrodUserName:(NSString*)userName
                                 OldPassword:(NSString*)oldPassword
                                 NewPassword:(NSString*)newPassword
                                 serviceName:(NSString*)serviceName
                                 serviceType:(NSString*)serviceType
                                 serviceCode:(NSString*)serviceCode;
//推荐
-(NSString *)createXmlRecommendUserName:(NSString*)userName
                                    ids:(NSArray *)ids
                            serviceName:(NSString*)serviceName
                            serviceType:(NSString*)serviceType
                            serviceCode:(NSString*)serviceCode;
@end
