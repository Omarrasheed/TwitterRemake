//
//  ComposeViewController.m
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/3/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *createTweetTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)tweetButtonPressed:(id)sender {
    if (![self.createTweetTextView.text  isEqual: @""]){
        [self postTweet:self.createTweetTextView.text];
    }
}

- (void) postTweet:(NSString *)text {
    [[APIManager shared]postStatusWithText:@"This is my tweet 😀" completion:^(Tweet *tweet, NSError *error){
        if (error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        } else {
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
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
