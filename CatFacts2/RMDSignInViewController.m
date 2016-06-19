//
//  RMDSignInViewController.m
//  CatFacts2
//
//  Created by Rachel Dorn on 6/11/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import "RMDSignInViewController.h"
#import "RMDRegisterViewController.h"
#import "RMDUser.h"
#import "MRProgress.h"

@interface RMDSignInViewController ()

@property (nonatomic, strong) RMDSignInView *signInView;
//@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation RMDSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signInView = [[RMDSignInView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.signInView];
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Sign In";
}

- (void)viewWillAppear:(BOOL)animated {
    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user != nil) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        // No user is signed in.
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    self.signInView.emailField.text = nil;
    self.signInView.passwordField.text = nil;
}

- (void)signInUser {
    NSString *email = self.signInView.emailField.text;
    NSString *password = self.signInView.passwordField.text;
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    overlayView.tintColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.6 alpha:1.0];
    [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            [self presentAlertWithTitle:@"Error" message:@"Could not register user. Ensure a valid email and internet connection and try again."];
            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
        } else {
            [RMDUser login:[NSString stringWithFormat:@"%@", user.uid] success:^(void) {
                NSLog(@"in signin vc %lu", (unsigned long)[[RMDUser currentUser].facts count]);
                [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
}

- (void)showRegisterView {
    RMDRegisterViewController *registerVC = [[RMDRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message {
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title                                                                       message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:dismissAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles: nil];
        [alert show];
    }

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
