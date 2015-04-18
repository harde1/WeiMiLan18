//
//  UdpManager.h
//  WeiMiLan
//
//  Created by cong on 14-7-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#ifndef WeiMiLan_UdpManager_h
#define WeiMiLan_UdpManager_h


//#define HOST @"182.236.160.182"

#define HOST @"222.89.188.182"

#define HOST_PORT_NUM 18569

//#define UTF-8 <?xml version='1.0' encoding='UTF-8' ?>

//xml
#define XML_ROOT @"MYAPP"
#define XML_HEAD @"HEAD"
#define XML_BODY @"BODY"

#define XML_MAC @"MAC"
#define XML_ID @"ID"
#define XML_BRANDID @"BRANDID"
#define XML_NAME @"NAME"
#define XML_ATTACHMENT_URL @"ATTACHMENT_URL"
#define XML_CREATE_DATE @"CREATE_DATE"

#define XML_MESSAGE_INFO @"MESSAGE_INFO"
#define XML_CODE @"CODE"
#define XML_MESSAGE @"MESSAGE"

//download
#define XML_DOWNLOAD_DATA @"DOWNLOAD_DATA"
#define XML_DOWNLOAD @"DOWNLOAD"
#define XML_URI @"URI"
#define XML_FILE_SIZE @"SIZE"
#define XML_TYPE @"TYPE"

//install
#define XML_NOTIFICATION @"NOTIFICATION"
#define XML_REGION_NAME @"REGION_NAME"
#define XML_PHONE_TYPE @"PHONE_TYPE"

//head
#define HEAD_USER_NAME @"USER_NAME"
#define HEAD_SERVICE_NAME @"SERVICE_NAME"
#define HEAD_SERVICE_TYPE @"SERVICE_TYPE"
#define HEAD_SERVICE_CODE @"SERVICE_CODE"
#define HEAD_ACTION_CODE @"ACTION_CODE"
#define HEAD_TIME_STAMP @"TIME_STAMP"
#define HEAD_TIME_EXPIRE @"TIME_EXPIRE"

//登录
#define LOGIN_USER_REQ @"LOGIN_USER_REQ"
#define LOGIN_USER_NAME @"USER_NAME"
#define LOGIN_USER_PASSWORD @"USER_PASSWORD"
#define LOGIN_REGION @"REGION"
#define LOGIN_OS_TYPE @"OS_TYPE"

#define LOGIN_USER_RSP @"LOGIN_USER_RSP"


//注册
#define REGISTER_USER @"REGISTER_USER"
#define REGISTER_LOGIN_NAME @"LOGIN_NAME"
#define REGISTER_PASS_WORD @"PASS_WORD"
#define REGISTER_NAME @"NAME"
#define REGISTER_PHONE @"PHONE"
#define REGISTER_REGION @"REGION"

//目录
#define PACKAGE @"PACKAGE"
#define PACKAGE_REQ @"PACKAGE_REQ"
#define PACKAGE_RSP @"PACKAGE_RSP"
#define PRODUCT_TYPE_ORDER_FIELD @"ORDER_FIELD"
#define PRODUCT_TYPE_ORDER_DIRECTION @"ORDER_DIRECTION"

#define PRODUCT_TYPE_RSP @"PRODUCT_TYPE_RSP"
#define PRODUCT_TYPE @"PRODUCT_TYPE"
#define PRODUCT_TYPE_CREATE_DATE @"CREATE_DATE"


//产品
#define PRODUCT_REQ @"PRODUCT_REQ"
#define PRODUCT_TYPE_ID @"ID"
#define PRODUCT_RSP @"PRODUCT_RSP"
#define PRODUCT @"PRODUCT"
#define PRODUCT_PICTURE_URL @"PICTURE_URL"


//推送
#define RECOMMEND_SEND @"RECOMMEND_SEND"
#define RECOMMEND @"RECOMMEND"
#define RECOMMEND_TITLE @"TITLE"
#define RECOMMEND_CONTENT @"CONTENT"
#define RECOMMEND_LEVEL @"LEVEL"
#define RECOMMEND_READ @"READ"
#define RECOMMEND_RECEIVE @"RECOMMEND_RECEIVE"


//test连接
#define HEARTBEAT_SEND @"HEARTBEAT_SEND"
#define DATA @"DATA"
#define HEARTBEAT_ACK @"HEARTBEAT_ACK"


//注销
#define LOGOUT @"LOGOUT"
#define IMMEDIATELY @"IMMEDIATELY"

//serviceCode
#define ACTION_CODE_CLIENT @"0"				//客户端事件
#define ACTION_CODE_SERVER @"1"				//服务器端事件


#define UDP_TIME_EXPIRE  60*60*24		//发送UDP超时1天(秒)

//serviceType
#define OS_TYPE_ANDROID @"0"	//安卓系统
#define OS_TYPE_IOS @"1"		//ios系统

//serverName
#define SERVICE_NAME_LOGIN @"login"			//登录
#define SERVICE_NAME_DIRECTORY @"productType"	//目录
#define SERVICE_NAME_PRODUCT @"product"		//产品
#define SERVICE_NAME_RECOMMEND @"recommend"			//推送
#define SERVICE_NAME_OTHER @"other"			//其他
#define SERVICE_NAME_REGISTER @"resigter"		//注册
#define SERVICE_NAME_CONNECTION @"heartbeat"	//连接
#define SERVICE_NAME_LOGOUT @"logout"			//注销

#define SERVICE_NAME_CHANGEPW @"change_password" //修改密码


//排序
#define DIR_ORDER_FIELD_CREATEDATE @"createDate"		//目录按时间顺序排
#define DIR_ORDER_FIELD_PINYIN @"pinyin"		//目录按A-Z排序
#define DIR_ORDER_DIRECTION_ASC @"0"	//目录按字母顺序排序：升序
#define DIR_ORDER_DIRECTION_DESC @"1"	//目录按字母顺序排序：降序


//    SERVICE_CODE：1001：类型查询 1002：下载排行榜 1003:收藏夹 1004:添加收藏1005取消收藏  1008 上传目录 1009：品牌列表 1010:商品列表3006 产品推送 1011 海报 1012收藏排行榜 1013分享排行榜 1014一键分享

typedef enum {
    
    DirectorySearch=1001,
    DirectoryDownload,
    DirectoryCollection,
    DirectoryAddCollection,
    DirectoryDelCollection,
    DirectoryUpload=1008,
    DirectoryFamousBrands,
    DirectoryGoods,
    DirectoryPoster,
    DirectoryCollectionBillboard,
    DirectoryShareBillboard,
    DirectoryShare,
    DirectoryOneKeyShare=2002,
    DirectoryPush=3006
    
}DirectorySelect;

//图片
#define SERVICE_CODE_PRODUCT_PREVIEW @"2001"	//图片预览
#define SERVICE_CODE_PRODUCT_DOWNLOAD @"2002"	//图片目录下载

#define SERVICE_TYPE_LOGIN @"0"		//登录
#define SERVICE_TYPE_DIRECTORY @"1"	//目录
#define SERVICE_TYPE_PRODUCT @"2"		//产品
#define SERVICE_TYPE_RECOMMEND @"3"			//推送
#define SERVICE_TYPE_OTHER @"4"		//其他
#define SERVICE_TYPE_REGISTER @"5"		//注册
#define SERVICE_TYPE_CONNECTION @"6"	//连接
#define SERVICE_TYPE_LOGOUT @"7"		//注销
#define SERVICE_TYPE_CHANEPW @"8"      //修改密码
#endif
