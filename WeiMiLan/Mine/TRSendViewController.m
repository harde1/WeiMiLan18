//
//  TRSendViewController.m
//  WeiMiLan
//
//  Created by Mac on 14-7-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRSendViewController.h"
#import "KYAlbumViewController.h"

@interface TRSendViewController ()<UITextViewDelegate,albumDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (strong,nonatomic)NSMutableArray *images;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (strong,nonatomic)NSArray *directorys;
@property (strong, nonatomic) IBOutlet UIPickerView *directoryPicker;
@property (weak, nonatomic) IBOutlet UIView *directoryBg;
@property (strong,nonatomic)NSString *directoryString;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (nonatomic)int j;
@property (weak, nonatomic) IBOutlet UIView *operationView;

@property(nonatomic,assign)CGPoint oldOffset;
@property(nonatomic,assign)CGFloat yValue;



@end

@implementation TRSendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)textViewDidChange:(UITextView *)textView
{
//    self.examineText =  textView.text;
    if (textView.text.length == 0) {

        self.placeHolderLabel.text = @"商品描述";
    }else{
        self.placeHolderLabel.text = @"";
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize=CGSizeMake(kUI_SCREEN_WIDTH, kUI_SCREEN_HEIGHT+200);
    self.scrollView.contentOffset=CGPointMake(0, 0);
    self.backgroundImage.layer.borderWidth=1.5f;
    self.backgroundImage.layer.cornerRadius=5.0f;
    self.backgroundImage.layer.borderColor=[[UIColor colorWithRed:142/225.0 green:28/255.0 blue:130/255.0 alpha:1] CGColor];
    
    self.scrollView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景1"]];
    
    self.images=[NSMutableArray array];
    [self initNavigation];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveMessage:) name:SERVICE_NAME_DIRECTORY object:nil];
   
    [self getDirectorys];
    
    self.yValue = 100;
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.oldOffset = self.scrollView.contentOffset;

}

-(void)receiveMessage:(NSNotification*)nofi
{
    
    self.directorys=nofi.userInfo[@"BODY"][@"PACKAGE_RSP"][@"PACKAGE"];
    
    
    [self.directoryPicker reloadAllComponents];
    
}

- (void)initNavigation
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.weChatNavigationBar=[[WeChatNavigationBar alloc] init];
    [self.view addSubview:self.weChatNavigationBar];
    self.weChatNavigationBar.titleLabel.text=@"上传商品";
    [self.weChatNavigationBar.rightButton setImage:nil forState:0];
    [self.weChatNavigationBar .leftButton addTarget:self action:@selector(exit)  forControlEvents:UIControlEventTouchUpInside];

    
}
-(void)exit
{
    
 [self.navigationController popViewControllerAnimated:YES];
}


-(void)delImageFromArray:(NSArray *)array{

    [self.images removeAllObjects];
    [self.images addObjectsFromArray:array];
 
    
    for (UIView* v in self.backgroundImage.subviews) {
        if ([v isMemberOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
    
     [self updateImagesfrom:self.images];
}

//现在照片
- (IBAction)chooseImages:(UIButton *)sender
{
    if (self.images.count>=9) {
        MMProgressHUDShowError(@"最多不超过9张");
        return;
    }
    [self pickAssets:nil];
 
}
- (void)pickAssets:(id)sender
{

    
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = 10;
    picker.assetsFilter = [ALAssetsFilter allAssets];
    picker.delegate = self;
  
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Assets Picker Delegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    for (ALAsset *ii in assets) {

       UIImage *image = [UIImage imageWithCGImage:ii.thumbnail];

        NSString *name=[[ii.description componentsSeparatedByString:@"id="] lastObject];
        
        
        if (self.images.count<9) {
             [self.images addObject:@{@"image": image,@"name":name}];
        }else{
            MMProgressHUDShowError(@"最多不超过9张");
        
        }
       
    
    }
    _j=0;
    [self updateImagesfrom:self.images];
}

- (void)updateImagesfrom:(NSArray *)images
{
    
    for (int i=0; i<images.count; i++) {
        UIImageView *iv=[[UIImageView alloc] init];
        
        iv.userInteractionEnabled = YES;
        iv.tag = i+1;
        int x=i%4*80;
        int y=i/4*80;
        iv.frame=CGRectMake(x,y, 80, 80);
        iv.image=images[i][@"image"];
        self.backgroundImage.userInteractionEnabled = YES;
       [self.backgroundImage addSubview:iv];
        //加点击手势
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delAndLookImage)];
        [iv addGestureRecognizer:tap];
       
        
    }
    if (images.count>=9) {
        self.backgroundImage.height=80*3;
        //操作view下移80
        self.operationView.top=242+80;
        self.yValue = 100+80;
        self.addBtn.top = 190+80;
    }


}

-(void)delAndLookImage{
    KYAlbumViewController * vc = [[KYAlbumViewController alloc]init];
    vc.album = self.images;
    vc.isFromGood = NO;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];

}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if ([textField isEqual:self.DirectoryTextField]) {
        [self.nameTextField resignFirstResponder];
        [self.contentTextView resignFirstResponder];
//         self.directoryPicker.hidden=NO;
        self.directoryBg.hidden = NO;
        [self.scrollView setContentOffset:CGPointFromString([NSString stringWithFormat:@"{0,%f}",self.yValue]) animated:YES];
        if (self.directorys.count==0) {
            [self getDirectorys];
        }
        
              return NO;
    }
    
    if ([textField isEqual:self.nameTextField]) {
        
        [self.scrollView setContentOffset:CGPointMake(0, self.yValue) animated:YES];
    }else
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
 

    

  

}




-(void)getDirectorys
{

  NSString *  s=[ApplicationDelegate.udpClientSocket
                 createXmlDirectoryUserName:ApplicationDelegate.userName
                 orderField:DIR_ORDER_FIELD_CREATEDATE
                 orderDirection:DIR_ORDER_DIRECTION_ASC
                 ids:nil
                 brandIds:nil
                 pageNum:@"1"
                 serviceName:SERVICE_NAME_DIRECTORY
                 serviceType:SERVICE_TYPE_DIRECTORY
                 serviceCode:@"1008"];
    [ApplicationDelegate.udpClientSocket sendMessage:s];
}


- (void)sendImageWithImage:(UIImage *)image
{

    [self sendImageToService:@{
                               @"file.file":image,
                               @"description":self.contentTextView.text,
                               @"productName":self.nameTextField.text,
                               @"pkgId":self.directoryString,
                 
                               
                               
                               } andURLString:ApplicationDelegate.uploadUrl fileName:@"file.file"];
}

- (void)sendImageWithImage:(UIImage *)image andName:(NSString *)name
{
    
    [self sendImageToService:@{
                               @"file.file":image,
                               @"description":self.contentTextView.text,
                               @"productName":self.nameTextField.text,
                               @"pkgId":self.directoryString,
                               
                               
                               
                               } andURLString:ApplicationDelegate.uploadUrl fileName:name];
}


-(void)sendImageToService:(NSDictionary*)params andURLString:(NSURL*)url fileName:(NSString *)fileName{
    NSLog(@"URL:%@",url);
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image=[params objectForKey:@"file.file"];
    //得到图片的data
    NSData* data;

    
    image = [UIImage scaleToSize:CGSizeMake(175, 175) for:image];
    data = UIImageJPEGRepresentation(image,1.0);
    NSLog(@"操作前数据大小:%lu",(unsigned long)data.length);
    
    //大小控制
//    float m = 0.01;
//    float n = 1.0;
//    while ((unsigned long)data.length>1024*40) {
//        n = n - m;
//        data = UIImageJPEGRepresentation(image,n);
//        //        NSLog(@"数据大小：%lu",(unsigned long)imageData.length);
//    }
    NSLog(@"数据最终大小：%lu",(unsigned long)data.length);
    
    
    
    
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"file.file"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            
            
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    //[body appendFormat:@"Content-Disposition: form-data; name=\"file.file\"; filename=\"file.file.png\"\r\n"];
    [body appendFormat:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file.file\"; filename=\"%@.png\"\r\n",fileName]];
    //声明上传文件的格式
    //    if ([imgString isEqualToString:@"png"]) {
    //        [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    //    }else{
    //     [body appendFormat:@"Content-Type: image/JPEG\r\n\r\n"];
    //    }
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFHTTPResponseSerializer *serializer = manager.responseSerializer;
    NSMutableSet *set = [NSMutableSet setWithObjects:@"text/html", nil];
    [set unionSet:serializer.acceptableContentTypes];
    serializer.acceptableContentTypes = set;
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            [SVProgressHUD showErrorWithStatus:@"操作有误！"];

        } else {
            
            if ([responseObject[@"code"] isEqualToString:@"0000"]) {
                _j++;
                
                if (_j==self.images.count) {
                    [SVProgressHUD showSuccessWithStatus:@"商品上传成功！"];
                }
                
                
                
                
            }
            

            
            
        }
    }];
    [task resume];
    [SVProgressHUD showWithStatus:@"上传商品中" maskType:SVProgressHUDMaskTypeBlack];
}

#pragma mark pinkerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.directorys.count;

}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{

    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;

        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 55)];
        
        myView.textAlignment = UITextAlignmentCenter;
        
        myView.text = self.directorys[row][@"NAME"];
    
    
        myView.textColor=[UIColor whiteColor];
        
        myView.font = [UIFont systemFontOfSize:22];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];

    return myView;

    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    self.DirectoryTextField.text=self.directorys[row][@"NAME"];
    self.directoryString=self.directorys[row][@"ID"];
//    self.directoryPicker.hidden=YES;
    self.directoryBg.hidden = YES;
    
    [self.scrollView setContentOffset:self.oldOffset animated:YES];

    
}


- (IBAction)sendAction:(UIButton *)sender
{
    if (self.images.count==0) {

        [SVProgressHUD showErrorWithStatus:@"请选择图片"];
        
        
        return;
    }
    
    if (self.nameTextField.text.length<1) {
     [SVProgressHUD showErrorWithStatus:@"请输入商品名称"];
        return;
    }
    
    if (self.DirectoryTextField.text.length<1) {
       [SVProgressHUD showErrorWithStatus:@"请输入商品目录"];
        return;
    }
    
    for (NSDictionary *i in self.images) {
         [self sendImageWithImage:i[@"image"] andName:i[@"name"]];
     //   [self sendImageWithImage:i[@"image"]];
    }
    
    
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender
{
    [self.contentTextView resignFirstResponder];
    [self.DirectoryTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    
    [self.scrollView setContentOffset:self.oldOffset animated:YES];
//    self.directoryPicker.hidden=YES;
    self.directoryBg.hidden = YES;
}
@end
