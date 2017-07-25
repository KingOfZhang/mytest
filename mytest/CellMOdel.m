//
//  CellMOdel.m
//  mytest
//
//  Created by 易云时代 on 2017/7/6.
//  Copyright © 2017年 笑伟. All rights reserved.
//

#import "CellMOdel.h"
#import <UIKit/UIKit.h>

extern const CGFloat contentLabelFontSize;
extern CGFloat maxContentLabelHeight;

@implementation CellMOdel
{
    CGFloat _lastContentWidth;
}


@synthesize msgContent = _msgContent;

- (void)setMsgContent:(NSString *)msgContent
{
    _msgContent = msgContent;
}

- (NSString *)msgContent
{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_msgContent boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
        if (textRect.size.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        } else {
            _shouldShowMoreButton = NO;
        }
    }
    
    return _msgContent;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}


@end

@implementation SDTimeLineCellLikeItemModel


@end

@implementation SDTimeLineCellCommentItemModel


@end

