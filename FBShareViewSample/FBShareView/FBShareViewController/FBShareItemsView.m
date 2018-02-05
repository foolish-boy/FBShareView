//
//  FBShareItemsView.m
//  BaBa
//
//  Created by jasonwu on 2018/1/30.
//  Copyright © 2018年 Instanza Inc. All rights reserved.
//

#import "FBShareItemsView.h"
#import "FBShareItem.h"


static const int itemWitdh = 68;
static const int itemHeight = 98;
static const int itemIconSize = 44;
static NSString* kItemCellReuseId = @"kItemCellReuseIdentifier";

#pragma mark - FBShareItemCell
@interface FBShareItemCell ()

@property (nonatomic, strong) UIImageView *itemIcon;
@property (nonatomic, strong) UILabel     *itemLabel;

@end

@implementation FBShareItemCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:_itemIcon];
        
        _itemLabel = [UILabel new];
        _itemLabel.font = [UIFont systemFontOfSize:12];
        _itemLabel.textAlignment = NSTextAlignmentCenter;
        _itemLabel.numberOfLines = 2;
        [self.contentView addSubview:_itemLabel];
    }
    return self;
}

- (void)setWithShareItem:(FBShareItem *)item {
    _item = item;
    
    _itemIcon.image = [UIImage imageNamed:item.iconName];
    _itemLabel.text = item.itemTitle;
    
    _itemIcon.frame = CGRectMake((self.contentView.frame.size.width - itemIconSize)/2.0,2, itemIconSize, itemIconSize);
    
    CGFloat labelMargin = 2;
    CGFloat maxWidth = self.contentView.frame.size.width - 2 * labelMargin;
    CGSize size = [_itemLabel sizeThatFits:CGSizeMake(maxWidth, MAXFLOAT)];
    _itemLabel.frame = CGRectMake(labelMargin, CGRectGetMaxY(_itemIcon.frame)+10, maxWidth,size.height);
}
@end


#pragma mark - FBShareItemView

@interface FBShareItemsView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *shareItems;

@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FBShareItemsView

- (instancetype)initWithFrame:(CGRect)frame shareItems:(NSArray*)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.shareItems = [NSMutableArray arrayWithArray:items];
        [self addSubview:self.lbTitle];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self filterAvalibleShareItems];
    [self.collectionView reloadData];
}

- (void)filterAvalibleShareItems{
    NSMutableArray *tmpArr = [self.shareItems mutableCopy];
    for (int i = 0; i < tmpArr.count; i ++) {
        FBShareItem *item = tmpArr[i];
        if (![item avaliableToShare]) {
            [self.shareItems removeObject:item];
        }
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.shareItems.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FBShareItem *item = [self.shareItems objectAtIndex:indexPath.row];
    
    FBShareItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kItemCellReuseId forIndexPath:indexPath];
    [cell setWithShareItem:item];
    
    return cell;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FBShareItemCell *cell = (FBShareItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        [cell.item shareWithMe];
    }
}

#pragma mark - setter
- (UILabel *)lbTitle {
    if (!_lbTitle) {
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.bounds.size.width, 15)];
        _lbTitle.text = @"Share To";
        _lbTitle.font = [UIFont systemFontOfSize:12];
        _lbTitle.textColor = [UIColor grayColor];
        _lbTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _lbTitle;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat oringY = CGRectGetMaxY(self.lbTitle.frame)+18;
        CGRect collectionFrame = CGRectMake(0, oringY, self.bounds.size.width, self.bounds.size.height - oringY);
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
        flowLayout.itemSize = CGSizeMake(itemWitdh, itemHeight);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        [_collectionView registerClass:[FBShareItemCell class] forCellWithReuseIdentifier:kItemCellReuseId];
    }
    return _collectionView;
}
@end

