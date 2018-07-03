//
//  TimelineViewController.m
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/2/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ComposeViewController.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *homeFeedTableView;
@property (strong, nonatomic) NSMutableArray *tweetsList;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TableView info sources
    self.homeFeedTableView.delegate = self;
    self.homeFeedTableView.dataSource = self;
    
    // tweetsList that's used to populate cells
    self.tweetsList = [[NSMutableArray alloc] init];
    
    // Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.homeFeedTableView insertSubview:refreshControl atIndex:0];
    
    // Get timeline
    [self getTimeline:refreshControl];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TweetCell *cell = [self.homeFeedTableView dequeueReusableCellWithIdentifier:@"tweetCell" forIndexPath:indexPath];
    cell.tweet = self.tweetsList[indexPath.row];
    [cell setTweet];
    NSLog(@"%@", cell.favCountLabel.text);
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetsList.count;
}

- (IBAction)replyButtonTapped:(id)sender {
    NSLog(@"reply Button tapped");
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getTimeline:refreshControl];
}

-(void) getTimeline:(UIRefreshControl*) refreshControl {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            self.tweetsList = tweets;
            [self.homeFeedTableView reloadData];
            if (refreshControl != nil) {
                [refreshControl endRefreshing];
            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)didTweet:(Tweet *)tweet {
    [self getTimeline:nil];
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     UINavigationController *navigationController = [segue destinationViewController];
     ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
     composeController.delegate = self;
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
