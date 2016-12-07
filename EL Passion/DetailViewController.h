//
//  DetailViewController.h
//  EL Passion
//
//  Created by Tomasz Moczek on 11/11/16.
//  Copyright © 2016 Tomasz Moczek. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    UserSection = 0,
    RepositoriesSection
};

@interface DetailViewController : UITableViewController

@property (strong, nonatomic) id detailItem;

@end

