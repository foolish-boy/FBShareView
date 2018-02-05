# README

FBShareView是一个很简单的通用分享界面。

####无须接入第三方平台SDK，支持分享文字、链接、图片、视频等，支持WhatsApp、Facebook、Twitter、Instagram、Snapchat、wechat、more等平台。

示例图：

![FBShareViewSample 截图](http://upload-images.jianshu.io/upload_images/1136939-f27d0fcd7a74b2ae.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/640/h/480)


使用方法：

参考FBShareViewSample代码：

```` objective_c
//自定义选择分享平台
- (void)loadShareItems {
    self.shareItems = [NSMutableArray new];
    
    for (int i = 0 ; i < FBSharePlatformTypeNum; i ++) {
        FBShareItem *item = [[FBShareItem alloc] initWithPlatformType:i];
        [self.shareItems addObject:item];
    }
}

//分享文本
- (void)goShareText {
    FBShareViewController *vc = [[FBShareViewController alloc] initWithShareItems:self.shareItems];
    vc.baseController = self;
    vc.shareText = @"这是从FBShareView分享出来的文字";
    [self presentViewController:vc animated:YES completion:nil];
}

//分享链接
- (void)goShareLink {
    FBShareViewController *vc = [[FBShareViewController alloc] initWithShareItems:self.shareItems];
    vc.baseController = self;
    vc.shareLink = @"www.baidu.com";
    [self presentViewController:vc animated:YES completion:nil];
}

//分享图片
- (void)goShareImage {
    FBShareViewController *vc = [[FBShareViewController alloc] initWithShareItems:self.shareItems];
    vc.baseController = self;
    vc.image = [UIImage imageNamed:@"demoImage.jpg"];
    [self presentViewController:vc animated:YES completion:nil];
}

//分享视频
- (void)goShareVideo {
    FBShareViewController *vc = [[FBShareViewController alloc] initWithShareItems:self.shareItems];
    vc.baseController = self;
    
    NSString *demoVideo = [[NSBundle mainBundle] pathForResource:@"demoVideo" ofType:@"MOV"];
    vc.videoUrl = [NSURL fileURLWithPath:demoVideo];
    [self presentViewController:vc animated:YES completion:nil];
}
```


