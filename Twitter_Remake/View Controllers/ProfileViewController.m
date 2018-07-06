//
//  ProfileViewController.m
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/5/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "ProfileViewController.h"
#import "TweetCell.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *FollowerCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTweetsTableView;
@property (weak, nonatomic) IBOutlet UIButton *timelineButton;
@property (weak, nonatomic) IBOutlet UIButton *myTweetsButton;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBackButton];
    self.timelineButton.selected = YES;
    
}
- (IBAction)didTap:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.myTweetsTableView dequeueReusableCellWithIdentifier:@"tweetCell" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (void)setupBackButton {
    self.backButton.layer.cornerRadius = 15;
    self.backButton.clipsToBounds = YES;
    
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
