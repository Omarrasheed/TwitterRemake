//
//  TweetDetailViewController.h
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/3/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailViewController : UIViewController

@property (strong, nonatomic) Tweet *tweet;

- (void)setTweetDetailView;

@end
