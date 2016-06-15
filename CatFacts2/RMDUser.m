//
//  RMDUser.m
//  CatFacts2
//
//  Created by Rachel Dorn on 6/14/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import "RMDUser.h"

@implementation RMDUser

+ (RMDUser *)currentUser {
    RMDUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
    return user;
}

+ (void)login:(NSString *)uid {
    RMDUser *user = [[RMDUser alloc] init];
    [user setUserID:uid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self fetchFacts:user];
    });
    NSData *encodedUserObject = [NSKeyedArchiver archivedDataWithRootObject:user];
    
    [[NSUserDefaults standardUserDefaults] setObject:encodedUserObject forKey:@"user"];
}

+ (void)login:(NSString *)uid withFacts:(NSArray *)facts {
    RMDUser *user = [[RMDUser alloc] init];
    [user setUserID:uid];
    [user setFacts:[self formatFacts:facts]];
     NSData *encodedUserObject = [NSKeyedArchiver archivedDataWithRootObject:user];
     
     [[NSUserDefaults standardUserDefaults] setObject:encodedUserObject forKey:@"user"];
}

- (void)logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        self.userID = [decoder decodeObjectForKey:@"userId"];
        self.facts = [decoder decodeObjectForKey:@"facts"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.facts forKey:@"facts"];
}

- (id)copyWithZone:(NSZone *)zone {
    RMDUser *objectCopy = [[RMDUser allocWithZone:zone] init];
    [objectCopy setUserID:self.userID];
    [objectCopy setFacts:self.facts];
    return objectCopy;
}

+ (void)fetchFacts:(RMDUser *)user {
//    user.facts = @[@"one", @"two", @"hello my name is Inigo Montoya, you killed my father, prepare to die."];
    NSString *userID = [FIRAuth auth].currentUser.uid;
    [[[[[FIRDatabase database] reference] child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        if (snapshot.value[@"facts"]) {
            user.facts = [self formatFacts:snapshot.value[@"facts"]];
        } else {
            NSLog(@"no facts in database");
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

+ (NSArray *)formatFacts:(NSArray *)facts {
    NSMutableArray *allFacts = [[NSMutableArray alloc] init];
    for (NSArray *hundred in facts) {
        for (NSString *fact in hundred) {
            [allFacts addObject:fact];
        }
    }
    return [allFacts copy];
}

@end
