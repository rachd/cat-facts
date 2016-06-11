//
//  RMDRegisterViewController.m
//  CatFacts2
//
//  Created by Rachel Dorn on 6/11/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import "RMDRegisterViewController.h"

@interface RMDRegisterViewController ()

@property (nonatomic, strong) RMDRegisterView *registerView;

@end

@implementation RMDRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registerView = [[RMDRegisterView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.registerView];
    
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Register";
}

- (void)registerUser {
    NSString *email = self.registerView.emailField.text;
    NSString *password = self.registerView.passwordField.text;
    
    [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        NSLog(@"%@", user);
        if (error) {
            [self presentAlertWithTitle:@"Error" message:@"Could not register user.  Ensure a valid email and internet connection and try again."];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
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
