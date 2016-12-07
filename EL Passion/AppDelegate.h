//
//  AppDelegate.h
//  EL Passion
//
//  Created by Tomasz Moczek on 11/11/16.
//  Copyright © 2016 Tomasz Moczek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)displayTableViewCell:(UITableView *)tableView forCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

