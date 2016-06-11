//
//  RMDRegisterView.h
//  CatFacts2
//
//  Created by Rachel Dorn on 6/11/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RMDRegisterViewDelegate <NSObject>

@required
- (void)registerUser;

@end

@interface RMDRegisterView : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id <RMDRegisterViewDelegate> delegate;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;

@end
