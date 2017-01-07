//
//  JWFooterLoadView.m
//  Pods
//
//  Created by huangjw on 16/8/19.
//
//

#import "JWFooterLoadView.h"

@interface JWFooterLoadView()

@property (nonatomic, strong)   UILabel *tipsLabel;
@property (nonatomic, strong)   UIActivityIndicatorView *actView;

@end

@implementation JWFooterLoadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tips = @"Loading";
        _tipsFont = [UIFont systemFontOfSize:15.0f];
        _indicatorSize = CGSizeMake(20, 20);
        [self addSubview:self.tipsLabel];
        [self addSubview:self.actView];
    }
    return self;
}

- (void)setTips:(NSString *)tips
{
    _tips = tips;
    self.tipsLabel.text = tips;
    [self updateTipsLabelFrame];
    [self updateActViewFrame];
}

- (void)setTipsFont:(UIFont *)tipsFont
{
    _tipsFont = tipsFont;
    self.tipsLabel.font = tipsFont;
    [self updateTipsLabelFrame];
    [self updateActViewFrame];
}

- (void)setIndicatorSize:(CGSize)indicatorSize
{
    _indicatorSize = indicatorSize;
    [self updateActViewFrame];
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = _tips;
        _tipsLabel.font = _tipsFont;
        _tipsLabel.backgroundColor = [UIColor clearColor];
        _tipsLabel.textColor = [UIColor lightGrayColor];
        [self updateTipsLabelFrame];
    }
    return _tipsLabel;
}

- (UIActivityIndicatorView *)actView
{
    if (!_actView) {
        _actView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, _indicatorSize.width, _indicatorSize.height)];
        _actView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _actView.hidesWhenStopped = NO;
        [_actView startAnimating];
        [self updateActViewFrame];
    }
    return _actView;
}

- (void)updateTipsLabelFrame
{
    CGRect textFrame = [_tips boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_tipsFont} context:nil];
    CGRect tipsFrame = _tipsLabel.frame;
    tipsFrame.size = textFrame.size;
    _tipsLabel.frame =  tipsFrame;
    _tipsLabel.center = CGPointMake(self.center.x + 12, self.center.y);
}

- (void)updateActViewFrame
{
    _actView.center = CGPointMake(self.center.x - (self.tipsLabel.frame.size.width + _indicatorSize.width) / 2 + 12 - 5, self.center.y);
    if (!_tips || _tips.length == 0) {
        _actView.center = self.center;
    }
}

@end
