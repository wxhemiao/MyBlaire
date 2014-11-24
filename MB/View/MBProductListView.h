//
//  MBProductListView.h
//  MB
//
//  Created by Tongtong Xu on 14/11/14.
//  Copyright (c) 2014年 xxx Innovation Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProductModel;

typedef void(^MBProductListViewSelecteGoodsBlock)(MBProductModel *model);


@interface MBProductListView : UIView

- (void)resetDatasource:(NSArray *)array;

@property (nonatomic, copy) MBProductListViewSelecteGoodsBlock selecteGoodsBlock;
@property (nonatomic, copy) TTXActionBlock collecteGoodsBlock;

@end
