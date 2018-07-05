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
        self.profileURL =[NSURL URLWithString:dictionary[@"profile_image_url"]];
    }
    return self;
}

@end
