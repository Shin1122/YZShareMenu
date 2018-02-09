//
//  YZSharedMod.h
//  YZShareMenu
//
//  Created by Lakeside on 2018/2/9.
//  Copyright © 2018年 Shin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 分享类型

 - WechatType: 微信好友
 - QQType: QQ好友
 - QZoneType: QQ空间
 - WeiboType: 微博
 - MomentsType: 朋友圈
 - FriendsType: 应用内好友
 - OtherType: 其他类型,自行拓展
 */
typedef NS_ENUM(NSUInteger, YZSharedType) {
    WechatType,
    QQType,
    QZoneType,
    WeiboType,
    MomentsType,
    FriendsType,
    OtherType,
};

@interface YZSharedMod : NSObject

@property (nonatomic, strong) UIImage *icon ;

@property (nonatomic, strong) NSString *shareName ;

@property (nonatomic, assign) YZSharedType sharedType ;

@end
