//
//  MBApi.m
//  MB
//
//  Created by Tongtong Xu on 14/11/17.
//  Copyright (c) 2014年 xxx Innovation Co. Ltd. All rights reserved.
//

#import "MBApi.h"
#import "MBApiWebManager.h"

typedef NS_ENUM(NSUInteger, MBApiPostType) {
    MBApiPostTypeRegister,                      //注册
    MBApiPostTypeLoginNormal,                 //正常登录
    MBApiPostTypeLoginThirdParty,            //第三方登录
    MBApiPostTypeGetKeyWord,//关键词
    MBApiPostTypeGetNewDiscount,//最新折扣
    MBApiPostTypeGetHotGoods,//热销产品
    MBApiPostTypeGetStreetShootingGoods,//明星同款
    MBApiPostTypeGetGoodsWithCondition,//条件搜索
    MBApiPostTypeGetGoodsInfo,//查看商品信息
    MBApiPostTypeCollecteGoods,//收藏商品
    MBApiPostTypeGetCollecteOrderGoods,//获取收藏的商品
    MBApiPostTypeFeedback,//反馈
    MBApiPostTypeFindPassword,//找回密码
};

typedef void(^MBApiPostBlock)(MBApiError *error,id array);

@implementation MBApi

#pragma mark - Base Post Request

+ (void)postWithTokenURL:(NSString *)url parameters:(NSDictionary *)dic handleErrorBlock:(MBApiPostBlock)block
{
    if (url && url.length > 0) {
        [[MBApiWebManager shareWithToken] POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block([MBApiError shareWithCode:[(NSDictionary *)responseObject integerForKey:@"code"] message:[(NSDictionary *)responseObject stringForKey:@"message"]],nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block([MBApiError shareNetworkError],nil);
        }];
    }
}

+ (void)postWithTokenURL:(NSString *)url parameters:(NSDictionary *)dic handleArrayBlock:(MBApiPostBlock)block
{
    if (url && url.length > 0) {
        [[MBApiWebManager shareWithToken] POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *object = responseObject;
            id result = [object objectForKey:@"result"];
            block([MBApiError shareWithDictionary:object], result);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block([MBApiError shareNetworkError],nil);
        }];
    }
}

#pragma mark - functions

+ (void)registerNewUserWithUserName:(NSString *)userName password:(NSString *)password email:(NSString *)mail handle:(MBApiErrorBlock)block
{
    [[MBApiWebManager shareWithoutToken] POST:[self urlWithPostType:MBApiPostTypeRegister] parameters:@{@"userName":userName,@"password":password,@"email":mail} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block ([self dealWithRegisterSuccessResult:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block ([MBApiError shareNetworkError]);
    }];
}

+ (void)loginWithType:(MBLoginType)type userName:(NSString *)userName password:(NSString *)password token:(NSString *)token handle:(MBApiErrorBlock)block
{
    if (type == MBLoginTypeNormal) {
        [[MBApiWebManager shareWithoutToken] POST:[self urlWithPostType:MBApiPostTypeLoginNormal] parameters:@{@"userName":userName,@"password":password} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kMBMODELUSERNAMEKEY];
            block ([self dealWithLoginSuccessResult:responseObject]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block ([MBApiError shareNetworkError]);
        }];
    }else{
        [[MBApiWebManager shareWithoutToken] POST:[self urlWithPostType:MBApiPostTypeLoginThirdParty] parameters:@{@"thirdPartyType":(type == MBLoginTypeQQ ? @"QQ":@"MICROBLOG"),@"thirdPartyToken":token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block ([self dealWithLoginSuccessResult:responseObject]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block ([MBApiError shareNetworkError]);
        }];
    }
}

+ (void)getKeyWordWithCompletionHandle:(MBApiArrayBlock)block
{
    NSDictionary *param = nil;
    [self postWithTokenURL:[self urlWithPostType:MBApiPostTypeGetKeyWord] parameters:param handleArrayBlock:^(MBApiError *error, NSArray *array) {
        block(error,array);
    }];
}

+ (void)getNewDiscountGoodsWithCompletionHandle:(MBApiArrayBlock)block
{
    NSDictionary *param = nil;
    [self postWithTokenURL:[self urlWithPostType:MBApiPostTypeGetNewDiscount] parameters:param handleArrayBlock:^(MBApiError *error, id array) {
        block(error,array);
    }];
}

+ (void)getHotGoodsWithCompletionHandle:(MBApiArrayBlock)block
{
    NSDictionary *param = nil;
    [self postWithTokenURL:[self urlWithPostType:MBApiPostTypeGetHotGoods] parameters:param handleArrayBlock:^(MBApiError *error, NSArray *array) {
        block(error,array);
    }];
}

+ (void)getStreetShootingGoodsWithCompletionHandle:(MBApiArrayBlock)block
{
    NSDictionary *param = nil;
    [self postWithTokenURL:[self urlWithPostType:MBApiPostTypeGetStreetShootingGoods] parameters:param handleArrayBlock:^(MBApiError *error, NSArray *array) {
        block(error,array);
    }];
}

+ (void)getGoodsWithPriceRange:(MBGoodsPriceRange)range discount:(MBGoodsDiscount)discount color:(NSString *)color searchContent:(NSString *)content completionHandle:(MBApiArrayBlock)block
{
    NSMutableDictionary *param = @{}.mutableCopy;
    if (range != MBGoodsConditionNoRange) {
        [param setObject:[NSString stringWithFormat:@"%ld",(long)range] forKey:@"priceRange"];
    }
    if (discount != MBGoodsDiscountNoneLimit) {
        [param setObject:@(discount) forKey:@"discount"];
    }
    [param setValue:content forKey:@"searchContent"];
    [param setValue:color forKey:@"color"];
    [self postWithTokenURL:[self urlWithPostType:MBApiPostTypeGetGoodsWithCondition] parameters:param handleArrayBlock:^(MBApiError *error, NSArray *array) {
        block(error,array);
    }];
}

+ (void)getGoodsInfo:(NSString *)goodsID completionHandle:(MBApiArrayBlock)block
{
    NSDictionary *param = @{@"goodId":goodsID};
    [self postWithTokenURL:[self urlWithPostType:MBApiPostTypeGetGoodsInfo] parameters:param handleArrayBlock:^(MBApiError *error, NSDictionary *dic) {
        block(error,dic);
    }];
}

+ (void)collecteGoods:(NSString *)goodsID collecteState:(NSString *)isCollected completionHandle:(MBApiErrorBlock)block
{
    NSDictionary *parems = @{@"goodId":goodsID,@"type":isCollected};
    [self postWithTokenURL:[self urlWithPostType:MBApiPostTypeCollecteGoods] parameters:parems handleErrorBlock:^(MBApiError *error, NSArray *array) {
        block(error);
    }];
}

+ (void)collectOrderGoodCompletionHandle:(MBApiArrayBlock)block
{
    NSDictionary *parems = nil;
    [self postWithTokenURL:[self urlWithPostType:MBApiPostTypeGetCollecteOrderGoods] parameters:parems handleArrayBlock:^(MBApiError *error, NSArray *array) {
        block(error,array);
    }];
}

+ (void)feedbackWithMesage:(NSString *)message completionHandle:(MBApiErrorBlock)block
{
    NSDictionary *parems = @{@"content":message};
    [self postWithTokenURL:[self urlWithPostType:MBApiPostTypeFeedback] parameters:parems handleErrorBlock:^(MBApiError *error, NSArray *array) {
        block(error);
    }];
}

+ (void)findPasswordWithEmail:(NSString *)email completionHandle:(MBApiErrorBlock)block
{
    NSDictionary *parems = @{@"userName":email};
    [self postWithTokenURL:[self urlWithPostType:MBApiPostTypeFindPassword] parameters:parems handleErrorBlock:^(MBApiError *error, NSArray *array) {
        block(error);
    }];
}

+ (NSString *)serverImageURLWithImageName:(NSString *)imageName

/**
 * 为指定的URL处理图片
 **/

{
    if (imageName.length > 0) {
        return [MBURLBASE stringByAppendingFormat:@"/MyBlaire/upload/%@",imageName];
    }
    return nil;
}

#pragma mark - 功能性url

+ (NSString *)urlWithPostType:(MBApiPostType)type
{
    NSString *url = nil;
    switch (type) {
        case MBApiPostTypeRegister:
            url = @"MyBlaire/app/register";
            break;
        case MBApiPostTypeLoginNormal:
            url = @"MyBlaire/app/normalLogin";
            break;
        case MBApiPostTypeLoginThirdParty:
            url = @"MyBlaire/app/thirdPartyLogin";
            break;
        case MBApiPostTypeFeedback:
            url = @"MyBlaire/app/saveFeedback";
            break;
        case MBApiPostTypeGetCollecteOrderGoods:
            url = @"MyBlaire/app/collectOrder";
            break;
        case MBApiPostTypeCollecteGoods:
            url = @"MyBlaire/app/collectGood";
            break;
        case MBApiPostTypeGetGoodsInfo:
            url = @"MyBlaire/app/getGoodDetailed";
            break;
        case MBApiPostTypeGetHotGoods:
            url = @"MyBlaire/app/getHotGoods";
            break;
        case MBApiPostTypeGetGoodsWithCondition:
            url = @"MyBlaire/app/getGoods";
            break;
        case MBApiPostTypeGetStreetShootingGoods:
            url = @"MyBlaire/app/getStreetShootingGoods";
            break;
        case MBApiPostTypeGetKeyWord:
            url = @"MyBlaire/app/getKeyWord";
            break;
        case MBApiPostTypeGetNewDiscount:
            url = @"MyBlaire/app/newDiscount";
            break;
        case MBApiPostTypeFindPassword:
            url = @"MyBlaire/app/findPWD";
        default:
            break;
    }
    return url;
}

#pragma mark - 处理注册的结果

+ (MBApiError *)dealWithRegisterSuccessResult:(NSDictionary *)responseObject
{
    return [MBApiError shareWithCode:[responseObject integerForKey:@"code"] message:[(NSDictionary *)responseObject stringForKey:@"message"]];
}

#pragma mark - 处理登录的结果

+ (MBApiError *)dealWithLoginSuccessResult:(NSDictionary *)responseObject
{
    MBApiError *error = [MBApiError shareWithDictionary:responseObject];
    if (error.code == MBApiCodeSuccess) {
        [[NSUserDefaults standardUserDefaults] setObject:[[responseObject dictionaryForKey:@"result"] stringForKey:@"token"] forKey:kMBMODELTOKENKEY];
    }
    return error;
}


@end
