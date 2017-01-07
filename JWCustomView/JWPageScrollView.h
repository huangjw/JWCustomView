//
//  JWPageScrollView.h
//  ScrollView
//
//  Created by HuangJiawei on 15/10/26.
//  Copyright © 2015年 HuangJiawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  JWPageScrollDelegate <NSObject>

@optional

- (void)imageTap:(NSInteger)index;

@end

@interface JWPageScrollView : UIView

@property (nonatomic, strong)   NSArray         *images;
@property (nonatomic, strong)   NSArray         *imageURLs;
@property (nonatomic, assign)   NSTimeInterval  duration;
@property (nonatomic, assign)   id<JWPageScrollDelegate>    delegate;

@end
