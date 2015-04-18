//
//  CustomTabBarView.m
//  WeChatHelper
//
//  Created by Mac on 14-3-26.
//  Copyright (c) 2014年 bang yi bang. All rights reserved.
//

#import "CustomTabBarView.h"
@implementation CustomTabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        

    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        
    }
    return self;


}
-(id)init
{
    if (self=[super init]) {
        
    }
    return self;
}



-(void)initView
{

    [self changAction:0];


    
    
}

        
  
    
    
-(void)selectItem:(NSInteger)num{
   
    [self buttonWasSelected:num];
    
    
}





- (IBAction)changAction:(UIButton *)sender
{
    
       NSLog(@"000000");
    switch (sender.tag) {
        case 0:
      
            [self.delegate buttonWasSelected:0];
            [self buttonWasSelected:0];
          
            break;
        case 1:

            [self.delegate buttonWasSelected:1];
            [self buttonWasSelected:1];
            
            break;
        case 2:

            [self.delegate buttonWasSelected:2];
            [self buttonWasSelected:2];
            break;
            
        default:
            break;
    }

}

- (void)buttonWasSelected:(NSInteger)index
{
    
    

    switch (index) {
        case 0:{
            self.msgBt.selected=YES;
            self.rangBt.selected=NO;
            self.MeBt.selected=NO;
        
            
            
            [self.msgBt setImage:[UIImage imageNamed:@"菜单下分类按下"] forState:UIControlStateNormal];
            [self.rangBt setImage:[UIImage imageNamed:@"品牌"] forState:UIControlStateNormal];
            [self.MeBt setImage:[UIImage imageNamed:@"我"] forState:UIControlStateNormal];
//            [self.msgBt setUserInteractionEnabled:YES];
//            [self.rangBt setUserInteractionEnabled:YES];
//            [self.MeBt setUserInteractionEnabled:YES];
        


        }
            break;
        case 1:
            self.msgBt.selected=NO;
            self.rangBt.selected=YES;
            self.MeBt.selected=NO;
        
        
            [self.msgBt setImage:[UIImage imageNamed:@"菜单下分类"] forState:UIControlStateNormal];
            [self.rangBt setImage:[UIImage imageNamed:@"品牌按下"] forState:UIControlStateSelected];
            [self.MeBt setImage:[UIImage imageNamed:@"我"] forState:UIControlStateNormal];
        
        
//            [self.msgBt setUserInteractionEnabled:YES];
//            [self.rangBt setUserInteractionEnabled:NO];
//            [self.MeBt setUserInteractionEnabled:YES];
        
            break;
        case 2:
            self.msgBt.selected=NO;
            self.rangBt.selected=NO;
            self.MeBt.selected=YES;
            
            
            [self.msgBt setImage:[UIImage imageNamed:@"菜单下分类"] forState:UIControlStateNormal];
            [self.rangBt setImage:[UIImage imageNamed:@"品牌"] forState:UIControlStateNormal];
            [self.MeBt setImage:[UIImage imageNamed:@"我按下"] forState:UIControlStateSelected];
        
//            [self.msgBt setUserInteractionEnabled:YES];
//            [self.rangBt setUserInteractionEnabled:YES];
//            [self.MeBt setUserInteractionEnabled:NO];
            break;
            
        default:
            break;
    }





}

//- (void)addGesture
//{
//    self.tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMumu)];
//    [self.msgBt addGestureRecognizer:self.tap];
//}
//
//- (void)showMumu
//{
//    NSLog(@"pppp");
//    
//}


@end
