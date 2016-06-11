//
//  RMDSignInViewController.m
//  CatFacts2
//
//  Created by Rachel Dorn on 6/11/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import "RMDSignInViewController.h"

@interface RMDSignInViewController ()

@property (nonatomic, strong) RMDSignInView *signInView;

@end

@implementation RMDSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signInView = [[RMDSignInView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.signInView];
    
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Sign In";
    
    //
    //    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    //    navItem.rightBarButtonItem = addButton;
    //    navItem.leftBarButtonItem = self.editButtonItem;
}

- (void)registerUser:(id)sender {
    NSString *email = self.signInView.emailField.text;
    NSString *password = self.signInView.passwordField.text;
    
    [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        NSLog(@"%@", user);
        if (error) {
            [self presentAlertWithTitle:@"Error" message:@"Could not register user.  Ensure a valid email and internet connection and try again."];
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
