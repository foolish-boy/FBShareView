//
//  FBShareViewController.h
//  BaBa
//
//  Created by jasonwu on 2018/1/30.
//  Copyright © 2018年 Instanza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBShareViewController : UIViewController

//set one of them
@property (nonatomic, strong) UIImage   *image;//for image
@property (nonatomic, strong) NSURL     *videoUrl;//for video;
@property (nonatomic, copy)   NSString  *shareText;//文本内容 可能是链接与文字拼接的
@property (nonatomic, copy)   NSString  *shareLink;//纯链接
@property (nonatomic, weak)   UIViewController    *baseController;


- (instancetype)initWithShareItems:(NSArray *)shareItems;

@end
