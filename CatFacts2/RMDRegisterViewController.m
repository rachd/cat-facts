//
//  RMDRegisterViewController.m
//  CatFacts2
//
//  Created by Rachel Dorn on 6/11/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import "RMDRegisterViewController.h"
#import "RMDUser.h"

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

- (void)viewDidDisappear:(BOOL)animated {
    self.registerView.emailField.text = nil;
    self.registerView.passwordField.text = nil;
}

- (void)registerUser {
    NSString *email = self.registerView.emailField.text;
    NSString *password = self.registerView.passwordField.text;
    
    NSMutableArray *facts = [[NSMutableArray alloc] init];
    [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            [self presentAlertWithTitle:@"Error" message:@"Could not register user. Ensure a valid email and internet connection and try again."];
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
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self fetchFacts:^(NSArray *response) {
            [factsArray addObject:response];
            [self retrieveAllFacts:factsArray user:user];
        } failure:^(NSError *error) {
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
