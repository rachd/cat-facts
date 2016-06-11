//
//  RMDSignInView.h
//  CatFacts2
//
//  Created by Rachel Dorn on 6/11/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMDSignInView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;

@end
