//
//  FBShareItem.m
//  BaBa
//
//  Created by jasonwu on 2018/1/30.
//  Copyright © 2018年 Instanza Inc. All rights reserved.
//

#import "FBShareItem.h"
#import <Social/Social.h>
#import "FBShareViewController.h"

@implementation FBShareItem


- (instancetype)initWithPlatformType:(FBSharePlatformType)platform
{
    self = [super init];
    _platformType = platform;
    if (self) {
        switch (platform) {
            case FBSharePlatformTypeFacebook:
            {
                _iconName  = @"ic_facebook";
                _itemTitle = @"Facebook";
            }
                break;
            case FBSharePlatformTypeTwitter:
            {
                _iconName  = @"ic_twitter";
                _itemTitle = @"Twitter";
            }
                break;
            case FBSharePlatformTypeInstagram:
            {
                _iconName  = @"ic_Instagram";
                _itemTitle = @"Instagram";
            }
                break;
            case FBSharePlatformTypeWhatsApp:
            {
                _iconName  = @"ic_whatsapp";
                _itemTitle = @"WhatsApp";
            }
                break;
            case FBSharePlatformTypeSnapchat:
            {
                _iconName  = @"ic_snapchat";
                _itemTitle = @"Snapchat";
            }
                break;
            case FBSharePlatformTypeWeChat:
            {
                _iconName  = @"ic_wechat";
                _itemTitle = @"WeChat";
            }
                break;
            case FBSharePlatformTypeCopyLink:
            {
                _iconName  = @"btn_anonymous_add";
                _itemTitle = @"Copy Link";
            }
                break;
            case FBSharePlatformTypeMore:
            {
                _iconName  = @"ic_more";
                _itemTitle = @"More";
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (NSString *)getPlatformServiceType {
    NSString *serviceType = nil;
    switch (_platformType) {
        case FBSharePlatformTypeFacebook:
        {
            serviceType = SLServiceTypeFacebook;
        }
            break;
        case FBSharePlatformTypeTwitter:
        {
            serviceType = SLServiceTypeTwitter;
        }
            break;
        case FBSharePlatformTypeInstagram:
        {
            serviceType = @"com.burbn.instagram.shareextension";
        }
            break;
        case FBSharePlatformTypeSnapchat:
        {
            serviceType = @"com.toyopagroup.picaboo.share";
        }
            break;
        case FBSharePlatformTypeWeChat:
        {
            serviceType = @"com.tencent.xin.sharetimeline";
        }
            break;
        default:
            break;
    }
    return serviceType;
}

- (BOOL)avaliableToShare {
    if (_platformType == FBSharePlatformTypeMore) {
        return true;
    }
    //有链接时才支持copy
    if (_platformType == FBSharePlatformTypeCopyLink) {
        return self.baseController.shareLink;
    }
    
    //除了more 均不支持直接分享视频
    if (self.baseController.videoUrl) {
        return NO;
    }
    //whatsapp不支持直接分享图片、视频
    if (_platformType == FBSharePlatformTypeWhatsApp) {
        if (self.baseController.image) {
            return NO;
        }
        return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://app"]];
    }
    

    
    NSString *serviceType = [self getPlatformServiceType];
    SLComposeViewController *composeVc = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    if (!composeVc) {
        return false;
    }
    if (![SLComposeViewController isAvailableForServiceType:serviceType]) {
        return false;
    }
    return true;
}


/**
 通过选中的途径分享，如果需要先做网络请求获取分享内容，
 要等网络请求成功之后再做真正的分享
 */
- (void)shareWithMe {
    __weak typeof(self) weakSelf = self;
    if (self.netRequestDelegate && [self.netRequestDelegate respondsToSelector:@selector(doNetworkRequestBeforeShare:failure:)]) {
        [self.netRequestDelegate doNetworkRequestBeforeShare:^(NSDictionary *dic) {
            weakSelf.baseController.shareText = dic[@"text"];
            weakSelf.baseController.shareLink = dic[@"link"];
            weakSelf.baseController.image = dic[@"image"];
            weakSelf.baseController.videoUrl = dic[@"videourl"];
            [weakSelf realShareAction];
        } failure:^(NSDictionary *dic) {
            //fail
        }];
    } else {
        [self realShareAction];
    }
    
}

//真正做分享操作
- (void)realShareAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareWithItem:)]) {
        [self.delegate shareWithItem:self];
    }
}
@end
