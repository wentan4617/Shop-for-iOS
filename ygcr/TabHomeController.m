//
//  TabHomeController.m
//  ygcr
//
//  Created by 黄治华(Tony Wong) on 15/06/03.
//  Copyright © 2015年 黄治华. All rights reserved.
//
//  @email 908601756@qq.com
//
//  @license The MIT License (MIT)
//

#import "TabHomeController.h"
#import "ProductController.h"
#import "CategoryModel.h"
#import "CategoryEntity.h"
#import "ProductEntity.h"
#import "TabHomeRightTableCell.h"

@interface TabHomeController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_leftTable;
    
    UITableView *_rightTable;
    
    CGFloat _leftTableWidth;
    
    NSInteger _leftTableCurRow; //当前被选中的行
    
    NSArray *_categories;
}
@end

@implementation TabHomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.title = @"月光茶人";
    
    _leftTableWidth = 100.f;
    
    _leftTable = [[UITableView alloc] init];
    _leftTable.tableFooterView = [[UIView alloc]init]; //去掉多余的空行分割线
    _leftTable.backgroundColor = [UIColor hexColor:@"ececec"];
    _leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_leftTable];
    [_leftTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.width.mas_equalTo(_leftTableWidth);
        make.height.equalTo(self.view);
    }];
    _leftTable.dataSource = self;
    _leftTable.delegate = self;
    _leftTableCurRow = 0;
    
    _rightTable = [[UITableView alloc] init];
    _rightTable.tableFooterView = [[UIView alloc]init]; //去掉多余的空行分割线
    [self.view addSubview:_rightTable];
    [_rightTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftTable.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view).with.offset(64);
        make.height.equalTo(self.view).with.offset(-112);
    }];
    _rightTable.dataSource = self;
    _rightTable.delegate = self;
    
    [self getData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData
{
    __weak typeof (self) weakSelf = self;
    [weakSelf showLoadingView];
    
    [CategoryModel getCategoriesWithProducts:^(BOOL result, NSString *message, NSArray *categories) {
        if (result) {
            _categories = categories;
            [_leftTable reloadData];
            [_rightTable reloadData];
            
            //设置选中leftTable的第一行
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [_leftTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            [weakSelf tableView:_leftTable didSelectRowAtIndexPath:indexPath];
        } else {
            [weakSelf toast:message];
        }
        [weakSelf hideLoadingView];
        [weakSelf hideNetworkBrokenView];
    } failure:^(NSError *error) {
        //网络没有连接
        if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorNotConnectedToInternet) {
            [weakSelf showNetworkBrokenView:^(MASConstraintMaker *make) {
                make.left.equalTo(_leftTable.mas_right);
                make.right.equalTo(self.view.mas_right);
                make.top.equalTo(self.view).with.offset(64);
                make.height.equalTo(self.view).with.offset(-112);
            }];
        } else {
            [weakSelf toastWithError:error];
        }
        [weakSelf hideLoadingView];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int num = 0;
    //leftTable
    if (tableView == _leftTable) {
        num = 1;
    }
    //rightTable
    else if (tableView == _rightTable) {
        num = 1;
    }
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    //leftTable
    if (tableView == _leftTable) {
        if (_categories && _categories.count > 0) {
            num = _categories.count;
        }
    }
    //rightTable
    else if (tableView == _rightTable) {
        if (_categories && _categories.count > 0) {
            CategoryEntity *category = _categories[_leftTableCurRow];
            num = category.products.count;
        }
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //leftTable
    if (tableView == _leftTable) {
        NSString *identifier = @"leftTableCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor hexColor:@"ececec"];
        }
        CategoryEntity *category = _categories[indexPath.row];
        cell.textLabel.text = category.name;
        return cell;
    }
    //rightTable
    else {
        NSString *identifier = @"rightTableCell";
        TabHomeRightTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[TabHomeRightTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        CategoryEntity *category = _categories[_leftTableCurRow];
        ProductEntity *product = category.products[indexPath.row];
        [cell fillContentWithProduct:product];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    //leftTable
    if (tableView == _leftTable) {
        height = 50;
    }
    //rightTable
    else if (tableView == _rightTable) {
        height = [TabHomeRightTableCell height];
    }
    return height;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //leftTable，更新rightTable的数据
    if (tableView == _leftTable) {
        _leftTableCurRow = indexPath.row;
        [tableView cellForRowAtIndexPath:indexPath].backgroundColor = kColorWhite;
        [_rightTable reloadData];
    }
    //rightTable
    else if (tableView == _rightTable) {
        CategoryEntity *category = _categories[_leftTableCurRow];
        ProductEntity *product = category.products[indexPath.row];
        ProductController *productController = [[ProductController alloc] initWithProductId:product.id];
        [self.navigationController pushViewController:productController animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
{
    //leftTable
    if (tableView == _leftTable) {
        [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor hexColor:@"ececec"];
    }
}

- (void)doClickNetworkBrokenView
{
    [self getData];
}

@end
