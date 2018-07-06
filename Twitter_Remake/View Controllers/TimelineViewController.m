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
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetDetailViewController.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *homeFeedTableView;
@property (strong, nonatomic) NSMutableArray *tweetsList;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property NSInteger maxId;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TableView info sources
    self.homeFeedTableView.delegate = self;
    self.homeFeedTableView.dataSource = self;
    self.homeFeedTableView.rowHeight = UITableViewAutomaticDimension;
    self.homeFeedTableView.estimatedRowHeight = 140;
    
    // tweetsList that's used to populate cells
    self.tweetsList = [[NSMutableArray alloc] init];
    
    // Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.homeFeedTableView insertSubview:self.refreshControl atIndex:0];
    
    // Get timeline
    [self getTimeline];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TweetCell *cell = [self.homeFeedTableView dequeueReusableCellWithIdentifier:@"tweetCell" forIndexPath:indexPath];
    cell.tweet = self.tweetsList[indexPath.row];
    [cell setTweet];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetsList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.homeFeedTableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.homeFeedTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.homeFeedTableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.homeFeedTableView.isDragging) {
            self.isMoreDataLoading = true;
            [self setMaxIdValue];
            [self getMoreTweets];
        }
    }
}

- (IBAction)replyButtonTapped:(id)sender {
    
}


- (IBAction)logoutButtonPressed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getTimeline];
}

-(void) getTimeline{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweetsList = [NSMutableArray arrayWithArray:tweets];
            [self.homeFeedTableView reloadData];
            if (self.refreshControl != nil) {
                [self.refreshControl endRefreshing];
            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void) getMoreTweets {
    [[APIManager shared] getMoreTimelineTweets:self.maxId completion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            for (Tweet* eachTweet in tweets) {
                [self.tweetsList addObject:eachTweet];
            }
            [self.homeFeedTableView reloadData];
            if (self.refreshControl != nil) {
                [self.refreshControl endRefreshing];
            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)didTweet:(Tweet *)tweet {
    [self getTimeline];
}

- (void)setMaxIdValue {
    if (!(self.maxId)) {
        Tweet *tweet = self.tweetsList[0];
        self.maxId = [tweet.idStr integerValue];
        [self setMaxIdValue];
    } else {
        for (Tweet *each in self.tweetsList) {
            if ([each.idStr integerValue] < self.maxId) {
                self.maxId = [each.idStr integerValue];
            }
        }
        NSLog(@"%ld", self.maxId);
    }
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([sender isKindOfClass:[TweetCell class]]) {
         TweetCell *tappedCell = sender;
         NSLog(@"hit the segue func");
         TweetDetailViewController *tweetDetailViewController = [segue destinationViewController];
         tweetDetailViewController.tweet = tappedCell.tweet;
     } else if ([sender isKindOfClass:[UIButton class]]){
         UIButton *button = (UIButton *)sender;
         if ([button.imageView.image isEqual:[UIImage imageNamed:@"edit-icon"]]) {
             UINavigationController *navigationController = [segue destinationViewController];
             ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
             composeController.delegate = self;
         }
         
     }
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
