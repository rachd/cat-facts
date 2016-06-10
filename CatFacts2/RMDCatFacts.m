//
//  RMDCatFacts.m
//  CatFacts2
//
//  Created by Rachel Dorn on 6/9/16.
//  Copyright © 2016 Rachel Dorn. All rights reserved.
//

#import "RMDCatFacts.h"

@implementation RMDCatFacts

- (void)fetchFacts:(int)number success:(void (^)(NSArray *response))success failure:(void(^)(NSError* error))failure {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://catfacts-api.appspot.com/api/facts?number=%d", number]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (response) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                success([json objectForKey:@"facts"]);
            });
        } else {
            NSArray *blankArray = [[NSArray alloc] initWithObjects:@"Please check your internet connection and try again", nil];
            success(blankArray);
        }
    }];
    [dataTask resume];
}

@end
