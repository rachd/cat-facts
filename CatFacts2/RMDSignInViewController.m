//
//  RMDSignInViewController.m
//  CatFacts2
//
//  Created by Rachel Dorn on 6/11/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import "RMDSignInViewController.h"
#import "RMDSignInView.h"

@interface RMDSignInViewController ()

@property (nonatomic, strong) RMDSignInView *signInView;

@end

@implementation RMDSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signInView = [[RMDSignInView alloc] initWithFrame:self.view.frame];
    self.view = self.signInView;
    
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
