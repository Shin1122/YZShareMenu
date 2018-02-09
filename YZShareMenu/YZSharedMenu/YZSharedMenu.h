//
//  YZSharedMenu.h
//  YZShareMenu
//
//  Created by Lakeside on 2018/2/8.
//  Copyright © 2018年 Shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZShareCell.h"
#import "YZSharedMod.h"
/**
 弹窗风格

 - SingleLineStyle: 单行模式
 - MutableLineStyle: 多行模式（目前只支持两行）
 */
typedef NS_ENUM(NSUInteger, YZSharedMenuStyle) {
    SingleLineStyle,
    MutableLineStyle,
};

/** 回了个调 */
typedef void(^selectedShared)(YZSharedMod *sharedMod);

@interface YZSharedMenu : UIViewController

/** 底部content */
@property (nonatomic, strong) UIView *content ;

/** 分享label */
@property (nonatomic, strong) UILabel *shareLabel ;

/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancelBtn ;

/** 第一行图标啥的 */
@property (nonatomic, strong) UICollectionView *firstLineCollection ;

/** 第二行图标啥的 */
@property (nonatomic, strong) UICollectionView *secondLineColelction ;


@property (nonatomic, assign) YZSharedMenuStyle menuStyle ;

@property (nonatomic, copy) selectedShared didSelectedSharedMod ;


/**
 初始化方法1

 @param style 样式
 @param images 图片数组直接传进去
 @param names share名字
 @return id
 */
-(instancetype)initWithStyle:(YZSharedMenuStyle)style andImages:(NSArray <UIImage *>*)images andNames:(NSArray <NSString *>*)names;

/**
 初始化器2

 @param style 样式
 @param images 图片名称数组直接传进去
 @param names share名字
 @return id
 */
-(instancetype)initWithStyle:(YZSharedMenuStyle)style andImageNames:(NSArray <NSString *>*)images andNames:(NSArray <NSString *>*)names;


/** 调用之前必须初始化,否则会炸 */
- (void)show;

//更多行自行拓展

@end
