//
//  ViewController.m
//  FBShareViewSample
//
//  Created by jasonwu on 2018/2/2.
//  Copyright © 2018年 jasonwu. All rights reserved.
//

#import "ViewController.h"
#import "FBShareItem.h"
#import "FBShareViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *shareItems;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadShareItems];
    
    UIButton *btnText = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    [btnText setBackgroundColor:[UIColor blueColor]];
    [btnText setTitle:@"分享文本" forState:UIControlStateNormal];
    [btnText addTarget:self action:@selector(goShareText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnText];
    
    
    UIButton *btnLink = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 40)];
    [btnLink setBackgroundColor:[UIColor blueColor]];
    [btnLink setTitle:@"分享链接" forState:UIControlStateNormal];
    [btnLink addTarget:self action:@selector(goShareLink) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLink];
    
    UIButton *btnImage = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 40)];
    [btnImage setBackgroundColor:[UIColor blueColor]];
    [btnImage setTitle:@"分享图片" forState:UIControlStateNormal];
    [btnImage addTarget:self action:@selector(goShareImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnImage];
    
    UIButton *btnVideo = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 100, 40)];
    [btnVideo setBackgroundColor:[UIColor blueColor]];
    [btnVideo setTitle:@"分享视频" forState:UIControlStateNormal];
    [btnVideo addTarget:self action:@selector(goShareVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnVideo];
    
}

- (void)loadShareItems {
    self.shareItems = [NSMutableArray new];
    
    for (int i = 0 ; i < FBSharePlatformTypeNum; i ++) {
        FBShareItem *item = [[FBShareItem alloc] initWithPlatformType:i];
        [self.shareItems addObject:item];
    }
}


- (void)goShareText {
    FBShareViewController *vc = [[FBShareViewController alloc] initWithShareItems:self.shareItems];
    vc.baseController = self;
    vc.shareText = @"这是从FBShareView分享出来的文字";
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)goShareLink {
    FBShareViewController *vc = [[FBShareViewController alloc] initWithShareItems:self.shareItems];
    vc.baseController = self;
    vc.shareLink = @"www.baidu.com";
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)goShareImage {
    FBShareViewController *vc = [[FBShareViewController alloc] initWithShareItems:self.shareItems];
    vc.baseController = self;
    vc.image = [UIImage imageNamed:@"demoImage.jpg"];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)goShareVideo {
    FBShareViewController *vc = [[FBShareViewController alloc] initWithShareItems:self.shareItems];
    vc.baseController = self;
    
    NSString *demoVideo = [[NSBundle mainBundle] pathForResource:@"demoVideo" ofType:@"MOV"];
    vc.videoUrl = [NSURL fileURLWithPath:demoVideo];
    [self presentViewController:vc animated:YES completion:nil];
}



@end
