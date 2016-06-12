//
//  RMDSignInView.m
//  CatFacts2
//
//  Created by Rachel Dorn on 6/11/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import "RMDSignInView.h"

@interface RMDSignInView ()

@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *registerButton;

@end

@implementation RMDSignInView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:1.0];
        [self setUpEmailField];
        [self setUpPasswordField];
        [self setUpSubmitButton];
        [self setUpRegisterSection];
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
    [self.submitButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.submitButton addTarget:self.delegate action:@selector(signInUser) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitButton];
}

- (void)setUpRegisterSection {
    UILabel *registerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, self.frame.size.width, 40)];
    registerLabel.text = @"Don't have an account?";
    registerLabel.textColor = [UIColor blackColor];
    registerLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:registerLabel];
    
    self.registerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 4, 370, self.frame.size.width / 2, 40)];
    self.registerButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.6 alpha:1.0];
    self.registerButton.layer.cornerRadius = 8;
    [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.registerButton addTarget:self.delegate action:@selector(showRegisterView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.registerButton];
}

@end
