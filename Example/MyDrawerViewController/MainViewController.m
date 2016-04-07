//
//  MainViewController.m
//  MyDrawerViewController
//
//  Created by 蔡成汉 on 16/4/7.
//  Copyright © 2016年 蔡成汉. All rights reserved.
//

#import "MainViewController.h"
#import "TestViewController.h"

@interface MainViewController ()

/**
 *  按钮
 */
@property (nonatomic , strong) UIButton *myButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"主页";
    
    _myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _myButton.backgroundColor = [UIColor orangeColor];
    [_myButton setTitle:@"主页按钮" forState:UIControlStateNormal];
    [_myButton addTarget:self action:@selector(myButtonIsTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_myButton];
}

-(void)myButtonIsTouch
{
    TestViewController *viewController = [[TestViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _myButton.frame = CGRectMake((self.view.frame.size.width - 100.0)/2.0, 100, 100, 40);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
