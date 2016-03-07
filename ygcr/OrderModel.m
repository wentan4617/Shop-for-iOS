//
//  OrderModel.m
//  ygcr
//
//  Created by 黄治华(Tony Wong) on 15/07/27.
//  Copyright © 2015年 黄治华. All rights reserved.
//
//  @email 908601756@qq.com
//
//  @license The MIT License (MIT)
//

#import "OrderModel.h"

@implementation OrderModel

//提交订单
+ (void)addWithPreorderId:(NSString *)preorderId
                addressId:(NSString *)addressId
                   notice:(NSString *)notice
                  success:(void(^)(BOOL result, NSNumber *resultCode, NSString *message, OrderEntity *order))success
                  failure:(void(^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:kUrlOrderAddWithPreorderId, preorderId];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   addressId,   @"addressId",
                                   notice,      @"notice", nil];
    [HttpClient requestJson:url
                     params:params
                    success:^(BOOL result, NSNumber *resultCode, NSString *message, NSDictionary *data) {
                        OrderEntity *order = nil;
                        if (result) {
                            NSDictionary *orderDict = [data objectForKey:@"order"];
                            order = [[OrderEntity alloc] initWithDictionary:orderDict];
                        }
                        success(result, resultCode, message, order);
                    }
                    failure:failure];
}

//获取订单
+ (void)getOrderWithId:(NSString *)orderId
               success:(void(^)(BOOL result, NSNumber *resultCode, NSString *message, OrderEntity *order, NSArray *orderItems))success
               failure:(void(^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:kUrlOrderViewWithId, orderId];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   orderId,   @"orderId", nil];
    [HttpClient requestJson:url
                     params:params
                    success:^(BOOL result, NSNumber *resultCode, NSString *message, NSDictionary *data) {
                        OrderEntity *order = nil;
                        NSMutableArray *orderItems = [NSMutableArray new];
                        if (result) {
                            NSDictionary *orderDict = [data objectForKey:@"order"];
                            NSArray *orderItemList = [data objectForKey:@"orderItemList"];
                            order = [[OrderEntity alloc] initWithDictionary:orderDict];
                            for (NSDictionary *itemDict in orderItemList) {
                                OrderItemEntity *item = [[OrderItemEntity alloc] initWithDictionary:itemDict];
                                [orderItems addObject:item];
                            }
                        }
                        success(result, resultCode, message, order, [orderItems copy]);
                    }
                    failure:failure];
}

@end
