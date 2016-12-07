//
//  SearchTableViewCell.m
//  EL Passion
//
//  Created by Tomasz Moczek on 11/13/16.
//  Copyright © 2016 Tomasz Moczek. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

@synthesize imageView = _imageView;
@synthesize textField = _textField;
@synthesize label = _label;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GitHub"]];
        self.imageView.userInteractionEnabled = YES;
        
        self.textField = [[UITextField alloc] init];
        self.textField.delegate = self;
        self.textField.textAlignment = NSTextAlignmentLeft;
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.placeholder = NSLocalizedString(@"Search", @"Search");
        self.textField.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:18.0];
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [self.textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        
        self.label = [[UILabel alloc] init];
        self.label.font = [UIFont fontWithName:@"Georgia" size:7.0];
        self.label.text = NSLocalizedString(@"Tap the GitHub's image to Sign In ...", @"Tap the GitHub's image to Sign In ...");
        
        [self addSubview:self.imageView];
        [self addSubview:self.textField];
        [self addSubview:self.label];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.imageView.frame = CGRectMake(self.bounds.origin.x + 10.0, 0.0, 84.0, 84.0);
        self.textField.frame = CGRectMake(self.bounds.origin.x + 94.0, 10.0, self.bounds.size.width - 114.0, 32.0);
        self.label.frame = CGRectMake(self.bounds.origin.x + 94.0, 58.0, self.bounds.size.width - 114.0, 12.0);
    } else {
        self.imageView.frame = CGRectMake(self.bounds.origin.x + 10.0, 0.0, 104.0, 104.0);
        self.textField.frame = CGRectMake(self.bounds.origin.x + 114.0, 10.0, self.bounds.size.width - 134.0, 32.0);
        self.label.frame = CGRectMake(self.bounds.origin.x + 114.0, 78.0, self.bounds.size.width - 114.0, 12.0);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    
    return YES;
}

@end
