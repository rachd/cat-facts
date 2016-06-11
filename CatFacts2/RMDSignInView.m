//
//  RMDSignInView.m
//  CatFacts2
//
//  Created by Rachel Dorn on 6/11/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import "RMDSignInView.h"

@implementation RMDSignInView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpEmailField];
        [self setUpPasswordField];
    }
    return self;
}

- (void)setUpEmailField {
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, self.frame.size.width - 40, 40)];
    self.emailField.placeholder = @"Email Address";
    [self addSubview:self.emailField];
}

- (void)setUpPasswordField {
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, self.frame.size.width - 40, 40)];
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    [self addSubview:self.passwordField];
}

@end
