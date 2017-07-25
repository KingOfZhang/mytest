//
//  MenuVIew.h
//  mytest
//
//  Created by 易云时代 on 2017/7/18.
//  Copyright © 2017年 笑伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuVIew : UIView

@property (nonatomic, assign, getter = isShowing) BOOL show;

@property (nonatomic, copy) void (^likeButtonClickedOperation)();
@property (nonatomic, copy) void (^commentButtonClickedOperation)();


@end
