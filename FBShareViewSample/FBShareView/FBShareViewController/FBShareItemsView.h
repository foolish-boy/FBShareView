//
//  FBShareItemsView.h
//  BaBa
//
//  Created by jasonwu on 2018/1/30.
//  Copyright © 2018年 Instanza Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBShareItem;

@interface FBShareItemCell : UICollectionViewCell

@property (nonatomic, strong) FBShareItem *item;

- (void)setWithShareItem:(FBShareItem *)item;

@end

@interface FBShareItemsView : UIView

- (instancetype)initWithFrame:(CGRect)frame shareItems:(NSArray*)items;

@end
