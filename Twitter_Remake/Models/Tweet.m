//
//  Tweet.m
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/2/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "Tweet.h"
#import <DateTools.h>

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        // Is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil){
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            
            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] floatValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] floatValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
        // initialize user
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        
        // TODO: Format and set createdAtString
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        // Convert String to Date
        self.dateTime = [formatter dateFromString:createdAtOriginalString];
        
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        
        // Convert Date to String
        self.dateTimeString = [formatter stringFromDate:self.dateTime];
        
        NSDate *now = [NSDate date];
        NSInteger daysApart = [now daysFrom:self.dateTime];
        NSInteger hoursApart = [now hoursFrom:self.dateTime];
        NSInteger minutesApart = [now minutesFrom:self.dateTime];
        NSInteger secondsApart = [now secondsFrom:self.dateTime];
        // Convert Date to String according to post time
        if (daysApart < (NSInteger)7) {
            if (daysApart < 1) {
                if (hoursApart < 1) {
                    if (minutesApart < 1) {
                        self.createdAtString = [NSString stringWithFormat:@"%lds", secondsApart];
                    } else {
                        self.createdAtString = [NSString stringWithFormat:@"%ldm", minutesApart];
                    }
                } else {
                    self.createdAtString = [NSString stringWithFormat:@"%ldh", hoursApart];
                }
            } else {
                self.createdAtString = [NSString stringWithFormat:@"%ldd", daysApart];
            }
        } else {
            self.createdAtString = self.dateTimeString;
        }
    }
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
