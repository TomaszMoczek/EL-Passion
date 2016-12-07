//
//  SearchTableViewCell.h
//  EL Passion
//
//  Created by Tomasz Moczek on 11/13/16.
//  Copyright © 2016 Tomasz Moczek. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const ImageViewTouchBegan;
extern NSString * const TextFieldDidEndEditing;

@interface SearchTableViewCell : UITableViewCell <UITextFieldDelegate> {
    UIImageView *_imageView;
    UITextField *_textField;
    UILabel *_label;
}

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *label;

- (void)setLabelText;

@end


