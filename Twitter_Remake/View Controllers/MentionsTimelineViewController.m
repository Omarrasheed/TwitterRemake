//
//  MentionsTimelineViewController.m
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/6/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "MentionsTimelineViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "ProfileViewController.h"
#import "APIManager.h"
#import "TweetDetailViewController.h"

@interface MentionsTimelineViewController ()<UITableViewDelegate, UITableViewDataSource, TweetCellDelegate>

@property (strong, nonatomic) NSArray *mentionsTweets;
@property (weak, nonatomic) IBOutlet UITableView *mentionsTableView;

@end

@implementation MentionsTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mentionsTableView.delegate = self;
    self.mentionsTableView.dataSource = self;
    self.mentionsTableView.rowHeight = UITableViewAutomaticDimension;
    self.mentionsTableView.estimatedRowHeight = 140;
    // Get Mentions
    [self getMentions];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [self.mentionsTableView dequeueReusableCellWithIdentifier:@"mentionTweet" forIndexPath:indexPath];
    cell.tweet = self.mentionsTweets[indexPath.row];
    cell.delegate = self;
    [cell setTweet];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mentionsTweets.count;
}

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user {
    [self performSegueWithIdentifier:@"profileSegFromMentions" sender:user];
}

- (void)getMentions {
    [[APIManager shared] getMentionsTimelineTweets:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.mentionsTweets = tweets;
            [self.mentionsTableView reloadData];
        }
    }];
}

- (void)tweetCell:(TweetCell *)tweetCell didTapTweet:(Tweet *)tweet{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[TweetCell class]]) {
        TweetCell *tappedCell = sender;
        TweetDetailViewController *tweetDetailViewController = [segue destinationViewController];
        tweetDetailViewController.tweet = tappedCell.tweet;
    } else if ([segue.destinationViewController  isKindOfClass:[ProfileViewController class]]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        if ([sender isKindOfClass:[User class]]){
            profileViewController.user = sender;
        } 
    }
}


@end
