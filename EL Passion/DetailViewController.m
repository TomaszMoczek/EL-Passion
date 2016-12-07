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

@synthesize data = _data;
@synthesize image = _image;
@synthesize repos = _repos;
@synthesize urls = _urls;
@synthesize buttonFirst = _buttonFirst;
@synthesize buttonPrev = _buttonPrev;
@synthesize buttonNext = _buttonNext;
@synthesize buttonLast = _buttonLast;

#pragma mark - Table View

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        [self.data removeAllObjects];
        [self.image setData:[NSData dataWithBytes:nil length:0]];
        [self.repos removeAllObjects];
        [self.urls removeAllObjects];
        
        [self getData:[_detailItem description] typeOfData:UserData];
        
        [self configureView];
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

    [self configureView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    self.detailItem = nil;
    
    [self.data removeAllObjects];
    [self.image setData:[NSData dataWithBytes:nil length:0]];
    [self.repos removeAllObjects];
    [self.urls removeAllObjects];
    
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

- (void)getData:(NSString *)url typeOfData:(DataType)dataType {
    if (url != nil) {
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if ([[error localizedDescription] length] != 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:nil];
                    
                    [alertController addAction:action];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                });
            } else {
                NSError *jsonError = nil;
                NSDictionary *jsonOutput = nil;
                NSUInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                
                if (dataType == UserData || dataType == ReposData) {
                    jsonOutput = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                }
                
                if ([[jsonError localizedDescription] length] != 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error") message:[jsonError localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:nil];
                        
                        [alertController addAction:action];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                } else if (statusCode != 200) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *message = nil;
                        
                        if (dataType == UserData || dataType == ReposData) {
                            message = [NSString stringWithFormat:@"%@: %lu\n%@: %@\n\n%@", NSLocalizedString(@"Status Code", @"Status Code"), (unsigned long)statusCode, NSLocalizedString(@"Description", @"Description"), [NSHTTPURLResponse localizedStringForStatusCode:statusCode], [jsonOutput objectForKey:@"message"]];
                        } else {
                            message = [NSString stringWithFormat:@"%@: %lu\n%@: %@", NSLocalizedString(@"Status Code", @"Status Code"), (unsigned long)statusCode, NSLocalizedString(@"Description", @"Description"), [NSHTTPURLResponse localizedStringForStatusCode:statusCode]];
                        }
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error") message:message preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:nil];
                        
                        [alertController addAction:action];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                } else {
                    switch (dataType) {
                        case UserData: {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.data = [NSMutableDictionary dictionaryWithDictionary:jsonOutput];
                                
                                [self getData:[self.data objectForKey:@"avatar_url"] typeOfData:ImageData];
                                [self getData:[self.data objectForKey:@"repos_url"] typeOfData:ReposData];
                                
                                [self.tableView reloadData];
                            });
                        }
                        break;
                            
                        case ImageData: {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.image = [NSMutableData dataWithData:data];
                                
                                [self.tableView reloadData];
                            });
                        }
                        break;
                            
                        case ReposData: {
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
                                self.repos = [NSMutableArray arrayWithArray:(NSArray *)jsonOutput];
                                self.urls = [NSMutableDictionary dictionaryWithDictionary:links];
                                
                                [self configureView];
                            });
                        }
                        break;
                            
                        default:
                            break;
                    }
                }
            }
        }] resume];
    }
}

#pragma mark - Actions

- (void)first {
    [self getData:[self.urls objectForKey:@"first"] typeOfData:ReposData];
}

- (void)prev {
    [self getData:[self.urls objectForKey:@"prev"] typeOfData:ReposData];
}

- (void)next {
    [self getData:[self.urls objectForKey:@"next"] typeOfData:ReposData];
}

- (void)last {
    [self getData:[self.urls objectForKey:@"last"] typeOfData:ReposData];
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
            return [self.repos count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == UserSection) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
        
        if (self.detailItem == nil) {
            cell.textLabel.text = NSLocalizedString(@"Find and select the GitHub's User", @"Empty");
            cell.detailTextLabel.text = NSLocalizedString(@"The GitHub's User is to be found and selected prior to report its details here.", @"Empty-Description");
        } else {
            cell.textLabel.text = [self.data objectForKey:@"login"];
            cell.detailTextLabel.text = [self.data objectForKey:@"login"];
        }
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
