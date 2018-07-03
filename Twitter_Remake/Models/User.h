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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
