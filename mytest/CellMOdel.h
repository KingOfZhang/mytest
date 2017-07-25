//
//  CellMOdel.h
//  mytest
//
//  Created by 易云时代 on 2017/7/6.
//  Copyright © 2017年 笑伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDTimeLineCellLikeItemModel, SDTimeLineCellCommentItemModel;

@interface CellMOdel : NSObject
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, strong) NSArray *picNamesArray;
@property (nonatomic, assign, getter = isLiked) BOOL liked;
@property (nonatomic, strong) NSArray<SDTimeLineCellLikeItemModel *> *likeItemsArray;
@property (nonatomic, strong) NSArray<SDTimeLineCellCommentItemModel *> *commentItemsArray;

@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;
@end

@interface SDTimeLineCellLikeItemModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSAttributedString *attributedContent;

@end


@interface SDTimeLineCellCommentItemModel : NSObject

@property (nonatomic, copy) NSString *commentString;

@property (nonatomic, copy) NSString *firstUserName;
@property (nonatomic, copy) NSString *firstUserId;

@property (nonatomic, copy) NSString *secondUserName;
@property (nonatomic, copy) NSString *secondUserId;

@property (nonatomic, copy) NSAttributedString *attributedContent;
@end
