//
//  TPXDetailViewController.m
//  StreetsSFLocations
//
//  Created by pixelhacker on 2/1/14.
//  Copyright (c) 2014 tinypixel. All rights reserved.
//

#import "TPXDetailViewController.h"

@interface TPXDetailViewController ()

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *episodeTitle;
@property (strong, nonatomic) IBOutlet UILabel *timeCodeLbl;
@property (strong, nonatomic) IBOutlet UILabel *addressLbl;
@property (strong, nonatomic) IBOutlet UITextView *infoTxt;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *headerTitle;

@end

@implementation TPXDetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:213/255.0 alpha:1.0];

    self.headerTitle.text = @"Location";
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.episodeTitle.text = self.detailDictionary[kTPXDetailHeader];
    self.timeCodeLbl.text = self.detailDictionary[kTPXDetailTimeCode];
    self.addressLbl.text = self.detailDictionary[kTPXDetailAddress];
    self.infoTxt.text = self.detailDictionary[kTPXDetailExtraInfo];
    
    if([self.detailDictionary[kTPXDetailDefImage] isEqualToString:@"YES"]){
        self.imageView.image = [UIImage imageNamed:@"placeHolder.jpg"];
    } else {
        PFFile *imageFile = self.detailDictionary[kTPXDetailImage];
        self.imageView.file = imageFile;
        [self.imageView loadInBackground];
    }
    

//    PFFile *imageFile = self.detailDictionary[kTPXDetailImage];
//    self.imageView.file = imageFile;
//    [self.imageView loadInBackground];
    
    [self addShadowForView:(self.contentView)];
    
    // Adjust position and height of content view for smaller iphones
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if(height < 568.0){
        CGRect frame = self.contentView.frame;
        frame.size.height = 242;
        frame.origin.y = 220;
        self.contentView.frame = frame;
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)addShadowForView:(UIView *)view{
    view.layer.masksToBounds = NO;
    view.layer.cornerRadius = 4;
    view.layer.shadowRadius = 1;
    view.layer.shadowOffset = CGSizeMake(0, 1);
    view.layer.shadowOpacity = 0.25;
    
}

- (IBAction)closeBtnPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end