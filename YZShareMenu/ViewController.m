//
//  ViewController.m
//  YZShareMenu
//
//  Created by Lakeside on 2018/2/8.
//  Copyright © 2018年 Shin. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sharedMenu = [[YZSharedMenu alloc]init];
    _sharedMenu.didSelectedSharedMod = ^(YZSharedMod *sharedMod) {
      
        
        
    };
    
}

- (IBAction)SharedMenuSow:(id)sender {
    [_sharedMenu  show];
}
- (IBAction)MutbaleSharedMenuShow:(id)sender {
    [_sharedMenu  show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
