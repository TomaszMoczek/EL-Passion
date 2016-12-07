//
//  DetailViewController.m
//  EL Passion
//
//  Created by Tomasz Moczek on 11/11/16.
//  Copyright © 2016 Tomasz Moczek. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize buttonFirst = _buttonFirst;
@synthesize buttonPrev = _buttonPrev;
@synthesize buttonNext = _buttonNext;
@synthesize buttonLast = _buttonLast;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;

        [self.buttonFirst setEnabled:self.detailItem == nil ? NO : YES];
        [self.buttonPrev setEnabled:self.detailItem == nil ? NO : YES];
        [self.buttonNext setEnabled:self.detailItem == nil ? NO : YES];
        [self.buttonLast setEnabled:self.detailItem == nil ? NO : YES];
        
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"GitHub's User", @"GitHub's User");
    
    self.buttonFirst = [[UIBarButtonItem alloc] initWithTitle:@"<<" style:UIBarButtonItemStyleDone target:self action:@selector(first)];
    self.buttonPrev = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleDone target:self action:@selector(prev)];
    self.buttonNext = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleDone target:self action:@selector(next)];
    self.buttonLast = [[UIBarButtonItem alloc] initWithTitle:@">>" style:UIBarButtonItemStyleDone target:self action:@selector(last)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.buttonLast, self.buttonNext, self.buttonPrev, self.buttonFirst, nil]];
    
    [self.buttonFirst setEnabled:self.detailItem == nil ? NO : YES];
    [self.buttonPrev setEnabled:self.detailItem == nil ? NO : YES];
    [self.buttonNext setEnabled:self.detailItem == nil ? NO : YES];
    [self.buttonLast setEnabled:self.detailItem == nil ? NO : YES];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case UserSection:
            return NSLocalizedString(@"User's Details", @"User's Details");
        case RepositoriesSection:
            return NSLocalizedString(@"User's Repositories", @"User's Repositories");
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case UserSection:
            return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 104.0 : 84.0;
        case RepositoriesSection:
            return 44.0;
        default:
            return 0.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case UserSection:
            return 1;
        case RepositoriesSection:
            return self.detailItem == nil ? 0 : 4;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == UserSection) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
        
        cell.textLabel.text = self.detailItem == nil ? NSLocalizedString(@"Find and select the GitHub's User", @"Empty") : [self.detailItem description];
        cell.detailTextLabel.text = self.detailItem == nil ? NSLocalizedString(@"The GitHub's User is to be found and selected prior to report its details here.", @"Empty-Description") : [self.detailItem description];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RepositoryCell" forIndexPath:indexPath];
        
        NSDate *object = [NSDate date];
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
