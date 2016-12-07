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
    UsersSection
};

@class DetailViewController;
@class SearchTableViewCell;

@interface MasterViewController : UITableViewController {
    UIBarButtonItem *_buttonFirst;
    UIBarButtonItem *_buttonPrev;
    UIBarButtonItem *_buttonNext;
    UIBarButtonItem *_buttonLast;
    SearchTableViewCell *_searchTableViewCell;
}

@property (strong, nonatomic) UIBarButtonItem *buttonFirst;
@property (strong, nonatomic) UIBarButtonItem *buttonPrev;
@property (strong, nonatomic) UIBarButtonItem *buttonNext;
@property (strong, nonatomic) UIBarButtonItem *buttonLast;
@property (strong, nonatomic) SearchTableViewCell *searchTableViewCell;
@property (strong, nonatomic) DetailViewController *detailViewController;

@end

