//
//  TabMyOrderItemCell.m
//  ygcr
//
//  Created by 黄治华(Tony Wong) on 15/06/03.
//  Copyright © 2015年 黄治华. All rights reserved.
//
//  @email 908601756@qq.com
//
//  @license The MIT License (MIT)
//

#import "TabMyOrderItemCell.h"

@interface TabMyOrderItemCell ()
{
    UIImageView *_vPenddingImage;
    UILabel *_vPenddingLabel;
    
    UIImageView *_vShippingImage;
    UILabel *_vShippingLabel;
    
    UIImageView *_vSuccessImage;
    UILabel *_vSuccessLabel;
}

@end

@implementation TabMyOrderItemCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    //划分为三个等宽的方格
    CGFloat gridWidth = self.frame.size.width / 3;
    UIView *grid1 = [UIView new];
    UIView *grid2 = [UIView new];
    UIView *grid3 = [UIView new];
    [self addSubview:grid1];
    [self addSubview:grid2];
    [self addSubview:grid3];
    [grid1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.mas_equalTo(gridWidth);
        make.height.equalTo(self);
    }];
    [grid2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grid1.mas_right);
        make.top.equalTo(self);
        make.width.mas_equalTo(gridWidth);
        make.height.equalTo(self);
    }];
    [grid3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grid2.mas_right);
        make.top.equalTo(self);
        make.width.mas_equalTo(gridWidth);
        make.height.equalTo(self);
    }];
    
    _vPenddingImage = [UIImageView new];
    _vPenddingImage.image = [UIImage imageNamed:@"icon_my_wallet"];
    [grid1 addSubview:_vPenddingImage];
    [_vPenddingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(grid1);
        make.top.equalTo(grid1).with.offset(4);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    _vPenddingLabel = [UILabel new];
    _vPenddingLabel.text = @"待付款";
    _vPenddingLabel.font = [UIFont systemFontOfSize:12];
    _vPenddingLabel.textColor = kColorMainGrey;
    [grid1 addSubview:_vPenddingLabel];
    [_vPenddingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(grid1);
        make.top.equalTo(_vPenddingImage.mas_bottom).with.offset(2);
    }];
    
    _vShippingImage = [UIImageView new];
    _vShippingImage.image = [UIImage imageNamed:@"icon_my_car"];
    [grid2 addSubview:_vShippingImage];
    [_vShippingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(grid2);
        make.top.equalTo(_vPenddingImage);
        make.width.equalTo(_vPenddingImage);
        make.height.equalTo(_vPenddingImage);
    }];
    
    _vShippingLabel = [UILabel new];
    _vShippingLabel.text = @"待收货";
    _vShippingLabel.font = _vPenddingLabel.font;
    _vShippingLabel.textColor = _vPenddingLabel.textColor;
    [grid2 addSubview:_vShippingLabel];
    [_vShippingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(grid2);
        make.top.equalTo(_vPenddingLabel);
    }];
    
    _vSuccessImage = [UIImageView new];
    _vSuccessImage.image = [UIImage imageNamed:@"icon_my_review"];
    [grid3 addSubview:_vSuccessImage];
    [_vSuccessImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(grid3);
        make.top.equalTo(_vPenddingImage);
        make.width.equalTo(_vPenddingImage);
        make.height.equalTo(_vPenddingImage);
    }];
    
    _vSuccessLabel = [UILabel new];
    _vSuccessLabel.text = @"交易完成";
    _vSuccessLabel.font = _vPenddingLabel.font;
    _vSuccessLabel.textColor = _vPenddingLabel.textColor;
    [grid3 addSubview:_vSuccessLabel];
    [_vSuccessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(grid3);
        make.top.equalTo(_vPenddingLabel);
    }];
    
    return self;
}

@end