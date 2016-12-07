//
//  SearchTableViewCell.m
//  EL Passion
//
//  Created by Tomasz Moczek on 11/13/16.
//  Copyright © 2016 Tomasz Moczek. All rights reserved.
//

#import "SearchTableViewCell.h"

NSString * const ImageViewTouchBegan = @"ImageViewTouchBegan";
NSString * const TextFieldDidEndEditing = @"TextFieldDidEndEditing";

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
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            self.label.font = [UIFont fontWithName:@"Georgia" size:7.0];
        } else {
            self.label.font = [UIFont fontWithName:@"Georgia" size:11.0];
        }
        
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
        self.textField.frame = CGRectMake(self.bounds.origin.x + 94.0, 20.0, self.bounds.size.width - 114.0, 32.0);
        self.label.frame = CGRectMake(self.bounds.origin.x + 94.0, 58.0, self.bounds.size.width - 114.0, 12.0);
    } else {
        self.imageView.frame = CGRectMake(self.bounds.origin.x + 10.0, 10.0, 84.0, 84.0);
        self.textField.frame = CGRectMake(self.bounds.origin.x + 94.0, 30.0, self.bounds.size.width - 114.0, 32.0);
        self.label.frame = CGRectMake(self.bounds.origin.x + 94.0, 68.0, self.bounds.size.width - 114.0, 12.0);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setLabelText {
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"];
    
    if ([userName length] != 0) {
        self.label.text = [NSString stringWithFormat:@"%@:  %@", NSLocalizedString(@"Authenticating as", @"Authenticating as"), userName];
    } else {
        self.label.text = NSLocalizedString(@"Tap the GitHub's image to enter Credentials ...", @"Tap the GitHub's image to enter Credentials ...");
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self.imageView) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ImageViewTouchBegan object:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:TextFieldDidEndEditing object:self];
}

@end
