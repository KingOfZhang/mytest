//
//  myTableViewCell.m
//  mytest
//
//  Created by 易云时代 on 2017/7/6.
//  Copyright © 2017年 笑伟. All rights reserved.
//

#import "myTableViewCell.h"
#import <UIKit/UIKit.h>
#import "CellMOdel.h"
#import "UIView+SDAutoLayout.h"
#import <SDAutoLayout.h>
#import <UIView+SDAutoLayout.h>
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "WeiXinPhotoContainerView.h"
#import "MenuVIew.h"
#import "CommentView.h"

NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";
const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

@implementation myTableViewCell
{
    UIImageView *_iconView;
    UILabel *_nameLabel;
    UILabel *_contentLabel;
    WeiXinPhotoContainerView *_picContainerView;
    UILabel *_timeLabel;
    UIButton *_moreButton;
    UIButton *_operationButton;
    CommentView *_commentView;
    MenuVIew *_operationMenu;
    UIButton *_likeButton;
    UIButton *_commentButton;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        

        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kSDTimeLineCellOperationButtonClickedNotification object:nil];
    _iconView = [UIImageView new];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.numberOfLines = 0;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];

    _picContainerView = [WeiXinPhotoContainerView new];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    
    
    
    _operationButton = [UIButton new];
    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    _operationMenu = [MenuVIew new];
    __weak typeof(self) weakSelf = self;
    [_operationMenu setLikeButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
            [weakSelf.delegate didClickLikeButtonInCell:weakSelf];
        }
    }];
    [_operationMenu setCommentButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:with:)]) {
            [weakSelf.delegate didClickcCommentButtonInCell:weakSelf with:weakSelf.indexPath];
        }
    }];
    
    
    _commentView = [CommentView new];
    [_commentView setDidClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow){
        NSLog(@"222");
        weakSelf.didClickCommentLabelBlock(commentId, rectInWindow, weakSelf.indexPath);
     
    }];
  
    
    NSArray *views = @[_iconView, _nameLabel, _contentLabel, _moreButton,_picContainerView,_timeLabel,_operationButton,_operationMenu,_commentView];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(40)
    .heightIs(40);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    // morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(30);
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel);
    
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView, margin)
    .heightIs(15);
    
    _operationButton.sd_layout
    .rightSpaceToView(contentView, margin)
    .centerYEqualToView(_timeLabel)
    .heightIs(25)
    .widthIs(25);
    
    
    _operationMenu.sd_layout
    .rightSpaceToView(_operationButton, 0)
    .heightIs(36)
    .centerYEqualToView(_operationButton)
    .widthIs(0);
    
    _commentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(self.contentView, margin)
    .topSpaceToView(_timeLabel, margin);
    
    
}
-(void)setModel:(CellMOdel *)model{
    _model = model;
    [_commentView setupWithLikeItemsArray:model.likeItemsArray commentItemsArray:model.commentItemsArray];
    
    _iconView.image = [UIImage imageNamed:model.iconName];
    _nameLabel.text = model.name;
    _contentLabel.text = model.msgContent;
    _picContainerView.picPathStringsArray = model.picNamesArray;
    
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    
    CGFloat picContainerTopMargin = 0;
    if (model.picNamesArray.count) {
        picContainerTopMargin = 10;
    }
    
    _picContainerView.sd_layout.topSpaceToView(_moreButton, picContainerTopMargin);
    
    UIView *bottomView;
    
    if (!model.commentItemsArray.count && !model.likeItemsArray.count) {
        bottomView = _timeLabel;
    } else {
        bottomView = _commentView;
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
    _timeLabel.text = model.time;
    
    
    
}

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}
- (void)operationButtonClicked
{
    [self postOperationButtonClickedNotification];
    _operationMenu.show = !_operationMenu.isShowing;
}
- (void)postOperationButtonClickedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSDTimeLineCellOperationButtonClickedNotification object:_operationButton];
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
    if (btn != _operationButton && _operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

@end
