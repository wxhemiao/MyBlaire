//
//  MBKeyWord.h
//  MB
//
//  Created by Tongtong Xu on 14/11/17.
//  Copyright (c) 2014年 xxx Innovation Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBKeyWord : NSObject
@property (nonatomic) NSString *wordKey, *wordValue;

+ (NSArray *)shareWithArray:(NSArray *)array;
@end
