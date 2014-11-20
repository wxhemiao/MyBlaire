//
//  MBProductModel.m
//  MB
//
//  Created by Tongtong Xu on 14/11/14.
//  Copyright (c) 2014年 xxx Innovation Co. Ltd. All rights reserved.
//

#import "MBProductModel.h"

@implementation MBProductModel

#define kGOODSIMAGEHEADER

+ (instancetype)shareProduct:(NSDictionary *)dic
{
    MBProductModel *model = [[MBProductModel alloc] init];
    model.goodId = [dic stringForKey:@"goodId"];
    model.goodName = [dic stringForKey:@"goodName"];
    model.currentPrice = [dic longForKey:@"currentPrice"];
    model.collectCount = [dic intForKey:@"collectCount"];
    model.smallPicture = [MBURLBASE stringByAppendingFormat:@"/MyBlaire/upload/%@",[dic stringForKey:@"smallPicture"]];
    DLog(@"%@",model.smallPicture);
    model.isCollect = [[dic stringForKey:@"isCollect"] boolValue];
    model.imageWidth = 100;
    model.imageHeight = 100;
    return model;
}

+ (NSArray *)productsWithArray:(NSArray *)array
{
    NSMutableArray *mulArray = @[].mutableCopy;
    for (NSDictionary *dic in array) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            MBProductModel *model = [MBProductModel shareProduct:dic];
            [mulArray addObject:model];
        }
    }
    return [NSArray arrayWithArray:mulArray];
}

@end
