//
//  AppDelegate.m
//  MyDrawerViewController
//
//  Created by 蔡成汉 on 04/07/2016.
//  Copyright (c) 2016 蔡成汉. All rights reserved.
//

#import "AppDelegate.h"
#import "MyDrawerViewController.h"
#import "SideViewController.h"
#import "MainViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    /**
     *  创建抽屉 -- 用于托管侧边控制器+主页面控制器
     */
    MyDrawerViewController *drawerViewController = [[MyDrawerViewController alloc]init];
    
    /**
     *  创建侧边控制器 -- 并且赋值给抽屉
     */
    SideViewController *sideViewController = [[SideViewController alloc]init];
    drawerViewController.sideController = sideViewController;
    
    /**
     *  创建主界面控制器
     */
    MainViewController *mainViewController = [[MainViewController alloc]init];
    
    /**
     *  同时创建UINavigationController托管主界面控制器
     */
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    
    /**
     *  抽屉托管导航控制器
     */
    drawerViewController.rootViewController = navigationController;
    
    /**
     *  window托管抽屉
     */
    self.window.rootViewController = drawerViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
