//
//  APIManager.m
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/2/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey =  @"";
static NSString * const consumerSecret = @"";

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:consumerKey forKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:consumerSecret forKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
    // Create a GET Request
    [self GET:@"1.1/statuses/home_timeline.json" parameters:@{@"count":@"200"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
       
        // Manually cache the tweets. If the request fails, restore from cache if possible.
        NSArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
        
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"hometimeline_tweets"];
       
       completion(tweets, nil);
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       NSMutableArray *tweetDictionaries = nil;
       
       // Fetch tweets from cache if possible
       NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
       if (data != nil) {
           tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
       }
       
       completion(tweetDictionaries, error);
   }];
}

- (void)getMoreTimelineTweets:(NSInteger)maxId completion:(void(^)(NSMutableArray *tweets, NSError *error))completion {
    // Create a GET Request
    [self GET:@"1.1/statuses/home_timeline.json" parameters:@{@"count":@"200", @"max_id":[NSString stringWithFormat:@"%ld", (maxId-1)]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        
        NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
        
        completion(tweets, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSMutableArray *tweetDictionaries = nil;
        
        // Fetch tweets from cache if possible
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
        if (data != nil) {
            tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        
        completion(tweetDictionaries, error);
    }];
}

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *tweet, NSError *error))completion{
    
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion{
    
    NSString *urlString = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion{
    
    NSString *urlString = @"1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion{
    
    NSString *urlString = [[@"1.1/statuses/retweet/" stringByAppendingString:tweet.idStr] stringByAppendingString:@".json"];
    NSDictionary *parameters = @{};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion{
    
    NSString *urlString = [[@"1.1/statuses/unretweet/" stringByAppendingString:tweet.idStr] stringByAppendingString:@".json"];
    NSDictionary *parameters = @{};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)saveTweetArrayData:(Tweet *)tweetsList key:(NSString *)storageKey {
    NSMutableArray * mutableDataArray = [[NSMutableArray alloc] init];
    [mutableDataArray addObject:tweetsList];
    
    NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:mutableDataArray.count];
    for (Tweet *personObject in mutableDataArray) {
        NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:personObject];
        [archiveArray addObject:personEncodedObject];
    }
    
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    [userData setObject:archiveArray forKey:storageKey];
}

- (void)getPersonalUserInfo:(void(^)(NSArray *tweets, NSError *error))completion {
    
    // Create a GET Request
    [self GET:@"1.1/account/verify_credentials.json" parameters:@{@"count":@"200"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        
        // Manually cache the tweets. If the request fails, restore from cache if possible.
        NSArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
        
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"hometimeline_tweets"];
        
        completion(tweets, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSMutableArray *tweetDictionaries = nil;
        
        // Fetch tweets from cache if possible
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
        if (data != nil) {
            tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        
        completion(tweetDictionaries, error);
    }];
}

@end
