//
//  ProfileViewController.m
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/5/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "ProfileViewController.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *FollowerCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTweetsTableView;
@property (weak, nonatomic) IBOutlet UIButton *myTweetsButton;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTweetsTableView.delegate = self;
    self.myTweetsTableView.dataSource = self;
    [self setupBackButton];
    [self setupPosterView];
    [self setupProfilePicture];
    [self setupUsernameLabel];
    [self setupHandleLabel];
    [self setupFollowerCountLabel];
    [self setupFollowingCountLabel];
    [self setupTweetsCountLabel];
    self.myTweetsButton.selected = YES;
    
    [[APIManager shared] getSpecifiedUserInfo:self.user completion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            self.usersTweets = tweets;
            [self.myTweetsTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)setupPosterView {
    if (self.user.profileBackgroundURL) {
        [self.posterView setImageWithURL:self.user.profileBackgroundURL];
        [self.posterView sizeToFit];
    }
}

- (void)setupProfilePicture {
    if (self.user.profileURL != nil) {
        [self.profilePicture setImageWithURL:self.user.profileURL];
        [self.profilePicture sizeToFit];
        self.profilePicture.layer.cornerRadius = 42;
        self.profilePicture.clipsToBounds = YES;
    }
}

- (void)setupUsernameLabel {
    self.usernameLabel.text = self.user.name;
    [self.usernameLabel sizeToFit];
}

- (void)setupHandleLabel {
    self.handleLabel.text = self.user.screenName;
    [self.handleLabel sizeToFit];
}

- (void)setupFollowingCountLabel {
    self.followingCountLabel.text = [NSString stringWithFormat:@"%@ Followers", self.user.followerCount];
    [self.followingCountLabel sizeToFit];
}

- (void)setupFollowerCountLabel {
    self.FollowerCountLabel.text = [NSString stringWithFormat:@"%@ Following", self.user.followingCount];
    [self.FollowerCountLabel sizeToFit];
}

- (void)setupTweetsCountLabel {
    self.tweetCountLabel.text = [NSString stringWithFormat:@"%@ Tweets", self.user.tweetsCount];
    [self.tweetCountLabel sizeToFit];
}

- (IBAction)didTap:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.myTweetsTableView dequeueReusableCellWithIdentifier:@"tweetCell2" forIndexPath:indexPath];

    cell.tweet = self.usersTweets[indexPath.row];
    cell.delegate = self;
    [cell setTweet];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.usersTweets.count;
}
- (void)setupBackButton {
    self.backButton.layer.cornerRadius = 15;
    self.backButton.clipsToBounds = YES;
}

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user {
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
