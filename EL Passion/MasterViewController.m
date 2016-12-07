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

@synthesize buttonFirst = _buttonFirst;
@synthesize buttonPrev = _buttonPrev;
@synthesize buttonNext = _buttonNext;
@synthesize buttonLast = _buttonLast;
@synthesize searchTableViewCell = _searchTableViewCell;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"GitHub's Users", @"GitHub's Users");
    
    self.buttonFirst = [[UIBarButtonItem alloc] initWithTitle:@"<<" style:UIBarButtonItemStyleDone target:self action:@selector(first)];
    self.buttonPrev = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleDone target:self action:@selector(prev)];
    self.buttonNext = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleDone target:self action:@selector(next)];
    self.buttonLast = [[UIBarButtonItem alloc] initWithTitle:@">>" style:UIBarButtonItemStyleDone target:self action:@selector(last)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.buttonLast, self.buttonNext, self.buttonPrev, self.buttonFirst, nil]];
    
    self.searchTableViewCell = [[SearchTableViewCell alloc] initWithFrame:CGRectZero];
    
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    self.objects = [[NSMutableArray alloc] init];
    
    [self.buttonFirst setEnabled:NO];
    [self.buttonPrev setEnabled:NO];
    [self.buttonNext setEnabled:NO];
    [self.buttonLast setEnabled:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:TextFieldDidEndEditing object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.searchTableViewCell = nil;
    [self.objects removeAllObjects];
    self.objects = nil;
    
    [super viewDidUnload];
}

#pragma mark - Notifications

- (void)textFieldDidEndEditing:(NSNotification *)notification {
    [self.objects removeAllObjects];
    
    [self.buttonFirst setEnabled:NO];
    [self.buttonPrev setEnabled:NO];
    [self.buttonNext setEnabled:NO];
    [self.buttonLast setEnabled:NO];
    
    if (self.searchTableViewCell.textField.text != nil
        && self.searchTableViewCell.textField.text.length != 0) {
        for (int i=0; i<4; ++i) {
            [self.objects insertObject:[NSDate date] atIndex:0];
        }
        
        [self.buttonFirst setEnabled:YES];
        [self.buttonPrev setEnabled:YES];
        [self.buttonNext setEnabled:YES];
        [self.buttonLast setEnabled:YES];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)first {
    
}

- (void)prev {
    
}

- (void)next {
    
}

- (void) last {
    
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
        case UsersSection:
            return NSLocalizedString(@"Users", @"Users");
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SearchSection:
            return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 104.0 : 84.0;
        case UsersSection:
            return 44.0;
        default:
            return 0.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SearchSection:
            return 1;
        case UsersSection:
            return self.objects.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == SearchSection) {
        cell = self.searchTableViewCell;
    } else if (indexPath.section == UsersSection) {
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
