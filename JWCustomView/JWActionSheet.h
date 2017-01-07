//
//  JWActionSheet.h
//  JWActionSheet
//
//  Created by huangjw on 16/1/4.
//  Copyright © 2016年 midea. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ActionSheetButtonType) {
    ActionSheetButtonTypeDefault = 0,
    ActionSheetButtonTypeDisabled,
    ActionSheetButtonTypeDestructive
};

@class JWActionSheet;

typedef void(^ActionHandler)(JWActionSheet *sheet);

@interface JWActionSheet : UIView

@property (nonatomic, copy) NSString     *cancelTitle;
@property (nonatomic, copy) NSDictionary *titleTextAttributes;
@property (nonatomic, copy) NSDictionary *buttonTextAttributes;
@property (nonatomic, copy) NSDictionary *buttonSubTextAttributes;
@property (nonatomic, copy) NSDictionary *disabledButtonTextAttributes;
@property (nonatomic, copy) NSDictionary *destructiveButtonTextAttributes;
@property (nonatomic, copy) NSDictionary *cancelButtonTextAttributes;

@property (nonatomic, strong) UIFont     *subFont;
@property (nonatomic, strong) UIFont     *buttonFont;

- (instancetype)initWithTitle:(NSString *)title;
- (void)addButtonWithTitle:(NSString *)title type:(ActionSheetButtonType)type handler:(ActionHandler)handler;
- (void)addButtonWithTitle:(NSString *)title subTitle:(NSString *)subTitle type:(ActionSheetButtonType)type handler:(ActionHandler)handler;
- (void)show;

@end
