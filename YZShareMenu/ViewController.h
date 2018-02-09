//
//  ViewController.h
//  YZShareMenu
//
//  Created by Lakeside on 2018/2/8.
//  Copyright © 2018年 Shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZSharedMenu.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *sharedBtn;
@property (weak, nonatomic) IBOutlet UIButton *mutableSharedBtn;
@property (nonatomic, strong) YZSharedMenu *sharedMenu ;

@end

