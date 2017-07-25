//
//  myTableViewCell.h
//  mytest
//
//  Created by 易云时代 on 2017/7/6.
//  Copyright © 2017年 笑伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SDTimeLineCellDelegate <NSObject>

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell;
- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell with:(NSIndexPath *)indexPath;

@end
@class CellMOdel;
@interface myTableViewCell : UITableViewCell
@property (nonatomic, weak) id<SDTimeLineCellDelegate> delegate;

@property (nonatomic, strong) CellMOdel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow, NSIndexPath *indexPath);
//+(instancetype)cellWithTableView:(UITableView *)tableView With:(NSIndexPath *)indexPath;
@end
