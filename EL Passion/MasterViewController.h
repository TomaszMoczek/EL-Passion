//
//  MasterViewController.h
//  EL Passion
//
//  Created by Tomasz Moczek on 11/11/16.
//  Copyright © 2016 Tomasz Moczek. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    SearchSection = 0,
    ResultsSection
};

@class DetailViewController;
@class SearchTableViewCell;

@interface MasterViewController : UITableViewController {
    SearchTableViewCell *_searchTableViewCell;
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) SearchTableViewCell *searchTableViewCell;

@end

