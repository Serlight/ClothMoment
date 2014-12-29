//
//  ClothTypeViewController.m
//  SB
//
//  Created by serlight on 12/2/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "ClothTypeViewController.h"
#import "Cloth.h"

@interface ClothTypeViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSInteger selectTypeIndex;
    NSArray *clothsOfType;
}

@property(strong, nonatomic)NSArray *cloths;

@end

@implementation ClothTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _cloths = [NSArray array];
    selectTypeIndex = 0;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_cloths.count == 0) {
        [self showHudInView:self.view hint:@"加载数据"];
        [Cloth getClothsTypeWithBlock:^(ResponseType responseType, id responseObj) {
            [self hideHud];
            if (responseType == RequestSucceed) {
                _cloths = responseObj;
                [_typeTableView reloadData];
                [_contentTableView reloadData];
                [_typeTableView.delegate tableView:_typeTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _typeTableView) {
        return _cloths.count;
    } else {
        if (_cloths.count == 0) {
            return 0;
        }
        clothsOfType = [_cloths[selectTypeIndex] objectForKey:@"lists"];
        return clothsOfType.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _typeTableView) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = _cloths[indexPath.row][@"pid"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = clothsOfType[indexPath.row][@"name"];
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _typeTableView) {
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self setCellColor:UIColorFromRGB(100, 200, 200) forCell:cell];
        clothsOfType = [_cloths[indexPath.row] objectForKey:@"lists"];
        selectTypeIndex = indexPath.row;
        [_contentTableView reloadData];
    } else {
        [self.delegate getClothType:clothsOfType[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _typeTableView) {
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self setCellColor:[UIColor blackColor] forCell:cell];
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _typeTableView) {
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self setCellColor:UIColorFromRGB(100, 200, 200) forCell:cell];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _typeTableView) {
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self setCellColor:[UIColor blackColor] forCell:cell];
    }
}

- (void)setCellColor:(UIColor *)color forCell:(UITableViewCell *)cell {
    cell.textLabel.textColor = color;
}



@end
