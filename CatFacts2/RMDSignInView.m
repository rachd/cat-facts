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

@end

@implementation RMDSignInView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpEmailField];
        [self setUpPasswordField];
        [self setUpSubmitButton];
    }
    return self;
}

- (void)setUpEmailField {
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, self.frame.size.width - 40, 40)];
    self.emailField.placeholder = @"Email Address";
    [self addSubview:self.emailField];
}

- (void)setUpPasswordField {
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20, 160, self.frame.size.width - 40, 40)];
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    [self addSubview:self.passwordField];
}

- (void)setUpSubmitButton {
    self.submitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 4, 220, self.frame.size.width / 2, 40)];
    self.submitButton.backgroundColor = [UIColor blueColor];
    [self.submitButton addTarget:self.delegate action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitButton];
}

@end
