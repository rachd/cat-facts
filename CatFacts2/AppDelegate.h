//
//  AppDelegate.h
//  CatFacts2
//
//  Created by Rachel Dorn on 6/9/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Firebase;
#import "RMDFactsTableViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RMDFactsTableViewController *factsVC;

@end

