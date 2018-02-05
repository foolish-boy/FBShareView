//
//  FBShareAction.h
//  BaBa
//
//  Created by jasonwu on 2018/1/30.
//  Copyright © 2018年 Instanza Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FBShareItem.h"

@class FBShareViewController;

@interface FBShareAction : NSObject  <FBShareItemDelegate,UIDocumentInteractionControllerDelegate>

- (instancetype)initWithBaseController:(FBShareViewController *)baseController;

@end
