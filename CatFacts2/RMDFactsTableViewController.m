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
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float stringHeight = [self heightForStringDrawing:[self.facts objectAtIndex:indexPath.row] font:[UIFont fontWithName:@"Helvetica" size:17] width:self.tableView.frame.size.width - 120];
    return MAX(stringHeight, 120);
}

@end
