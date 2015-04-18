//
//  TRMemuCell.m
//  WeiMiLan
//
//  Created by Mac on 14-7-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRMemuCell.h"

@implementation TRMemuCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)awakeFromNib
{
//    self.layer.cornerRadius=4;
//    self.clipsToBounds=YES;

}




-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
   
    if (selected) {
        
        self.selectImageView.image = [UIImage imageNamed:@"CTAssetsPickerChecked"];
    }else{
        self.selectImageView.image = nil;
       
    }
}
@end
