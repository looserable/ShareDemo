//
//  ViewController.m
//  ShareDemo
//
//  Created by john on 16/4/28.
//  Copyright © 2016年 jhon. All rights reserved.
//

#import "ViewController.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"

#define REUSEID @"reuseId"
#define kRedirectURI @"http://www.sina.com"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,retain)UICollectionView * myCollectionView;
@property (nonatomic,copy)NSString * selectedStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//    最小的行间距
    layout.minimumLineSpacing = 1;
//    最小的列间距，从名字可知，当itemsize固定，collectionView的宽度确定，由于它会自动适配，那么间距可能会大于你设置的这个最小的行间距。间距就是两个item之间的距离。
    layout.minimumInteritemSpacing = 1;
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 3) /4, (SCREEN_WIDTH - 3) / 4);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400) collectionViewLayout:layout];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_myCollectionView];
    
    [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:REUSEID];
    
    [_myCollectionView reloadData];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 400, SCREEN_WIDTH - 100, 50);
    [button setTitle:@"分享" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor purpleColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
 
    
}

- (void)shareClick:(UIButton *)sender{
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}

#pragma mark -
#pragma Internal Method

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    
    message.text = _selectedStr;
    
//    if (self.textSwitch.on)
//    {
//        message.text = NSLocalizedString(@"测试通过WeiboSDK发送文字到微博!", nil);
//    }
//    
//    if (self.imageSwitch.on)
//    {
//        WBImageObject *image = [WBImageObject object];
//        image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
//        message.imageObject = image;
//    }
//    
//    if (self.mediaSwitch.on)
//    {
//        WBWebpageObject *webpage = [WBWebpageObject object];
//        webpage.objectID = @"identifier1";
//        webpage.title = NSLocalizedString(@"分享网页标题", nil);
//        webpage.description = [NSString stringWithFormat:NSLocalizedString(@"分享网页内容简介-%.0f", nil), [[NSDate date] timeIntervalSince1970]];
//        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
//        webpage.webpageUrl = @"http://sina.cn?a=1";
//        message.mediaObject = webpage;
//    }
//    
    return message;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSEID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
//    直接在这里设置选中的视图即可。设置的背景即是未被选中的背景，这样即可实现选中的item的效果的转换。
    UIView * bgView = [[UIView alloc]init];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
    label.text = @"选中了";
    label.tag = 100;
    label.textColor = [UIColor whiteColor];
    [bgView addSubview:label];
    bgView.backgroundColor = [UIColor purpleColor];
    cell.selectedBackgroundView = bgView;
    
    NSLog(@"%@",NSStringFromCGRect(cell.frame));
    return cell;
}

//  让item可以被选中。
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIView * bgView = cell.selectedBackgroundView;
    UILabel * label = (UILabel *)[bgView viewWithTag:100];
    _selectedStr = [NSString stringWithFormat:@"%@%ld",label.text,indexPath.item];
    NSLog(@"%@",label.text);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
