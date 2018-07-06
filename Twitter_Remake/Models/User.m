//
//  User.m
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/2/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        NSString* handle = [NSString stringWithFormat:@"@%@",  dictionary[@"screen_name"]];
        self.screenName = handle;
        
        if (![dictionary[@"profile_image_url"] isKindOfClass:[NSNull class]]) {
            self.profileURL =[NSURL URLWithString:dictionary[@"profile_image_url"]];
        } else {
            self.profileURL = nil;
        }
        
        if (![dictionary[@"profile_background_image_url"] isKindOfClass:[NSNull class]]) {
            self.profileBackgroundURL = [NSURL URLWithString:dictionary[@"profile_background_image_url"]];
        } else {
            self.profileBackgroundURL = nil;
        }
        self.followerCount = [NSString stringWithFormat:@"%@", dictionary[@"followers_count"]];
        self.followingCount = [NSString stringWithFormat: @"%@", dictionary[@"friends_count"]];
        self.tweetsCount = [NSString stringWithFormat: @"%@", dictionary[@"statuses_count"]];
        
    }
    return self;
}

@end
