//
//  ProfileViewController.h
//  Twitter_Remake
//
//  Created by Omar Rasheed on 7/5/18.
//  Copyright © 2018 Omar Rasheed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSArray *usersTweets;

@end
