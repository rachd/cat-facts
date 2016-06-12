//
//  RMDFactsTableViewController.m
//  CatFacts2
//
//  Created by Rachel Dorn on 6/11/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import "RMDFactsTableViewController.h"
#import "RMDSignInViewController.h"

@interface RMDFactsTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UINavigationController *signInNavVC;
@property (nonatomic, strong) NSArray *facts;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RMDFactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Cat Facts";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];

    RMDSignInViewController *signInVC = [[RMDSignInViewController alloc] init];
    self.signInNavVC = [[UINavigationController alloc] initWithRootViewController:signInVC];
    [self.signInNavVC.navigationBar setTintColor:[UIColor colorWithRed:1.0 green:0.2 blue:0.6 alpha:1.0]];

    
    FIRUser *user = [FIRAuth auth].currentUser;
    self.facts = [[NSArray alloc] init];
    
    if (user != nil) {
        NSString *userID = [FIRAuth auth].currentUser.uid;
        [[[[[FIRDatabase database] reference] child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            // Get user value
            self.facts = snapshot.value[@"facts"];
            [self setUpTable];
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    } else {
        // No user is signed in.
        [self presentViewController:self.signInNavVC animated:YES completion:nil];
    }
}

- (void)setUpTable {
    NSLog(@"%@", self.facts);
    self.tableView = [[UITableView alloc] initWithFrame:[self.view bounds] style:UITableViewStylePlain];
}

- (void)logOut {
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user != nil) {
        // User is signed in.
        NSError *error;
        [[FIRAuth auth] signOut:&error];
        if (!error) {
            [self presentViewController:self.signInNavVC animated:YES completion:nil];
        }
    } else {
        // No user is signed in.
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.facts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.facts objectAtIndex:indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
