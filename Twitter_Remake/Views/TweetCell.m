//
//  TweetCell.m
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/2/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageview+AFNetworking.h"
#import "APIManager.h"
#import <QuartzCore/QuartzCore.h>
#import <DateTools.h>

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTweet{
    [self setUsernameLabelText];
    [self setHandleLabelText];
    [self setDateTimeLabelText];
    [self setTweetContentLabelText];
    [self setReplyCountLabelText];
    [self setFavCountLabelText];
    [self setRetweetCountLabelText];
    [self setProfileImageViewImage];
    [self setFavIconImage];
    [self setRetweetIconImage];
}
- (IBAction)replyButtonTapped:(id)sender {
}
- (IBAction)retweetButtonTapped:(id)sender {
    if (self.tweet.retweeted) {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [self.retweetIcon setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        [self unretweetPostCall];
    } else {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self.retweetIcon setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        [self retweetPostCall];
    }
}
- (IBAction)favButtonTapped:(id)sender {
    if (self.tweet.favorited) {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self.favIcon setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        [self unFavPostCall];
    } else {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self.favIcon setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        [self favPostCall];
    }
    
    [self refreshData];
    
}
- (IBAction)shareButtonTapped:(id)sender {
    NSLog(@"Share Button Tapped");
}

- (void)refreshData {
    [self setFavCountLabelText];
    [self setRetweetCountLabelText];
    [self setReplyCountLabelText];
}

- (void)setUsernameLabelText {
    self.usernameLabel.text = self.tweet.user.name;
    [self.usernameLabel sizeToFit];
}
- (void)setHandleLabelText {
    self.handleLabel.text = self.tweet.user.screenName;
    [self.handleLabel sizeToFit];
}
- (void)setDateTimeLabelText {
    self.dateTimeLabel.text = self.tweet.createdAtString;
    [self.dateTimeLabel sizeToFit];
}
- (void)setTweetContentLabelText {
    self.tweetContentLabel.text = self.tweet.text;
    [self.tweetContentLabel sizeToFit];
}
- (void)setReplyCountLabelText {
    self.replyCountLabel.text = [NSString stringWithFormat:@"Reply"];
    [self.replyCountLabel sizeToFit];
}
- (void)setFavCountLabelText {
    if (self.tweet.favoriteCount > 999) {
        self.tweet.favoriteCount = self.tweet.favoriteCount/1000;
        self.favCountLabel.text = [NSString stringWithFormat:@"%.1fK", self.tweet.favoriteCount];
    } else if (self.tweet.favoriteCount > 999999) {
        self.tweet.favoriteCount = self.tweet.favoriteCount/1000;
        self.favCountLabel.text = [NSString stringWithFormat:@"%.1fM", self.tweet.favoriteCount];
    } else {
        self.favCountLabel.text = [NSString stringWithFormat:@"%d", (int) self.tweet.favoriteCount];
    }
    [self.favCountLabel sizeToFit];
}
- (void)setRetweetCountLabelText {
    if (self.tweet.retweetCount > 999) {
        self.tweet.retweetCount = self.tweet.retweetCount/1000;
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%.1fK", self.tweet.retweetCount];
    } else if (self.tweet.retweetCount > 999999) {
        self.tweet.retweetCount = self.tweet.retweetCount/1000;
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%.1fM", self.tweet.retweetCount];
    } else {
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", (int) self.tweet.retweetCount];
    }
    [self.retweetCountLabel sizeToFit];
}
- (void)setProfileImageViewImage {
    self.profileImage.image = nil;
    [self.profileImage setImageWithURL:self.tweet.user.profileURL];
    self.profileImage.layer.cornerRadius = 24.0f;
    self.profileImage.clipsToBounds = YES;
}
- (void)setFavIconImage {
    if (self.tweet.favorited) {
        [self.favIcon.imageView setImage:[UIImage imageNamed:@"favor-icon-red"]];
    } else {
        [self.favIcon.imageView setImage:[UIImage imageNamed:@"favor-icon"]];
    }
}
- (void)setRetweetIconImage {
    if(self.tweet.retweeted) {
        [self.retweetIcon.imageView setImage:[UIImage imageNamed:@"retweet-icon-green"]];
    } else {
        [self.retweetIcon.imageView setImage:[UIImage imageNamed:@"retweer-icon"]];
    }
}
- (void)favPostCall {
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
}
- (void)unFavPostCall {
    [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
        }
    }];
}

- (void)retweetPostCall {
    [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
        }
    }];
}

- (void)unretweetPostCall {
    [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
        }
    }];
}


@end
