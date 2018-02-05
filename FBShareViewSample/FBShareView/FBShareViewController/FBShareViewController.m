//
//  FBShareListView.m
//  BaBa
//
//  Created by jasonwu on 2018/1/30.
//  Copyright © 2018年 Instanza Inc. All rights reserved.
//

#import "FBShareViewController.h"
#import "FBShareItemsView.h"
#import "FBShareItem.h"
#import "FBShareAction.h"

static const CGFloat    itemsViewHeight = 140;
static const CGFloat    maskViewAlpha = 0.5;

@interface FBShareViewController ()

@property (nonatomic, strong) NSArray          *shareItems;
@property (nonatomic, strong) UIView           *maskView;
@property (nonatomic, strong) FBShareItemsView *itemsView;
@property (nonatomic, strong) FBShareAction    *shareAction;

@end

@implementation FBShareViewController

- (instancetype)initWithShareItems:(NSArray *)shareItems
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        _shareAction = [[FBShareAction alloc] initWithBaseController:self];
        _shareItems = [self processShareItems:shareItems];
        
        [self.view addSubview:self.maskView];
        [self.view addSubview:self.itemsView];
    }
    return self;
}

/**
 处理初始的分享项目，主要赋值delegate和baseController

 @param shareItems 初始的分享项目数组
 @return 处理过后的数组
 */
- (NSArray *)processShareItems:(NSArray *)shareItems {
    NSMutableArray *mutItems = [NSMutableArray arrayWithArray:shareItems];
    for (id item in mutItems) {
        if (![item isKindOfClass:[FBShareItem class]]) {
            continue;
        }
        FBShareItem *shareItem = (FBShareItem *)item;
        shareItem.delegate = self.shareAction;
        shareItem.baseController = self;
    }
    return mutItems;
}

- (void)tapMaskView {
    [self.baseController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - lazy load
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:maskViewAlpha];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskView)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (FBShareItemsView *)itemsView {
    if (!_itemsView) {
        
        _itemsView = [[FBShareItemsView alloc]
                      initWithFrame:CGRectMake(0, self.view.bounds.size.height - itemsViewHeight, self.view.bounds.size.width, itemsViewHeight)
                      shareItems:self.shareItems];
    }
    return _itemsView;
}

@end
