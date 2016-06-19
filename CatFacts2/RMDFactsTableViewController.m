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
        _facts = [[NSArray alloc] init];
        _facts = [RMDUser currentUser].facts;
        
        [self.tableView reloadData];
        NSLog(@"%lu", (unsigned long)[[RMDUser currentUser].facts count]);
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

- (float)heightForStringDrawing:(NSString *)myString font:(UIFont *)myFont width:(float)myWidth {
    NSTextStorage *textStorage = [[NSTextStorage alloc]
                                   initWithString:myString];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(myWidth, FLT_MAX)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [textStorage addAttribute:NSFontAttributeName value:myFont
                        range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    return [layoutManager
            usedRectForTextContainer:textContainer].size.height;
}

- (void)fetchNextPage {
    NSLog(@"fact count %lu", (unsigned long)[self.facts count]);
    if ([self.facts count] == 2000) {
        [self presentAlertWithTitle:@"No More Facts" message:@"Sorry, that's all the facts I have"];
    } else {
        NSString *userID = [FIRAuth auth].currentUser.uid;
        [[[[[FIRDatabase database] reference] child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if (snapshot.value[@"facts"]) {
                NSArray *newPage = snapshot.value[@"facts"][(int)[self.facts count] / 100 + 1];
                NSArray *currentFacts = self.facts;
                self.facts = [currentFacts arrayByAddingObjectsFromArray:newPage];
                NSLog(@"fact count after %lu", (unsigned long)[self.facts count]);
                [self.tableView reloadData];
            } else {
                NSLog(@"no facts in database");
            }
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    }
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.facts count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != [self.facts count]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = [self.facts objectAtIndex:indexPath.row];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row % 2 == 0) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:1.0];
            cell.imageView.image = [UIImage imageNamed:@"CatFace"];
        } else {
            cell.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.6 alpha:1.0];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.imageView.image = [UIImage imageNamed:@"CatFace2"];
        }
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadmore"];
        cell.textLabel.text = @"Load More Facts";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.contentView.backgroundColor = [UIColor colorWithRed:1 green:0.929 blue:0.784 alpha:1.0];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.facts count]) {
        [self fetchNextPage];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [self.facts count]) {
        float stringHeight = [self heightForStringDrawing:[self.facts objectAtIndex:indexPath.row] font:[UIFont fontWithName:@"Helvetica" size:17] width:self.tableView.frame.size.width - 120];
        return MAX(stringHeight, 120);
    } else {
        return 44;
    }
}

@end
