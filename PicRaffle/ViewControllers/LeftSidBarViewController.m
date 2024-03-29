//
//  LeftSidBarViewController.m
//  PicRaffle
//
//  Created by jessy hansen on 2017-09-28.
//  Copyright © 2017 rubby star. All rights reserved.
//

#import "LeftSidBarViewController.h"
#import "MyAccountViewController.h"
#import "MyTicketsViewController.h"
#import "Global.h"
#import "UIImageView+WebCache.h"

@interface LeftSidBarViewController ()

@property NSDictionary *user_info;

@end

@implementation LeftSidBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLogoutNotification:) name:@"userinfochanged" object:nil];
    
    [self setProfilePhoto];
   
}

- (void) setProfilePhoto{
    self.user_info = [[Global globalManager] getUserInfo];
    
    self.user_name_tv.text = [self.user_info objectForKey:@"name"];
    
    NSString *finalURL = [NSString stringWithFormat:ACCOUNT_IMAGE_FOLDER];
    
    if([self.user_info objectForKey:@"account_image_name"])
    {
        NSString *temp =[self.user_info objectForKey:@"account_image_name"];
        if(temp == (NSString*)[NSNull null])
        {
            finalURL = [finalURL stringByAppendingString: @"no_image.png"];
        }
        else{
            finalURL = [finalURL stringByAppendingString: [self.user_info objectForKey:@"account_image_name"]];
        }
        
    }else{
        
        finalURL = [finalURL stringByAppendingString: @"no_image.png"];
    }
    NSURL *url = [NSURL URLWithString:finalURL];
    
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.center = self.iv_profile.center;
    activityIndicator.hidesWhenStopped = YES;
    [self.iv_profile addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    //[imageView setImage:[UIImage imageWithData:image_data]];
    [self.iv_profile sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error == nil) {
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        } else {
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        }
    }];
}

- (void) receiveLogoutNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"userinfochanged"])
        [self setProfilePhoto];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidAppear:(BOOL)animated{
  self.iv_profile.layer.cornerRadius = self.iv_profile.layer.frame.size.width / 2;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)actionMyAccountBTN:(id)sender {
   
    [self.superViewController.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
    MyAccountViewController *maVC = (MyAccountViewController *) [self.superViewController.storyboard instantiateViewControllerWithIdentifier:@"myaccount_stb"];
    maVC.superViewController = self.superViewController;
    [self.superViewController presentViewController:maVC animated:YES completion:nil];
}

- (IBAction)actionImageBTN:(id)sender {
    [self.superViewController showProfileView];
    [self.superViewController.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
}
- (IBAction)actionMyTicketsBTN:(id)sender {
    [self.superViewController.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
    MyTicketsViewController *mtVC = (MyTicketsViewController *) [self.superViewController.storyboard instantiateViewControllerWithIdentifier:@"mytickets_stb"];
    mtVC.superViewController = self.superViewController;
    [self.superViewController presentViewController:mtVC animated:YES completion:nil];
}


- (IBAction)actionLogoutBTN:(id)sender {
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:self];
    [self.superViewController.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
