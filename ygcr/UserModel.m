//
//  UserModel.m
//  ygcr
//
//  Created by 黄治华(Tony Wong) on 15/07/27.
//  Copyright © 2015年 黄治华. All rights reserved.
//
//  @email 908601756@qq.com
//
//  @license The MIT License (MIT)
//

#import "UserModel.h"

@implementation UserModel

//通过本地的存储信息判断用户是否登录
+ (BOOL)isUserLoginByStorage
{
    NSString *userId = [StorageUtil getUserId];
    NSString *appLoginToken = [StorageUtil getAppLoginToken];
    if (userId.length > 0 && appLoginToken.length > 0) {
        return YES;
    } else {
        return NO;
    }
}


//===== 与服务器交互的方法 =====//

//获取用户信息
+ (void)getUser:(void(^)(BOOL result, NSNumber *resultCode, NSString *message, UserEntity *user))success
        failure:(void(^)(NSError *error))failure
{
    NSString *url = kUrlUserGet;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[StorageUtil getUserId] forKey:kStorageUserId];
    [params setObject:[StorageUtil getAppLoginToken] forKey:kStorageAppLoginToken];
    
    [HttpClient requestJson:url
                     params:params
                    success:^(BOOL result, NSNumber *resultCode, NSString *message, NSDictionary *data) {
                        UserEntity *user = nil;
                        if (result) {
                            NSDictionary *userDict = [data objectForKey:@"user"];
                            user = [[UserEntity alloc] initWithDictionary:userDict];
                        }
                        success(result, resultCode, message, user);
                    }
                    failure:failure];
}

//登录
+ (void)loginWithMobile:(NSString *)mobile
               password:(NSString *)password
                success:(void(^)(BOOL result, NSNumber *resultCode, NSString *message, UserEntity *user, NSString *appCartCookieId))success
                failure:(void(^)(NSError *error))failure
{
    NSString *url = kUrlUserLogin;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   mobile,   @"username",
                                   password, @"password", nil];
    [HttpClient requestJson:url
                     params:params
                    success:^(BOOL result, NSNumber *resultCode, NSString *message, NSDictionary *data) {
                        NSString *appCartCookieId = nil;
                        UserEntity *user = nil;
                        if (result) {
                            appCartCookieId = [data objectForKey:kStorageAppCartCookieId];
                            NSDictionary *userDict = [data objectForKey:@"user"];
                            user = [[UserEntity alloc] initWithDictionary:userDict];
                            [UserModel saveUserInfoToStorage:user];
                            [StorageUtil saveAppCartCookieId:appCartCookieId];
                        }
                        success(result, resultCode, message, user, appCartCookieId);
                    }
                    failure:failure];
}

//保存用户信息到本地
+ (void)saveUserInfoToStorage:(UserEntity *)user
{
    [StorageUtil saveUserId:user.id];
    [StorageUtil saveUserLevel:user.level];
    [StorageUtil saveUserMobile:user.mobile];
    [StorageUtil saveAppLoginToken:user.appLoginToken];
}

@end
