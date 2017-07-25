//
//  TestViewController.m
//  mytest
//
//  Created by 易云时代 on 2017/7/19.
//  Copyright © 2017年 笑伟. All rights reserved.
//
#import "TestViewController.h"
#import "myTableViewCell.h"
#import "CellMOdel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "GlobalDefines.h"
#import "PostFiendViewController.h"
static CGFloat textFieldH = 40;

@interface TestViewController () <UITableViewDelegate,UITableViewDataSource,SDTimeLineCellDelegate,UITextFieldDelegate>
{
    CGFloat _totalKeybordHeight;
}

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
@property (nonatomic, copy) NSString *commentToUser;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WITH, 200)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WITH, 200)];
    imageView.image = [UIImage imageNamed:@"pbg.jpg"];
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WITH-80, 200-80, 60, 60)];
    iconView.image = [UIImage imageNamed:@"picon.jpg"];
    iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconView.layer.borderWidth = 3;
    [imageView addSubview:iconView];
    [headView addSubview:imageView];
    headView.backgroundColor = [UIColor greenColor];
    _tableView.tableHeaderView = headView;
    [_tableView registerClass:[myTableViewCell class] forCellReuseIdentifier:@"pppppp"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _dataArray = [[NSMutableArray alloc]init];
    [self.dataArray addObjectsFromArray:[self creatModelsWithCount:10]];
    
    [_tableView reloadData];
    [self setupTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相机" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 60, 30)]];
     self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)rightBarButtonItemAction:(id)sender{
    PostFiendViewController *post = [[PostFiendViewController alloc]init];
    [self.navigationController pushViewController:post animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_textField resignFirstResponder];
}

- (void)dealloc
{
    
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setupTextField
{
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    _textField.layer.borderWidth = 1;
    
    //为textfield添加背景颜色 字体颜色的设置 还有block设置 , 在block中改变它的键盘样式 (当然背景颜色和字体颜色也可以直接在block中写)
    
    //    _textField.lee_theme
    //    .LeeAddBackgroundColor(DAY , [UIColor whiteColor])
    //    .LeeAddBackgroundColor(NIGHT , [UIColor blackColor])
    //    .LeeAddTextColor(DAY , [UIColor blackColor])
    //    .LeeAddTextColor(NIGHT , [UIColor grayColor])
    //    .LeeAddCustomConfig(DAY , ^(UITextField *item){
    //
    //        item.keyboardAppearance = UIKeyboardAppearanceDefault;
    //        if ([item isFirstResponder]) {
    //            [item resignFirstResponder];
    //            [item becomeFirstResponder];
    //        }
    //    }).LeeAddCustomConfig(NIGHT , ^(UITextField *item){
    //
    //        item.keyboardAppearance = UIKeyboardAppearanceDark;
    //        if ([item isFirstResponder]) {
    //            [item resignFirstResponder];
    //            [item becomeFirstResponder];
    //        }
    //    });
    _textField.keyboardAppearance = UIKeyboardAppearanceDefault;
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
        [_textField becomeFirstResponder];
    }
    _textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width_sd, textFieldH);
    [[UIApplication sharedApplication].keyWindow addSubview:_textField];
    
    [_textField becomeFirstResponder];
    [_textField resignFirstResponder];
}

- (NSArray *)creatModelsWithCount:(NSInteger)count
{
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     ];
    
    NSArray *namesArray = @[@"GSD_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，https://github.com/gsdios/SDAutoLayout大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，https://github.com/gsdios/SDAutoLayout等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    NSArray *commentsArray = @[@"社会主义好！👌👌👌👌",
                               @"正宗好凉茶，正宗好声音。。。",
                               @"你好，我好，大家好才是真的好",
                               @"有意思",
                               @"你瞅啥？",
                               @"瞅你咋地？？？！！！",
                               @"hello，看我",
                               @"曾经在幽幽暗暗反反复复中追问，才知道平平淡淡从从容容才是真",
                               @"人艰不拆",
                               @"咯咯哒",
                               @"呵呵~~~~~~~~",
                               @"我勒个去，啥世道啊",
                               @"真有意思啊你💢💢💢"];
    
    NSArray *picImageNamesArray = @[ @"pic0.jpg",
                                     @"pic1.jpg",
                                     @"pic2.jpg",
                                     @"pic3.jpg",
                                     @"pic4.jpg",
                                     @"pic5.jpg",
                                     @"pic6.jpg",
                                     @"pic7.jpg",
                                     @"pic8.jpg"
                                     ];
    NSMutableArray *resArr = [NSMutableArray new];
    
    for (int i = 0; i < count; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        
        CellMOdel *model = [CellMOdel new];
        model.iconName = iconImageNamesArray[iconRandomIndex];
        model.name = namesArray[nameRandomIndex];
        model.msgContent = textArray[contentRandomIndex];
        model.time = [NSString stringWithFormat:@"%d分钟前",i*3];
        
        // 模拟“随机图片”
        int random = arc4random_uniform(6);
        
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < random; i++) {
            int randomIndex = arc4random_uniform(9);
            [temp addObject:picImageNamesArray[randomIndex]];
        }
        if (temp.count) {
            model.picNamesArray = [temp copy];
        }
        
        //      模拟随机评论数据
        int commentRandom = arc4random_uniform(3);
        NSMutableArray *tempComments = [NSMutableArray new];
        for (int i = 0; i < commentRandom; i++) {
            SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
            int index = arc4random_uniform((int)namesArray.count);
            commentItemModel.firstUserName = namesArray[index];
            commentItemModel.firstUserId = [NSString stringWithFormat:@"%d",i+1];
            if (arc4random_uniform(10) < 5) {
                commentItemModel.secondUserName = namesArray[arc4random_uniform((int)namesArray.count)];
                commentItemModel.secondUserId = [NSString stringWithFormat:@"%d",(i+1)*20 ];
            }
            commentItemModel.commentString = commentsArray[arc4random_uniform((int)commentsArray.count)];
            [tempComments addObject:commentItemModel];
        }
        model.commentItemsArray = [tempComments copy];
        
        // 模拟随机点赞数据
        int likeRandom = arc4random_uniform(3);
        NSMutableArray *tempLikes = [NSMutableArray new];
        for (int i = 0; i < likeRandom; i++) {
            SDTimeLineCellLikeItemModel *model = [SDTimeLineCellLikeItemModel new];
            int index = arc4random_uniform((int)namesArray.count);
            model.userName = namesArray[index];
            model.userId = namesArray[index];
            [tempLikes addObject:model];
        }
        
        model.likeItemsArray = [tempLikes copy];
        
        
        
        [resArr addObject:model];
    }
    return [resArr copy];
}

#pragma TableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    myTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pppppp"];
    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    CellMOdel *model = weakSelf.dataArray[indexPath.row];
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            
            model.isOpening = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        [cell setDidClickCommentLabelBlock:^(NSString *commentId, CGRect rectInWindow, NSIndexPath *indexPath) {
            
            for (SDTimeLineCellCommentItemModel *commentModel in model.commentItemsArray) {
                NSLog(@"找到这个人啊 %@  %@",commentModel.firstUserName,commentModel.firstUserId);
                NSLog(@"找到这个人啊 %@  %@",commentModel.secondUserName,commentModel.secondUserId);
                if([commentId isEqualToString:commentModel.firstUserId]){
                    NSLog(@"%@",model.name);
                     weakSelf.textField.placeholder = [NSString stringWithFormat:@"  回复：%@", commentModel.firstUserName];
                    break;
                }else if ([commentId isEqualToString:commentModel.secondUserId]){
                     weakSelf.textField.placeholder = [NSString stringWithFormat:@"  回复：%@", commentModel.secondUserName];
                    break;
                }
                
            }
            NSLog(@"点击回复了");
        
            weakSelf.currentEditingIndexthPath = indexPath;
            [weakSelf.textField becomeFirstResponder];
            weakSelf.isReplayingComment = YES;
            weakSelf.commentToUser = commentId;
            [weakSelf adjustTableViewToFitKeyboard];
        }];
        
        cell.delegate = self;
    }
    //
    //    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    //
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    //
    //    ///////////////////////////////////////////////////////////////////////
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>0
    
    id model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[myTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
//

- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell  with:(NSIndexPath *)indexPath
{
    CellMOdel *model = _dataArray[indexPath.row];
    _textField.frame = CGRectMake(0, SCREEN_HEIGHT-120, SCREEN_WITH, 40);
    _textField.placeholder = [NSString stringWithFormat:@" 评论 %@",model.name];
    [_textField becomeFirstResponder];
    _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    
    [self adjustTableViewToFitKeyboard];
    
}

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    CellMOdel *model = self.dataArray[index.row];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:model.likeItemsArray];
    
    if (!model.isLiked) {
        SDTimeLineCellLikeItemModel *likeModel = [SDTimeLineCellLikeItemModel new];
        likeModel.userName = @"是我XXX";
        likeModel.userId = @"gsdios";
        [temp addObject:likeModel];
        model.liked = YES;
    } else {
        SDTimeLineCellLikeItemModel *tempLikeModel = nil;
        for (SDTimeLineCellLikeItemModel *likeModel in model.likeItemsArray) {
            if ([likeModel.userId isEqualToString:@"gsdios"]) {
                tempLikeModel = likeModel;
                break;
            }
        }
        [temp removeObject:tempLikeModel];
        model.liked = NO;
    }
    model.likeItemsArray = [temp copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    });
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tableView setContentOffset:offset animated:YES];
}
- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        [_textField resignFirstResponder];
        
        CellMOdel *model = self.dataArray[_currentEditingIndexthPath.row];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:model.commentItemsArray];
        SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
        
        if (self.isReplayingComment) {
            commentItemModel.firstUserName = @"GSD_iOS";
            commentItemModel.firstUserId = @"GSD_iOS";
            commentItemModel.secondUserName = self.commentToUser;
            commentItemModel.secondUserId = self.commentToUser;
            commentItemModel.commentString = textField.text;
            
            self.isReplayingComment = NO;
        } else {
            commentItemModel.firstUserName = @"GSD_iOS";
            commentItemModel.commentString = textField.text;
            commentItemModel.firstUserId = @"GSD_iOS";
        }
        [temp addObject:commentItemModel];
        model.commentItemsArray = [temp copy];
        [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
        
        _textField.text = @"";
        _textField.placeholder = nil;
        
        return YES;
    }
    return NO;
}



- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _textField.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textField resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textField resignFirstResponder];
    _textField.placeholder = nil;
}
@end
