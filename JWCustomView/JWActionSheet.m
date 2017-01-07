//
//  JWActionSheet.m
//  JWActionSheet
//
//  Created by huangjw on 16/1/4.
//  Copyright © 2016年 midea. All rights reserved.
//

#import "JWActionSheet.h"

static const CGFloat kCellHeight = 50.0f;

@interface JWActionSheetItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) ActionHandler handler;
@property (nonatomic, assign) ActionSheetButtonType type;

@end

@implementation JWActionSheetItem
@end

@interface JWActionSheet()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy)   NSString       *title;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, weak)   UIView         *backView;
@property (nonatomic, weak)   UITableView    *tableView;

@end

@implementation JWActionSheet

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    if (self) {
        self.userInteractionEnabled = YES;
        _items = [[NSMutableArray alloc] init];
        _title = [title copy];
        
        _buttonFont = [UIFont systemFontOfSize:18.0f];
        _subFont = [UIFont systemFontOfSize:12.0f];
        
        //设置字体属性
        _titleTextAttributes = @{ NSFontAttributeName : _subFont,
                                  NSForegroundColorAttributeName : [UIColor darkGrayColor] };
        _buttonTextAttributes = @{ NSFontAttributeName : _buttonFont,
                                   NSForegroundColorAttributeName : [UIColor colorWithRed:37.0/255.0 green:143.0/255.0 blue:247.0/255.0 alpha:1.0] };
        _buttonSubTextAttributes = @{ NSFontAttributeName : _subFont,
                                   NSForegroundColorAttributeName : [UIColor grayColor] };
        _disabledButtonTextAttributes = @{ NSFontAttributeName : _buttonFont,
                                           NSForegroundColorAttributeName : [UIColor grayColor] };
        _destructiveButtonTextAttributes = @{ NSFontAttributeName : _buttonFont,
                                              NSForegroundColorAttributeName : [UIColor redColor] };
        _cancelButtonTextAttributes = @{ NSFontAttributeName : _buttonFont,
                                         NSForegroundColorAttributeName : [UIColor colorWithRed:37.0/255.0 green:143.0/255.0 blue:247.0/255.0 alpha:1.0] };
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithTitle:nil];
}

- (void)addButtonWithTitle:(NSString *)title type:(ActionSheetButtonType)type handler:(ActionHandler)handler
{
    JWActionSheetItem *item = [[JWActionSheetItem alloc] init];
    item.title = title;
    item.type = type;
    item.handler = handler;
    [_items addObject:item];
}

- (void)addButtonWithTitle:(NSString *)title subTitle:(NSString *)subTitle type:(ActionSheetButtonType)type handler:(ActionHandler)handler
{
    JWActionSheetItem *item = [[JWActionSheetItem alloc] init];
    item.title = title;
    item.type = type;
    item.subTitle = subTitle;
    item.handler = handler;
    [_items addObject:item];
}

- (void)show
{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:self];
    [self setupBackgroundView];
    [self setupTableView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha = 1.0;
        CGRect rect = _tableView.frame;
        rect.origin.y -= rect.size.height;
        _tableView.frame = rect;
//        _tableView.transform = CGAffineTransformMakeTranslation(0, 0);
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

- (void)setupBackgroundView
{
    UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    backView.alpha = 0.0;
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [backView addGestureRecognizer:tap];
    _backView = backView;
    [self addSubview:_backView];
}

- (void)setupTableView
{
    CGFloat tableContentHeight = (_items.count + 1)* kCellHeight + 8.0;
    if (_title) {
        tableContentHeight += kCellHeight;
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds), tableContentHeight)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.scrollEnabled = false;
//    tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight([UIScreen mainScreen].bounds), 0, 0, 0);
    
    _tableView = tableView;
    [self addSubview:_tableView];
    [self setupTableViewHeader];
}

- (void)setupTableViewHeader
{
    if (_title) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 50)];
        headerView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = headerView;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, CGRectGetWidth(headerView.frame), 21)];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [label setAttributedText:[[NSAttributedString alloc] initWithString:_title attributes:_titleTextAttributes]];
        [headerView addSubview:label];
    } else  {
        _tableView.tableHeaderView = nil;
    }
}

- (void)dismiss
{
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(ActionHandler)handler
{
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha = 0.0;
        CGRect rect = _tableView.frame;
        rect.origin.y += rect.size.height;
        _tableView.frame = rect;
        //        CGFloat slideDownMinOffset = (CGFloat)fmin(CGRectGetHeight(self.frame) + _tableView.contentOffset.y, CGRectGetHeight(self.frame));
        //        _tableView.transform = CGAffineTransformMakeTranslation(0, slideDownMinOffset);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (handler) {
            handler(self);
        }
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _items.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *attributes = nil;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.section == 1) {
        attributes = _cancelButtonTextAttributes;
        NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:self.cancelTitle ? self.cancelTitle : @"取消" attributes:attributes];
        cell.textLabel.attributedText = attrTitle;
        return cell;
    }
    
    JWActionSheetItem *item = _items[(NSUInteger)indexPath.row];
    switch (item.type) {
        case ActionSheetButtonTypeDefault:
            attributes = _buttonTextAttributes;
            break;
        case ActionSheetButtonTypeDisabled:
            attributes = _disabledButtonTextAttributes;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case ActionSheetButtonTypeDestructive:
            attributes = _destructiveButtonTextAttributes;
            break;
    }
    
    if (indexPath.row > 0 || self.title) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0.5)];
        line.backgroundColor =  [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
        [cell.contentView addSubview:line];
    }
    NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:item.title attributes:attributes];
    cell.textLabel.attributedText = attrTitle;
    
    if (item.subTitle && item.subTitle.length > 0) {
        NSString *text = [NSString stringWithFormat:@"%@  %@",item.subTitle,item.title];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        [attributedString addAttributes:_buttonSubTextAttributes range:NSMakeRange(0, item.subTitle.length)];
        [attributedString addAttributes:attributes range:NSMakeRange(item.subTitle.length + 2, item.title.length)];
        cell.textLabel.attributedText = attributedString;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [self dismissWithCompletion:nil];
        return;
    }
    JWActionSheetItem *item = self.items[(NSUInteger)indexPath.row];
    if (item.type != ActionSheetButtonTypeDisabled) {
        [self dismissWithCompletion:item.handler];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 0.0;
    }
    return 8.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return nil;
    }
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 8)];
    footer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    return footer;
}

@end
