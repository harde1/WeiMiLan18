//
//  TRAlertView.m
//  WeiMiLan
//
//  Created by cong on 14-7-29.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TRAlertView.h"
@interface TRAlertView()


@end
@implementation TRAlertView
@synthesize backgroundImage,contentImage,buttonArrays;

- (id)initWithImage:(UIImage *)image contentImage:(UIImage *)content{
    if (self == [super init]) {
        
        self.backgroundImage = image;
        self.contentImage = content;
        self.buttonArrays = [NSMutableArray arrayWithCapacity:4];
    }
    return self;
}

-(void) addButtonWithUIButton:(UIButton *) btn
{
    [buttonArrays addObject:btn];
}


- (void)drawRect:(CGRect)rect {
    
    CGSize imageSize = self.backgroundImage.size;
    [self.backgroundImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
}

- (void) layoutSubviews {
    //屏蔽系统的ImageView 和 UIButton
    for (UIView *v in [self subviews]) {
        if ([v class] == [UIImageView class]){
            [v setHidden:YES];
        }
        
        
        if ([v isKindOfClass:[UIButton class]] ||
            [v isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
            [v setHidden:YES];
        }
    }
    
    for (int i=0;i<[buttonArrays count]; i++) {
        UIButton *btn = [buttonArrays objectAtIndex:i];
        btn.tag = i;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (contentImage) {
        UIImageView *contentview = [[UIImageView alloc] initWithImage:self.contentImage];
        contentview.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        [self addSubview:contentview];
    }
}

-(void) buttonClicked:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    
    if (self.TRdelegate) {
        if ([self.TRdelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        {
            [self.TRdelegate alertView:self clickedButtonAtIndex:btn.tag];
        }
    }
    
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void) show {
    [super show];
    CGSize imageSize = self.backgroundImage.size;
    self.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    
}


//- (void)dealloc {
//    [_buttonArrays removeAllObjects];
//    [backgroundImage release];
//    if (contentImage) {
//        [contentImage release];
//        contentImage = nil;
//    }
//    
//    [super dealloc];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
