//
//  ViewController.m
//  mytest
//
//  Created by 易云时代 on 2017/7/6.
//  Copyright © 2017年 笑伟. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 100, 100)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
-(void)test{
    TestViewController *test1 = [[TestViewController alloc]init];
    
    [self.navigationController pushViewController:test1 animated:YES];
}
@end
