//
//  RMDRegisterView.m
//  CatFacts2
//
//  Created by Rachel Dorn on 6/11/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import "RMDRegisterView.h"

@interface RMDRegisterView ()

@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation RMDRegisterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpEmailField];
        [self setUpPasswordField];
        [self setUpSubmitButton];
        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:1.0];
    }
    return self;
}

- (void)setUpEmailField {
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, self.frame.size.width - 40, 40)];
    self.emailField.placeholder = @"Email Address";
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:self.emailField];
}

- (void)setUpPasswordField {
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20, 160, self.frame.size.width - 40, 40)];
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:self.passwordField];
}

- (void)setUpSubmitButton {
    self.submitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 4, 220, self.frame.size.width / 2, 40)];
    self.submitButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.6 alpha:1.0];
    self.submitButton.layer.cornerRadius = 8;
    [self.submitButton setTitle:@"Register" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.submitButton addTarget:self.delegate action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitButton];
}

@end
