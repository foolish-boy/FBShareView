//
//  FBShareAction.m
//  BaBa
//
//  Created by jasonwu on 2018/1/30.
//  Copyright © 2018年 Instanza Inc. All rights reserved.
//

#import "FBShareAction.h"
#import <Social/Social.h>
#import "FBShareViewController.h"
#import "FBShareItem.h"

@interface FBShareAction ()

@property (nonatomic, weak) FBShareViewController *baseController;

@end

@implementation FBShareAction

- (instancetype)initWithBaseController:(FBShareViewController *)baseController
{
    self = [super init];
    if (self) {
        _baseController = baseController;
    }
    return self;
}

#pragma mark - whatsapp
- (void)shareToWhatsApp {
    NSString *urlString = nil;
    if (self.baseController.shareText){
        urlString = [NSString stringWithFormat:@"whatsapp://send?text=%@", [self urlencode:self.baseController.shareText]];
    } else if (self.baseController.shareLink) {
        urlString = [NSString stringWithFormat:@"whatsapp://send?text=%@", [self urlencode:self.baseController.shareLink]];
    }
    if (urlString) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}

// http://stackoverflow.com/questions/8088473/how-do-i-url-encode-a-string
- (NSString *)urlencode:(NSString *)input {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[input UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}


#pragma mark - copy link
- (void)copyLink {
    if (!self.baseController.shareLink) {
        return;
    }
    [UIPasteboard generalPasteboard].string = self.baseController.shareLink;
}
#pragma mark - share action for thirdparty platform
- (void)shareForServiceType:(NSString *)serviceType {
    if (!serviceType) {
        return;
    }
    SLComposeViewController *slc = (SLComposeViewController *)[SLComposeViewController composeViewControllerForServiceType:serviceType];
    slc.completionHandler = ^(SLComposeViewControllerResult result) {
    };
    
    
    if (self.baseController.image) {
        [slc addImage:self.baseController.image];
    } else if (self.baseController.videoUrl){
        [slc setInitialText:self.baseController.shareText];
    } else if (self.baseController.shareText){
        [slc setInitialText:self.baseController.shareText];
    } else if (self.baseController.shareLink) {
        [slc addURL:[NSURL URLWithString:self.baseController.shareLink]];
    } else {
        return;
    }
    [self.baseController presentViewController:slc animated:YES completion:nil];
    
}

#pragma mark - share action to more, use system action
- (void)shareToMore {
    NSArray *excludeTypes = @[@"com.apple.mobilenotes.SharingExtension",
                              @"com.apple.reminders.RemindersEditorExtension",
                              UIActivityTypeAirDrop,
                              UIActivityTypeAddToReadingList,
                              UIActivityTypePrint,
                              UIActivityTypeCopyToPasteboard,
                              UIActivityTypeAssignToContact,
                              UIActivityTypeSaveToCameraRoll,
                              UIActivityTypeAddToReadingList,
                              UIActivityTypePostToFlickr,
                              UIActivityTypePostToVimeo,
                              UIActivityTypePostToTencentWeibo];
    
    UIActivityViewController *activityVC = nil;
    
    if (self.baseController.image) {
        activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.baseController.image]
            applicationActivities:nil];
        
        activityVC.excludedActivityTypes = excludeTypes;
        
    } else if (self.baseController.videoUrl){
        activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.baseController.videoUrl] applicationActivities:nil];
        [activityVC setValue:@"Video" forKey:@"subject"];
        activityVC.excludedActivityTypes = excludeTypes;
    } else if (self.baseController.shareText){
        activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.baseController.shareText]
                                                       applicationActivities:nil];
        activityVC.excludedActivityTypes = excludeTypes;
    } else if (self.baseController.shareLink) {
        activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.baseController.shareLink]
                                                       applicationActivities:nil];
        activityVC.excludedActivityTypes = excludeTypes;
    } else {
        return;
    }
    
    [self.baseController presentViewController:activityVC animated:YES completion:nil];
}

#pragma  mark - BBKVNShareItemDelegate
- (void)shareWithItem:(FBShareItem *)item {
    
    switch (item.platformType) {
        case FBSharePlatformTypeWhatsApp:
        {
            [self shareToWhatsApp];
        }
            break;
        case FBSharePlatformTypeMore:
        {
            [self shareToMore];
        }
            break;
        case FBSharePlatformTypeCopyLink:
        {
            [self copyLink];
        }
            break;
        default:
        {
            [self shareForServiceType:[item getPlatformServiceType]];
        }
            break;
    }
}


@end
