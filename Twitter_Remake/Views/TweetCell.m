//
//  TweetCell.m
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/2/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageview+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

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
    [self setDateTimeLabelText];
    [self setTweetContentLabelText];
    [self setReplyCountLabelText];
    [self setFavCountLabelText];
    [self setRetweetCountLabelText];
    [self setProfileImageViewImage];
}

-(void)setUsernameLabelText {
    self.usernameLabel.text = self.tweet.user.screenName;
    [self.usernameLabel sizeToFit];
}
-(void)setDateTimeLabelText {
    self.dateTimeLabel.text = self.tweet.createdAtString;
    [self.dateTimeLabel sizeToFit];
}
-(void)setTweetContentLabelText {
    self.tweetContentLabel.text = self.tweet.text;
    [self.tweetContentLabel sizeToFit];
}
-(void)setReplyCountLabelText {
    self.replyCountLabel.text = [@(self.tweet.retweetCount) stringValue];
    [self.replyCountLabel sizeToFit];
}
-(void)setFavCountLabelText {
    self.favCountLabel.text = [@(self.tweet.favoriteCount) stringValue];
    [self.favCountLabel sizeToFit];
}
-(void)setRetweetCountLabelText {
    self.retweetCountLabel.text = [@(self.tweet.retweetCount) stringValue];
    [self.retweetCountLabel sizeToFit];
}
-(void)setProfileImageViewImage {
    self.profileImage.image = nil;
    [self.profileImage setImageWithURL:self.tweet.user.profileURL];
    self.profileImage.layer.cornerRadius = 32.0f;
    self.profileImage.clipsToBounds = YES;
}

@end
