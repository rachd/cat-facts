//
//  RMDFactsTableViewController.m
//  CatFacts2
//
//  Created by Rachel Dorn on 6/11/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import "RMDFactsTableViewController.h"
#import "RMDSignInViewController.h"
#import "RMDUser.h"

@interface RMDFactsTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UINavigationController *signInNavVC;
@property (nonatomic, strong) NSArray *facts;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RMDFactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:1.0];
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Cat Facts";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];

    RMDSignInViewController *signInVC = [[RMDSignInViewController alloc] init];
    self.signInNavVC = [[UINavigationController alloc] initWithRootViewController:signInVC];
    [self.signInNavVC.navigationBar setTintColor:[UIColor colorWithRed:1.0 green:0.2 blue:0.6 alpha:1.0]];
    [self setUpTable];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([RMDUser currentUser]) {
        self.facts = [[NSArray alloc] init];
        self.facts = [RMDUser currentUser].facts;
        [self.tableView reloadData];
    } else {
        [self presentViewController:self.signInNavVC animated:YES completion:nil];
    }
}

- (void)setUpTable {
    self.tableView = [[UITableView alloc] initWithFrame:[self.view bounds] style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:1.0];
    static NSString *cellIdentifier = @"cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)logOut {
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user != nil) {
        // User is signed in.
        NSError *error;
        [[FIRAuth auth] signOut:&error];
        if (!error) {
            [[RMDUser currentUser] logout];
            [self presentViewController:self.signInNavVC animated:YES completion:nil];
        }
    } else {
        // No user is signed in.
        [self presentViewController:self.signInNavVC animated:YES completion:nil];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [self.facts objectAtIndex:indexPath.row];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.imageView.image = [UIImage imageNamed:@"CatFace"];
    cell.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:1.0];
    } else {
        cell.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.6 alpha:1.0];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [self.facts objectAtIndex:indexPath.row];
    CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17] constrainedToSize:CGSizeMake(280, 999) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 30;
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
