//
//  MyDrawerViewController.h
//  MyDrawerViewController
//
//  Created by 蔡成汉 on 16/4/6.
//  Copyright © 2016年 蔡成汉. All rights reserved.
//

/**
 *  底层控制器
 */

#import <UIKit/UIKit.h>

@class MySideViewController;

@interface MyDrawerViewController : UIViewController

/**
 *  侧边VC
 */
@property (nonatomic , strong) MySideViewController *sideController;


/**
 *  根VC -- 为内容VC
 */
@property (nonatomic , strong) UIViewController *rootViewController;

/**
 *  抽屉抽开后右侧宽度 -- 默认为80
 */
@property (nonatomic , assign) CGFloat drawerRightWidth;

/**
 *  侧边阴影颜色 -- 默认为黑色
 */
@property (nonatomic , strong) UIColor *shadowColor;

/**
 *  阴影半径 -- 默认为7.0
 */
@property (nonatomic , assign) CGFloat shadowRadius;

/**
 *  动画执行时间 -- 默认为0.26秒
 */
@property (nonatomic , assign) NSTimeInterval animationTime;

/**
 *  切换内容页 -- 侧边VC使用
 *
 *  @param viewController viewController
 */
-(void)exchangeContentViewController:(UIViewController *)viewController;

@end
