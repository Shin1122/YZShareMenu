//
//  YZShareCell.m
//  YZShareMenu
//
//  Created by Lakeside on 2018/2/9.
//  Copyright © 2018年 Shin. All rights reserved.
//

#import "YZShareCell.h"

@implementation YZShareCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _image = [[UIImageView alloc]init];
        [self.contentView addSubview:_image];
        
        _title = [[UILabel alloc]init];
        [self.contentView addSubview:_title];
        
        [_image setFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.width-10)];
        _image.layer.masksToBounds = YES;
        _image.layer.cornerRadius = self.frame.size.width/2-5;
        
        [_title setFrame:CGRectMake(0, _image.frame.size.height+10, self.frame.size.width, self.frame.size.height - _image.frame.size.height-10)];
        [_title setTextColor:[UIColor blackColor]];
        [_title setFont:[UIFont systemFontOfSize:13]];
        _title.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}

-(void)setModel:(YZSharedMod *)model{
    
    _model = model;
    [_image setImage:model.icon];
    _title.text = model.shareName;
    
}

@end
