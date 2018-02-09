//
//  YZSharedMenu.m
//  YZShareMenu
//
//  Created by Lakeside on 2018/2/8.
//  Copyright © 2018年 Shin. All rights reserved.
//

#import "YZSharedMenu.h"
#import "AppDelegate.h"


// 界面宽高
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
// 底部适配iPhone X 宏
#define SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)

//尺寸用autolayout会减少很多尺寸数据计算,demo里就不改了

#define CANCEL_BUTTON_HEIGHT  (SafeAreaBottomHeight == 34 ? 84:50)  //取消按钮高度
#define CONTENT_HEIGHT 360  //区域高度
#define LINES_HEIGHT 100    //单行高度
#define ITEM_HEIGHT  90   //item 高度
#define ITEM_WIDTH  ((SCREEN_WIDTH-SHARE_ITEM_LEFTANDRIGHT_MARGIN*2-40)/5)    //item 宽度

#define SHARE_ITEM_LEFTANDRIGHT_MARGIN  15  //左右边距
#define SHARE_ITEM_TOP_MARGIN  5   //顶部边距

@interface YZSharedMenu ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    CGFloat _content_activeHeight; //可操作活跃区域
    
    UICollectionViewFlowLayout *_layout1;
    UICollectionViewFlowLayout *_layout2;
}

/** 第一行mod */
@property (nonatomic, strong) NSMutableArray <YZSharedMod *>* firstLineMod ;

/** 第二行mod */
@property (nonatomic, strong) NSMutableArray <YZSharedMod *>* secondLineMod ;

@end

@implementation YZSharedMenu



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuStyle = MutableLineStyle;
    
    //来点测试数据
    _firstLineMod = @[].mutableCopy;
    _secondLineMod = @[].mutableCopy;
    NSArray *images1 = @[@"head1",@"head2",@"head3",@"head4",@"head5"];
    NSArray *names1 = @[@"王美丽",@"Piggy",@"刘随便",@"Boss Liu",@"张可爱"];
    NSArray *images2 = @[@"朋友圈",@"wechat",@"weibo",@"qq",@"zone"];
    NSArray *names2 = @[@"朋友圈",@"微信",@"微博",@"QQ好友",@"QQ空间"];
    
    
    for (int i=0; i<5; i++) {
        YZSharedMod *mod = [[YZSharedMod alloc]init];
        mod.icon = [UIImage imageNamed:images1[i]];
        mod.shareName = names1[i];
        [_firstLineMod addObject:mod];
    }
    
    for (int i=0; i<5; i++) {
        YZSharedMod *mod = [[YZSharedMod alloc]init];
        mod.icon = [UIImage imageNamed:images2[i]];
        mod.shareName = names2[i];
        [_secondLineMod addObject:mod];
    }
    
    //布局
    [self setupViews];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        _content.frame = CGRectMake(0, SCREEN_HEIGHT - _content.frame.size.height, SCREEN_WIDTH, _content.frame.size.height);
        self.view.alpha = 1;
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
}



/** 布局 */
- (void)setupViews{
    
    //底层content
    _content = [[UIView alloc]init];
    [self.view addSubview:_content];
    
    _content.layer.masksToBounds = YES;
    _content.layer.cornerRadius = 2*M_PI;
    _content.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
    if (@available(iOS 11.0, *)) {
        _content.insetsLayoutMarginsFromSafeArea = YES;
    } else {
        // Fallback on earlier versions
    }
    
    //分享label(布局自定义)
    _shareLabel = [[UILabel alloc]init];
    [_content addSubview:_shareLabel];
    _shareLabel.frame = CGRectMake(SHARE_ITEM_LEFTANDRIGHT_MARGIN, SHARE_ITEM_TOP_MARGIN, 100, 40);
    _shareLabel.text = @"分享";
    
    //取消按钮
    _cancelBtn = [[UIButton alloc]init];
    [_content addSubview:_cancelBtn];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [_cancelBtn addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
    
    _layout1 = [[UICollectionViewFlowLayout alloc]init];
    _layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _layout2 = [[UICollectionViewFlowLayout alloc]init];
    _layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //类型启发(⊙v⊙)
    switch (_menuStyle) {
        case SingleLineStyle:{
            _content.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CONTENT_HEIGHT-LINES_HEIGHT);
            _cancelBtn.frame = CGRectMake(0, CONTENT_HEIGHT-LINES_HEIGHT-CANCEL_BUTTON_HEIGHT, SCREEN_WIDTH, CANCEL_BUTTON_HEIGHT);
            _cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(-SafeAreaBottomHeight, 0, 0, 0);//安全区inset适配
            
            [self makeUpFirstCollection];
            
        }
            break;
            
        case MutableLineStyle:{
            _content.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CONTENT_HEIGHT);
            _cancelBtn.frame = CGRectMake(0, CONTENT_HEIGHT-CANCEL_BUTTON_HEIGHT, SCREEN_WIDTH, CANCEL_BUTTON_HEIGHT);
            _cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(-SafeAreaBottomHeight, 0, 0, 0);//安全区inset适配
            
            //可操作的活动区域高度
            _content_activeHeight = _content.frame.size.height - CANCEL_BUTTON_HEIGHT - _shareLabel.frame.origin.y-_shareLabel.frame.size.height;
            
            //放个分割线
            UIView *line = [[UIView alloc]init];
            [_content addSubview:line];
            line.backgroundColor = [UIColor grayColor];
            line.frame = CGRectMake(SHARE_ITEM_LEFTANDRIGHT_MARGIN, _shareLabel.frame.origin.y+_shareLabel.frame.size.height +_content_activeHeight/2, SCREEN_WIDTH-SHARE_ITEM_LEFTANDRIGHT_MARGIN*2, 1);
            
            [self makeUpFirstCollection];
            [self makeUpSecondCollection];
        }
            break;
        default:{
            _content.frame = CGRectMake(0, SCREEN_HEIGHT-CONTENT_HEIGHT-80, SCREEN_WIDTH, CONTENT_HEIGHT);
        }
            break;
    }

    
    //demo中默认是单行风格
    
}

#pragma mark- Collecitons

/** 单行风格的第一行 */
- (void)makeUpFirstCollection{
    _firstLineCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_layout1];
    _firstLineCollection.showsVerticalScrollIndicator = NO;
    _firstLineCollection.showsHorizontalScrollIndicator = NO;
    _firstLineCollection.backgroundColor = [UIColor clearColor];
    _firstLineCollection.tag = 1;
    [_content addSubview:_firstLineCollection];
    _firstLineCollection.frame = CGRectMake(SHARE_ITEM_LEFTANDRIGHT_MARGIN, _shareLabel.frame.origin.y+_shareLabel.frame.size.height+10, SCREEN_WIDTH-SHARE_ITEM_LEFTANDRIGHT_MARGIN*2, LINES_HEIGHT);
    [_firstLineCollection registerClass:[YZShareCell class] forCellWithReuseIdentifier:@"firstCell"];
    
    _firstLineCollection.delegate = self;
    _firstLineCollection.dataSource = self;
    
}

/** 双行风格的第二行 */
- (void)makeUpSecondCollection{
    _secondLineColelction = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_layout2];
    _secondLineColelction.showsVerticalScrollIndicator = NO;
    _secondLineColelction.showsHorizontalScrollIndicator = NO;
    _secondLineColelction.backgroundColor = [UIColor clearColor];
    _secondLineColelction.tag = 2;
    [_content addSubview:_secondLineColelction];
    _secondLineColelction.frame = CGRectMake(SHARE_ITEM_LEFTANDRIGHT_MARGIN, _shareLabel.frame.origin.y+_shareLabel.frame.size.height+ _content_activeHeight/2+10, SCREEN_WIDTH-SHARE_ITEM_LEFTANDRIGHT_MARGIN*2, LINES_HEIGHT);
    [_secondLineColelction registerClass:[YZShareCell class] forCellWithReuseIdentifier:@"secondCell"];
    
    _secondLineColelction.delegate = self;
    _secondLineColelction.dataSource = self;
    
}

#pragma mark- collection datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 1) {
        return _firstLineMod.count;
    }else{
        return _secondLineMod.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell;
    if (collectionView.tag == 1) {
        static NSString * firstCell = @"firstCell";
        YZShareCell * collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:firstCell forIndexPath:indexPath];
        if (_firstLineMod.count>indexPath.item) {
            collectionCell.model = _firstLineMod[indexPath.item];
        }
        cell = collectionCell;
    }else{
        static NSString * secondCell = @"secondCell";
        YZShareCell * collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:secondCell forIndexPath:indexPath];
        if (_secondLineMod.count>indexPath.item) {
            collectionCell.model = _secondLineMod[indexPath.item];
        }
        cell = collectionCell;
    }
    
    return cell;
}


#pragma mark- collection delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_firstLineMod && _secondLineMod) {
        self.didSelectedSharedMod(collectionView.tag==1?_firstLineMod[indexPath.item]:_secondLineMod[indexPath.item]);
        [self remove];
    }
}


/** 在当前window上直接显示 */
- (void)show{
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
}


/** 消失 */
- (void)remove{
    
    [UIView animateWithDuration:0.3 animations:^{
        _content.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _content.frame.size.height);
        self.view.alpha = 0;
    }];
    [self performSelector:@selector(turnRemoves) withObject:nil afterDelay:0.3];
    
}
- (void)turnRemoves{
    [self.view removeFromSuperview];
}


//安全区
-(void)viewSafeAreaInsetsDidChange{
    
    [super viewSafeAreaInsetsDidChange];
    //安全区
    NSLog(@"安全区: %f,%f,%f,%f",self.view.safeAreaInsets.top,self.view.safeAreaInsets.left,self.view.safeAreaInsets.bottom,self.view.safeAreaInsets.right);
    
}

- (void)cancelShare{
    [self remove];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        if ([touch.view isEqual:self.view]) {
            [self remove];
            return;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
