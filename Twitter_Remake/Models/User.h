//
//  User.h
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/2/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSURL *profileURL;
@property (strong, nonatomic) NSURL *profileBackgroundURL;
@property (strong, nonatomic) NSString *followingCount;
@property (strong, nonatomic) NSString *followerCount;
@property (strong, nonatomic) NSString *tweetsCount;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
