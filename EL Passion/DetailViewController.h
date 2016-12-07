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

@interface DetailViewController : UITableViewController {
    UIBarButtonItem *_buttonFirst;
    UIBarButtonItem *_buttonPrev;
    UIBarButtonItem *_buttonNext;
    UIBarButtonItem *_buttonLast;
}

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) UIBarButtonItem *buttonFirst;
@property (strong, nonatomic) UIBarButtonItem *buttonPrev;
@property (strong, nonatomic) UIBarButtonItem *buttonNext;
@property (strong, nonatomic) UIBarButtonItem *buttonLast;

@end

