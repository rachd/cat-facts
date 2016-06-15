//
//  AppDelegate.m
//  CatFacts2
//
//  Created by Rachel Dorn on 6/9/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:1.0];
    
    self.factsVC = [[RMDFactsTableViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.factsVC];
    [navController.navigationBar setTintColor:[UIColor colorWithRed:1.0 green:0.2 blue:0.6 alpha:1.0]];
    [navController.navigationBar setBarTintColor:[UIColor colorWithRed:1 green:0.929 blue:0.784 alpha:1.0]];
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.factsVC logOut];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
