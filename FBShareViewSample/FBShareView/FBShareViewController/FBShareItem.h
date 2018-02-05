//
//  FBShareItem.h
//  BaBa
//
//  Created by jasonwu on 2018/1/30.
//  Copyright © 2018年 Instanza Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FBSharePlatformType) {
    FBSharePlatformTypeWhatsApp,
    FBSharePlatformTypeFacebook,
    FBSharePlatformTypeTwitter,
    FBSharePlatformTypeInstagram,
    FBSharePlatformTypeSnapchat,
    FBSharePlatformTypeWeChat,
    FBSharePlatformTypeCopyLink,
    FBSharePlatformTypeMore,
    FBSharePlatformTypeNum
};


@class FBShareItem;

//点击具体分享按钮的事件代理
@protocol FBShareItemDelegate <NSObject>

- (void)shareWithItem:(FBShareItem *)item;

@end


typedef void (^netRequestSuccess)(NSDictionary *dic);
typedef void (^netRequestFail)(NSDictionary *dic);

//optional的代理，使用场景少。
//在点击分享按钮后需要做异步网络请求的时候用到
@protocol FBShareNetRequestDelegate <NSObject>

@optional
- (void)doNetworkRequestBeforeShare:(netRequestSuccess)success failure:(netRequestFail)fail;

@end


@class FBShareViewController;

@interface FBShareItem : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *itemTitle;
@property (nonatomic, assign) FBSharePlatformType platformType;
@property (nonatomic, weak) id<FBShareItemDelegate> delegate;
@property (nonatomic, weak) id<FBShareNetRequestDelegate> netRequestDelegate;
@property (nonatomic, weak) FBShareViewController *baseController;


- (instancetype)initWithPlatformType:(FBSharePlatformType)platform;
- (NSString *)getPlatformServiceType;
- (BOOL)avaliableToShare;
- (void)shareWithMe;

@end
