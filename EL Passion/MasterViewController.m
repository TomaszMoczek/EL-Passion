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

@end

@implementation MasterViewController

@synthesize data = _data;
@synthesize urls = _urls;
@synthesize images = _images;
@synthesize buttonFirst = _buttonFirst;
@synthesize buttonPrev = _buttonPrev;
@synthesize buttonNext = _buttonNext;
@synthesize buttonLast = _buttonLast;
@synthesize searchTableViewCell = _searchTableViewCell;

#pragma mark  - Table View

- (void)viewDidLoad {
    [super viewDidLoad];

    self.images = [[NSMutableDictionary alloc] init];
    
    self.title = NSLocalizedString(@"GitHub's Users", @"GitHub's Users");
    
    self.buttonFirst = [[UIBarButtonItem alloc] initWithTitle:@"<<" style:UIBarButtonItemStyleDone target:self action:@selector(first)];
    self.buttonPrev = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleDone target:self action:@selector(prev)];
    self.buttonNext = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleDone target:self action:@selector(next)];
    self.buttonLast = [[UIBarButtonItem alloc] initWithTitle:@">>" style:UIBarButtonItemStyleDone target:self action:@selector(last)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.buttonLast, self.buttonNext, self.buttonPrev, self.buttonFirst, nil]];
    
    self.searchTableViewCell = [[SearchTableViewCell alloc] initWithFrame:CGRectZero];
    
    [self.searchTableViewCell setLabelText];
    
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageViewTouchBegan:) name:ImageViewTouchBegan object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:TextFieldDidEndEditing object:nil];
    
    [self configureView];
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
    
    [self.data removeAllObjects];
    [self.urls removeAllObjects];
    [self.images removeAllObjects];
    
    [super viewDidUnload];
}

#pragma mark - Other

- (void)configureView {
    [self.buttonFirst setEnabled:[self.urls objectForKey:@"first"] == nil ? NO : YES];
    [self.buttonPrev setEnabled:[self.urls objectForKey:@"prev"] == nil ? NO : YES];
    [self.buttonNext setEnabled:[self.urls objectForKey:@"next"] == nil ? NO : YES];
    [self.buttonLast setEnabled:[self.urls objectForKey:@"last"] == nil ? NO : YES];
    
    [self.tableView reloadData];
}

- (void)getData:(NSString *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"Password"];

    if ([username length] != 0) {
        NSString *authString = [NSString stringWithFormat:@"%@:%@", username, password];
        NSString *authHeader = [NSString stringWithFormat:@"Basic %@", [[authString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]];
        
        [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    }
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([[error localizedDescription] length] != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:nil];
                
                [alertController addAction:action];
                
                [self presentViewController:alertController animated:YES completion:nil];
            });
        } else {
            NSError *jsonError = nil;
            NSUInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            NSDictionary *jsonOutput = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if ([[jsonError localizedDescription] length] != 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error") message:[jsonError localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:nil];
                    
                    [alertController addAction:action];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                });
            } else if (statusCode != 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *message = [NSString stringWithFormat:@"%@: %lu\n%@: %@\n\n%@", NSLocalizedString(@"Status Code", @"Status Code"), (unsigned long)statusCode, NSLocalizedString(@"Description", @"Description"), [NSHTTPURLResponse localizedStringForStatusCode:statusCode], [jsonOutput objectForKey:@"message"]];
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error") message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:nil];
                    
                    [alertController addAction:action];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
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
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.data = [NSMutableArray arrayWithArray:[jsonOutput objectForKey:@"items"]];
                    self.urls = [NSMutableDictionary dictionaryWithDictionary:links];
                    
                    [self.images removeAllObjects];
                    
                    [self configureView];
                });
            }
        }
    }] resume];
}

#pragma mark - Notifications

- (void)imageViewTouchBegan:(NSNotification *)notification {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"EL Passion" message:NSLocalizedString(@"Enter GitHub's Credentials", @"Enter GitHub's Credentials") preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * textField) {
        textField.placeholder = @"Username";
        textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];
        
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * textField) {
        textField.secureTextEntry = YES;
        textField.placeholder = @"Password";
        textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"Password"];
        
        [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    }];
    
    UIAlertAction *alertActionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertAction) {
        [[NSUserDefaults standardUserDefaults] setObject:[alertController.textFields objectAtIndex:0].text forKey:@"Username"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[alertController.textFields objectAtIndex:1].text forKey:@"Password"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.searchTableViewCell setLabelText];
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *alertAction) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:alertActionOK];
    [alertController addAction:alertActionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)textFieldDidEndEditing:(NSNotification *)notification {
    if ([self.searchTableViewCell.textField.text length] != 0) {
        NSString *url = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@&page=1&per_page=100&order=asc", [self.searchTableViewCell.textField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        
        [self getData:url];
    } else {
        [self.data removeAllObjects];
        [self.urls removeAllObjects];
        [self.images removeAllObjects];
        
        [self configureView];
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

- (void)last {
    [self getData:[self.urls objectForKey:@"last"]];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *url = [[self.data objectAtIndex:indexPath.row] objectForKey:@"url"];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:url];
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
            return [self.data count];
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

        UIImage *image = nil;
        NSData *imageData = [self.images objectForKey:[[self.data objectAtIndex:indexPath.row] objectForKey:@"id"]];
        
        if (imageData == nil) {
            image = [UIImage imageNamed:@"NoImage"];
            
            [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[[self.data objectAtIndex:indexPath.row] objectForKey:@"avatar_url"]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error == nil && [(NSHTTPURLResponse *)response statusCode] == 200) {
                    UIImage *image = [UIImage imageWithData:data];
                    NSData *imageData = [NSData dataWithData:data];
                    
                    if (image != nil && image.size.width != 0 && image.size.height != 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (cell.tag == indexPath.row) {
                                [[cell imageView] setImage:image];
                                
                                CGFloat widthScale = 36.0 / image.size.width;
                                CGFloat heightScale = 36.0 / image.size.height;
                                
                                [[cell imageView] setTransform:CGAffineTransformMakeScale(widthScale, heightScale)];
                                
                                [cell layoutSubviews];
                                
                                [self.images setObject:imageData forKey:[[self.data objectAtIndex:indexPath.row] objectForKey:@"id"]];
                            }
                        });
                    }
                }
            }] resume];
        } else {
            image = [UIImage imageWithData:imageData];
        }
        
        if (image != nil && image.size.width != 0 && image.size.height != 0) {
            cell.tag = indexPath.row;
            cell.imageView.image = image;
            
            CGFloat widthScale = 36.0 / image.size.width;
            CGFloat heightScale = 36.0 / image.size.height;
            
            cell.imageView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        }
        
        cell.textLabel.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"login"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Score: %@", [[self.data objectAtIndex:indexPath.row] objectForKey:@"score"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) displayTableViewCell:tableView forCell:cell forRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
