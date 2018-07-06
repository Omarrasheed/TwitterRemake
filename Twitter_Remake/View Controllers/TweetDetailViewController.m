//
//  TweetDetailViewController.m
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/3/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileViewController.h"
#import "APIManager.h"

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
    
//    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
//    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizer];
//    [self.profileImageView setUserInteractionEnabled:YES];
}
- (IBAction)likeButtonPressed:(id)sender {
    if (self.tweet.favorited) {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        [self unFavPostCall];
    } else {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        [self favPostCall];
    }
    [self setTweetDetailView];
}
- (IBAction)retweetButtonPressed:(id)sender {
    if (self.tweet.retweeted) {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        [self unretweetPostCall];
    } else {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        [self retweetPostCall];
    }
    [self setTweetDetailView];
}
- (IBAction)replyButtonPressed:(id)sender {
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self performSegueWithIdentifier:@"profileSegue" sender:self.tweet.user];
}

- (void)setTweetDetailView {
    [self setUserNameLabelText];
    [self setHandleLabelText];
    [self setTweetContentLabelText];
    [self setDateTimeLabelText];
    [self setRetweetsLabelText];
    [self setLikeLabelText];
    [self setProfileImage];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ProfileViewController *profileViewController = [segue destinationViewController];
    profileViewController.user = self.tweet.user;
}

@end
