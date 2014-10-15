//
//  TPXEpisodeViewController.h
//  StreetsSFLocations
//
//  Created by pixelhacker on 2/1/14.
//  Copyright (c) 2014 tinypixel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPXEpisodeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *seasonNumber;
@property (nonatomic) NSString *hasFullContent;

@end
