//
//  ComposeViewController.m
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/3/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *createTweetTextView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.createTweetTextView.delegate = self;
    self.createTweetTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.createTweetTextView.layer.borderWidth = 1;
    self.createTweetTextView.layer.cornerRadius = 12;
    
    [self setupProfilePicture];
    
}

- (void)setupProfilePicture {
    if (self.user.profileURL != nil) {
        [self.profileImage setImageWithURL:self.user.profileURL];
        [self.profileImage sizeToFit];
        self.profileImage.layer.cornerRadius = 24;
        self.profileImage.clipsToBounds = YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    
    if ([textView.text length] > 140) {
        [textView setTextColor:[UIColor redColor]];
        [self.characterCountLabel setTextColor:[UIColor redColor]];
    } else {
        [textView setTextColor:[UIColor blackColor]];
        [self.characterCountLabel setTextColor:[UIColor blackColor]];
    }
    self.characterCountLabel.text = [NSString  stringWithFormat:@"%lu", [textView.text length]];
}


- (IBAction)closeButtonPressed:(id)sender {
    if (![self.createTweetTextView.text isEqual:@""]) {
        [self saveDraftPopup:@"Would you like to save your draft?"];
    } else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (IBAction)tweetButtonPressed:(id)sender {
    if (![self.createTweetTextView.text  isEqual: @""]) {
        if ([self.createTweetTextView.text length]<141) {
            [self postTweet:self.createTweetTextView.text];
        } else {
            [self presentErrorPopup:@"Too many Characters"];
        }
    } else {
        [self presentErrorPopup:@"Can't post an empty tweet"];
    }
}

- (void) postTweet:(NSString *)text {
    [[APIManager shared]postStatusWithText:text completion:^(Tweet *tweet, NSError *error){
        if (error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        } else {
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (void) presentErrorPopup:(NSString *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    // handle cancel response here. Doing nothing will dismiss the view.
    }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
    // optional code for what happens after the alert controller has finished presenting
    }];
}

- (void) saveDraftPopup:(NSString *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Draft" message:error preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    // add the cancel action to the alertController
    [alert addAction:noAction];
    
    // create an OK action
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    // add the OK action to the alert controller
    [alert addAction:yesAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
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
