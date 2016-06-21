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

- (void)registerUser {
    NSString *email = self.signInView.emailField.text;
    NSString *password = self.signInView.passwordField.text;
    
    NSMutableArray *facts = [[NSMutableArray alloc] init];
    MRProgressOverlayView *overlayView = [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
    overlayView.tintColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.6 alpha:1.0];
    [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            [self presentAlertWithTitle:@"Error" message:@"Could not register user. Ensure a valid email and internet connection and try again."];
            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
        } else {
            [self retrieveAllFacts:facts user:user];
        }
    }];
}

- (void)retrieveAllFacts:(NSMutableArray *)factsArray user:(FIRUser *)user {
    NSLog(@"looped");
    if ([factsArray count] == 20) {
        [[[[[FIRDatabase database] reference] child:@"users"] child:user.uid] setValue:@{@"facts":factsArray}];
        [RMDUser login:[NSString stringWithFormat:@"%@", user.uid] withFacts:factsArray[0]];
        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self fetchFacts:^(NSArray *response) {
            [factsArray addObject:response];
            [self retrieveAllFacts:factsArray user:user];
        } failure:^(NSError *error) {
            [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
            [self presentAlertWithTitle:@"Error" message:@"Could not retrieve facts. Please check your internet connection and try again"];
        }];
    }
}

- (void)fetchFacts:(void (^)(NSArray *response))success failure:(void(^)(NSError* error))failure {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://catfacts-api.appspot.com/api/facts?number=100"]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (response) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                success([json objectForKey:@"facts"]);
            });
        } else {
            NSArray *blankArray = [[NSArray alloc] initWithObjects:@"Please check your internet connection and try again", nil];
            success(blankArray);
        }
    }];
    [dataTask resume];
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
