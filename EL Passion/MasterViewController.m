//
//  MasterViewController.m
//  EL Passion
//
//  Created by Tomasz Moczek on 11/11/16.
//  Copyright © 2016 Tomasz Moczek. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SearchTableViewCell.h"

@interface MasterViewController ()

@property NSMutableArray *objects;

@end

@implementation MasterViewController

@synthesize searchTableViewCell = _searchTableViewCell;

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    for (int i=0; i<4; ++i) {
        [self.objects insertObject:[NSDate date] atIndex:0];
    }
    
    self.title = NSLocalizedString(@"GitHub Users", @"GitHub Users");
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.searchTableViewCell = [[SearchTableViewCell alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    self.searchTableViewCell = nil;
    
    [super viewDidUnload];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SearchSection:
            return NSLocalizedString(@"Search", @"Search");
        case ResultsSection:
            return NSLocalizedString(@"Results", @"Results");
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SearchSection:
            return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 104.0 : 84.0;
        case ResultsSection:
            return 44.0;
        default:
            return 0.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SearchSection:
            return 1;
        case ResultsSection:
            return self.objects.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == SearchSection) {
        cell = self.searchTableViewCell;
    } else if (indexPath.section == ResultsSection) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        NSDate *object = self.objects[indexPath.row];
        cell.textLabel.text = [object description];
        cell.detailTextLabel.text = [object description];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) displayTableViewCell:tableView forCell:cell forRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
