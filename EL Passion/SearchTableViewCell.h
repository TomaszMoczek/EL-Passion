//
//  SearchTableViewCell.h
//  EL Passion
//
//  Created by Tomasz Moczek on 11/13/16.
//  Copyright © 2016 Tomasz Moczek. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const TextFieldDidEndEditing;

@interface SearchTableViewCell : UITableViewCell <UITextFieldDelegate> {
    NSString *_prevText;
    UIImageView *_imageView;
    UITextField *_textField;
}

@property (strong, nonatomic) NSString *prevText;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextField *textField;

@end


