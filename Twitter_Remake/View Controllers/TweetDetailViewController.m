//
//  TweetDetailViewController.m
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/3/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;


@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTweetDetailView];
}

- (void)setTweetDetailView {
    [self setUserNameLabelText];
    [self setHandleLabelText];
    [self setTweetContentLabelText];
    [self setDateTimeLabelText];
    [self setRetweetsLabelText];
    [self setLikeLabelText];
    [self setProfileImage];
    NSLog(@"done");
}

- (void)setProfileImage {
    [self.profileImageView setImageWithURL:self.tweet.user.profileURL];
}

- (void)setUserNameLabelText {
    self.userNameLabel.text = self.tweet.user.name;
    [self.userNameLabel sizeToFit];
}

- (void)setHandleLabelText {
    self.handleLabel.text = self.tweet.user.screenName;
    [self.handleLabel sizeToFit];
}

- (void)setTweetContentLabelText {
    self.tweetContentLabel.text = self.tweet.text;
    [self.tweetContentLabel sizeToFit];
}

- (void)setDateTimeLabelText {
    self.dateTimeLabel.text = self.tweet.createdAtString;
    [self.dateTimeLabel sizeToFit];
}

- (void)setRetweetsLabelText {
    self.retweetsLabel.text = [NSString stringWithFormat:@"%d retweets", (int)self.tweet.retweetCount];
    [self.retweetsLabel sizeToFit];
}

- (void)setLikeLabelText {
    self.likesLabel.text = [NSString stringWithFormat:@"%d likes", (int)self.tweet.favoriteCount];
    [self.likesLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
