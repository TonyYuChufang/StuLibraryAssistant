//
//  AppDelegate.m
//  StuLibraryAssistant
//
//  Created by yu on 2019/3/1.
//  Copyright © 2019 yu. All rights reserved.
//

#import "AppDelegate.h"
#import "SLLoginViewController.h"
#import "SLMainSearchDataController.h"
#import "SLLoginDataController.h"
#import "SLMainSearchViewController.h"
#import "SLNavigationController.h"
#import "SLUserDefault.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupMainController];
    [self setupIQKeyBoard];
    [self checkLogin];
    
    [SLMainSearchDataController sharedObject];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self checkLogin];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - private

- (void)setupMainController
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    SLMainSearchViewController *loginView = [[SLMainSearchViewController alloc] init];
    [self.window makeKeyAndVisible];
    SLNavigationController *nav = [[SLNavigationController alloc] initWithRootViewController:loginView];
    self.window.rootViewController = nav;
}

- (void)setupIQKeyBoard
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.overrideKeyboardAppearance = YES;
    manager.shouldResignOnTouchOutside = YES;
}

- (void)checkLogin
{
    NSString *username = [[SLUserDefault sharedObject] objectForKey:kUsernameKey];
    NSString *password = [[SLUserDefault sharedObject] objectForKey:kPasswordKey];
    if (username && password) {
        [[SLLoginDataController sharedObject] requestMyStuLoginParamWithBlock:^(id data, NSError *error) {
            if (error == nil) {
                [[SLLoginDataController sharedObject] loginWithUserName:username password:password completed:^(id data, NSError *error) {
                    
                }];
            }
        }];
    }
}
@end
