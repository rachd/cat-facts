//
//  RMDCatFacts.h
//  CatFacts2
//
//  Created by Rachel Dorn on 6/9/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMDCatFacts : NSObject

- (void)fetchFacts:(int)number success:(void (^)(NSArray *response))success failure:(void(^)(NSError* error))failure;

@end
