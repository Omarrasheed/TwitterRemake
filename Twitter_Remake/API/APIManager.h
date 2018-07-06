//
//  APIManager.h
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/2/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

//#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"
#import "User.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)getMoreTimelineTweets:(NSInteger)maxId completion:(void(^)(NSMutableArray *tweets, NSError *error))completion;

- (void)getMentionsTimelineTweets:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *tweet, NSError *error))completion;

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;

- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *error))completion;

- (void)getPersonalUserInfo:(void(^)(User *user, NSError *error))completion;

- (void)getSpecifiedUserInfo:(User *)user completion:(void(^)(NSMutableArray *tweets, NSError *error))completion;

@end
