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

typedef enum {
    UserData = 0,
    ImageData,
    ReposData
} DataType;

@interface DetailViewController : UITableViewController {
    NSMutableDictionary *_data;
    NSMutableData *_image;
    NSMutableArray *_repos;
    NSMutableDictionary *_urls;
    UIBarButtonItem *_buttonFirst;
    UIBarButtonItem *_buttonPrev;
    UIBarButtonItem *_buttonNext;
    UIBarButtonItem *_buttonLast;
}

@property (strong, nonatomic) id detailItem;
@property (strong, atomic) NSMutableDictionary *data;
@property (strong, atomic) NSMutableData *image;
@property (strong, atomic) NSMutableArray *repos;
@property (strong, atomic) NSMutableDictionary *urls;
@property (strong, nonatomic) UIBarButtonItem *buttonFirst;
@property (strong, nonatomic) UIBarButtonItem *buttonPrev;
@property (strong, nonatomic) UIBarButtonItem *buttonNext;
@property (strong, nonatomic) UIBarButtonItem *buttonLast;

@end

