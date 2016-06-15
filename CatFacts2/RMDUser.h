//
//  RMDUser.h
//  CatFacts2
//
//  Created by Rachel Dorn on 6/14/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface RMDUser : NSObject

@property (nonatomic, copy) NSArray *facts;
@property (nonatomic, copy) NSString *userID;

+ (RMDUser *)currentUser;

+ (void)login:(NSString *)userID success:(void (^)(void))success;
+ (void)login:(NSString *)userID withFacts:(NSArray *)facts;
- (void)logout;

@end
