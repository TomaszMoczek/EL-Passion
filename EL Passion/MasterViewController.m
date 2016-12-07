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

@synthesize urls = _urls;
@synthesize data = _data;
@synthesize buttonFirst = _buttonFirst;
@synthesize buttonPrev = _buttonPrev;
@synthesize buttonNext = _buttonNext;
@synthesize buttonLast = _buttonLast;
@synthesize searchTableViewCell = _searchTableViewCell;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.objects = [[NSMutableArray alloc] init];

    self.title = NSLocalizedString(@"GitHub's Users", @"GitHub's Users");
    
    self.buttonFirst = [[UIBarButtonItem alloc] initWithTitle:@"<<" style:UIBarButtonItemStyleDone target:self action:@selector(first)];
    self.buttonPrev = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleDone target:self action:@selector(prev)];
    self.buttonNext = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleDone target:self action:@selector(next)];
    self.buttonLast = [[UIBarButtonItem alloc] initWithTitle:@">>" style:UIBarButtonItemStyleDone target:self action:@selector(last)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.buttonLast, self.buttonNext, self.buttonPrev, self.buttonFirst, nil]];
    
    self.searchTableViewCell = [[SearchTableViewCell alloc] initWithFrame:CGRectZero];
    
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:TextFieldDidEndEditing object:nil];
    
    [self configureview];
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

#pragma mart - Other

- (void)configureview {
    [self.buttonFirst setEnabled:[self.urls objectForKey:@"first"] == nil ? NO : YES];
    [self.buttonPrev setEnabled:[self.urls objectForKey:@"prev"] == nil ? NO : YES];
    [self.buttonNext setEnabled:[self.urls objectForKey:@"next"] == nil ? NO : YES];
    [self.buttonLast setEnabled:[self.urls objectForKey:@"last"] == nil ? NO : YES];
    
    [self.tableView reloadData];
}

- (void)getData:(NSString *)url {
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:nil];
                
                [alertController addAction:action];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                [self.objects removeAllObjects];
                
                [self configureview];
            });
        } else {
            NSMutableDictionary *links = [[NSMutableDictionary alloc] init];
            NSString *linkHeader = [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Link"];
            
            if ([linkHeader length] != 0) {
                NSArray *_links = [linkHeader componentsSeparatedByString:@", "];
                
                for (int i=0; i<[_links count]; ++i) {
                    NSArray *_link = [[_links objectAtIndex:i] componentsSeparatedByString:@"; "];
                    
                    if ([_link count] == 2) {
                        NSArray *_tokens = [[_link objectAtIndex:1] componentsSeparatedByString:@"\""];
                        
                        if ([_tokens count] == 3) {
                            NSString *key = [_tokens objectAtIndex:1];
                            NSString *value = [[[_link objectAtIndex:0] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
                            
                            [links setObject:value forKey:key];
                        }
                    }
                }
            }

            NSError *jsonError = nil;
            NSDictionary *jsonOutput = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (jsonError != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error") message:[jsonError localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:nil];
                    
                    [alertController addAction:action];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    [self.objects removeAllObjects];
                    
                    [self configureview];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.urls = [NSDictionary dictionaryWithDictionary:links];
                    self.data = [NSDictionary dictionaryWithDictionary:jsonOutput];
                    
                    [self configureview];
                });
            }
        }
    }] resume];
}

#pragma mark - Notifications

- (void)textFieldDidEndEditing:(NSNotification *)notification {
    if ([self.searchTableViewCell.textField.text length] != 0) {
        NSString *url = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@&page=1&per_page=100&order=asc", [self.searchTableViewCell.textField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        
        [self getData:url];
    } else {
        [self.objects removeAllObjects];
        
        [self configureview];
    }
}

#pragma mark - Actions

- (void)first {
    [self getData:[self.urls objectForKey:@"first"]];
}

- (void)prev {
    [self getData:[self.urls objectForKey:@"prev"]];
}

- (void)next {
    [self getData:[self.urls objectForKey:@"next"]];
}

- (void) last {
    [self getData:[self.urls objectForKey:@"last"]];
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
