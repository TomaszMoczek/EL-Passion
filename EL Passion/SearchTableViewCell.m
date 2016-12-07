//
//  SearchTableViewCell.m
//  EL Passion
//
//  Created by Tomasz Moczek on 11/13/16.
//  Copyright © 2016 Tomasz Moczek. All rights reserved.
//

#import "SearchTableViewCell.h"

NSString * const TextFieldDidEndEditing = @"TextFieldDidEndEditing";

@implementation SearchTableViewCell

@synthesize prevText = _prevText;
@synthesize imageView = _imageView;
@synthesize textField = _textField;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GitHub"]];
        
        self.textField = [[UITextField alloc] init];
        self.textField.delegate = self;
        self.textField.textAlignment = NSTextAlignmentLeft;
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.placeholder = NSLocalizedString(@"Search", @"Search");
        self.textField.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:18.0];
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [self.textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        
        [self addSubview:self.imageView];
        [self addSubview:self.textField];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.imageView.frame = CGRectMake(self.bounds.origin.x + 10.0, 0.0, 84.0, 84.0);
        self.textField.frame = CGRectMake(self.bounds.origin.x + 94.0, 26.0, self.bounds.size.width - 114.0, 32.0);
    } else {
        self.imageView.frame = CGRectMake(self.bounds.origin.x + 10.0, 10.0, 84.0, 84.0);
        self.textField.frame = CGRectMake(self.bounds.origin.x + 94.0, 36.0, self.bounds.size.width - 114.0, 32.0);
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.prevText = [NSString stringWithString:textField.text];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (![self.prevText isEqualToString:textField.text]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TextFieldDidEndEditing object:self];
    }
}

@end
