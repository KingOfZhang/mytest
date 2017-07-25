//
//  CommentView.h
//  mytest
//
//  Created by 易云时代 on 2017/7/18.
//  Copyright © 2017年 笑伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalDefines.h"

@interface CommentView : UIView
- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray;

@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow);
@end
