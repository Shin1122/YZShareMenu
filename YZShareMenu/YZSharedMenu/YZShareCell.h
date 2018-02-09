//
//  YZShareCell.h
//  YZShareMenu
//
//  Created by Lakeside on 2018/2/9.
//  Copyright © 2018年 Shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZSharedMod.h"

@interface YZShareCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *image ;

@property (nonatomic, strong) UILabel *title ;

@property (nonatomic, strong) YZSharedMod *model ;

@end
