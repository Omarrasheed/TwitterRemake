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

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSMutableArray *tweets, NSError *error))completion;

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *tweet, NSError *error))completion;

@end
