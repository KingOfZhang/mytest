//
//  PostFiendViewController.m
//  mytest
//
//  Created by 易云时代 on 2017/7/20.
//  Copyright © 2017年 笑伟. All rights reserved.
//

#import "PostFiendViewController.h"
#import <ZYQAssetPickerController.h>

@interface PostFiendViewController ()<ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    UIView               *_editv;
    UIButton             *_addPic;
    NSMutableArray       *_imageArray;
    NSArray *arr;
    
    UITextView *_textView;
}
@end

@implementation PostFiendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *button =[[UIButton alloc]initWithFrame:CGRectMake(100, SCREEN_HEIGHT-120, 100, 100)];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 2;
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(pushSec) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(16, 100, SCREEN_WITH-32, 100)];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_textView];
    
    _imageArray = [NSMutableArray array];
    _editv = [[UIView alloc] initWithFrame:CGRectMake(15, 200, SCREEN_WITH-15*2, 0)];
    _editv.backgroundColor = [UIColor lightGrayColor];
    
    _addPic = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addPic setImage:[UIImage imageNamed:@"AlbumAddBtn"] forState:UIControlStateNormal];
    _addPic.frame = CGRectMake(15, 10, 70, 70);
    [_addPic addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    _editv.frame = CGRectMake(15, 240, SCREEN_WITH-15*2, CGRectGetMaxY(_addPic.frame)+20);
    [_editv addSubview:_addPic];
    
    [self.view addSubview:_editv];
    
}
-(void)pushSec{

}
-(void)click{
    
    ZYQAssetPickerController *pickerController = [[ZYQAssetPickerController alloc] init];
    pickerController.maximumNumberOfSelection = 8;
//    pickerController.nowCount = _imageArray.count;
    pickerController.assetsFilter = ZYQAssetsFilterAllAssets;
    pickerController.showEmptyGroups=NO;
    pickerController.delegate=self;
    pickerController.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([(ZYQAsset*)evaluatedObject mediaType]==ZYQAssetMediaTypeVideo) {
            NSTimeInterval duration = [(ZYQAsset*)evaluatedObject duration];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    
    [self presentViewController:pickerController animated:YES completion:nil];
}
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       for (int i=0; i<assets.count; i++)
                       {
                           
                           ZYQAsset *asset = assets[i];
                           
                           [asset setGetFullScreenImage:^(UIImage *result){
                               
                               if (result == nil) {
                                   NSLog(@"空空以控控");
                               }
                               if(_imageArray.count >8){
                                   NSLog(@"超了");
                               }else{
                                   [_imageArray addObject:result];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self nineGrid];
                                   });
                               }
                               
                               NSLog(@"---%ld",_imageArray.count);
                               
                               
                           }];
                           
                       }
                       NSLog(@"现在剩余是多少%ld",_imageArray.count);
                   });
}
// 删除照片
- (void)deleteEvent:(UIButton *)sender
{
    UIButton *btn = (UIButton *)sender;
    [_imageArray removeObjectAtIndex:btn.tag-10];
    
    [self nineGrid];
    
    if (_imageArray.count == 0)
    {
        _addPic.frame = CGRectMake(15, 10, 70, 70);
        _editv.frame = CGRectMake(15, 240, SCREEN_WITH-15*2, CGRectGetMaxY(_addPic.frame)+20);
    }
}
// 9宫格图片布局
- (void)nineGrid
{
    NSLog(@"九宫格%ld",_imageArray.count);
    for (UIImageView *imgv in _editv.subviews)
    {
        if ([imgv isKindOfClass:[UIImageView class]]) {
            [imgv removeFromSuperview];
        }
    }
    
    CGFloat width = 70;
    CGFloat widthSpace = (SCREEN_WITH - 15*4 - 70*4) / 3.0;
    CGFloat heightSpace = 10;
    
    NSInteger count = _imageArray.count;
    _imageArray.count > 9 ? (count = 9) : (count = _imageArray.count);
    
    for (int i=0; i<count; i++)
    {
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(15+(width+widthSpace)*(i%4), (i/4)*(width+heightSpace) + 10, width, width)];
        imgv.image = _imageArray[i];
        imgv.userInteractionEnabled = YES;
        [_editv addSubview:imgv];
        
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
        delete.frame = CGRectMake(width-16, -5, 16, 16);
        //        delete.backgroundColor = [UIColor greenColor];
        [delete setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
        delete.tag = 10+i;
        [imgv addSubview:delete];
        
        if (i == _imageArray.count - 1)
        {
            if (_imageArray.count % 4 == 0) {
                _addPic.frame = CGRectMake(15, CGRectGetMaxY(imgv.frame) + heightSpace, 70, 70);
            } else {
                _addPic.frame = CGRectMake(CGRectGetMaxX(imgv.frame) + widthSpace, CGRectGetMinY(imgv.frame), 70, 70);
            }
            
            _editv.frame = CGRectMake(15, 240, SCREEN_WITH-15*2, CGRectGetMaxY(_addPic.frame)+20);
        }
    }
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
@end
