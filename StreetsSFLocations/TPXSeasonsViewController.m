//
//  TPXSeasonsViewController.m
//  StreetsSFLocations
//
//  Created by pixelhacker on 2/1/14.
//  Copyright (c) 2014 tinypixel. All rights reserved.
//

#import "TPXSeasonsViewController.h"
#import "TPXEpisodeViewController.h"
#import "MBProgressHUD.h"
#import "MSCellAccessory.h"

@interface TPXSeasonsViewController ()
@property (strong, nonatomic) NSMutableArray *seasonsArray;
@property (nonatomic) CGFloat adjustedCellHeight;
@end

@implementation TPXSeasonsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    self.adjustedCellHeight = 101.0;
    
    if(height < 568.0){
        self.adjustedCellHeight = 84.0;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor colorWithRed:251/255.0 green:252/255.0 blue:236/255.0 alpha:1.0];
    self.tableView.backgroundView  = nil;
    self.tableView.scrollEnabled = NO;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Retrieving Data";
    [hud show:YES];
    
    PFQuery *seasonListQuery = [PFQuery queryWithClassName:@"Seasons"];
    seasonListQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [seasonListQuery orderByAscending:@"seasonDates"];
    [seasonListQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.seasonsArray = [objects mutableCopy];
            [self.tableView reloadData];
        }
        [hud hide:YES];
    }];
  
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:64/255.0 green:77/255.0 blue:87/255.0 alpha:1.0]}];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"seasonToEpisodesSegue"]){
        TPXEpisodeViewController *episodesVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        episodesVC.hasFullContent = self.seasonsArray[indexPath.row][@"hasFullContent"];
        switch(indexPath.row){
            case 0:
                episodesVC.seasonNumber = kTPXSeasonOneKey;
                break;
                
            case 1:
                episodesVC.seasonNumber = kTPXSeasonTwoKey;
                break;
                
            case 2:
                episodesVC.seasonNumber = kTPXSeasonThreeKey;
                break;
                
            case 3:
                episodesVC.seasonNumber = kTPXSeasonFourKey;
                break;
                
            case 4:
                episodesVC.seasonNumber = kTPXSeasonFiveKey;
                break;
        }
    }
}

#pragma mark - UITableView DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SeasonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:64/255.0 green:77/255.0 blue:87/255.0 alpha:1.0];
    cell.textLabel.text = self.seasonsArray[indexPath.row][kTPXSeasonNameKey];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:32.0];
    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:64/255.0 green:77/255.0 blue:87/255.0 alpha:1.0];
    cell.detailTextLabel.text = self.seasonsArray[indexPath.row][kTPXSeasonDatesKey];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
    
    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor colorWithRed:64/255.0 green:77/255.0 blue:87/255.0 alpha:1.0], [UIColor colorWithWhite:0.5 alpha:1.0]]];

    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:255/255.0 green:131/255.0 blue:85/255.0 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.seasonsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.adjustedCellHeight;
}

@end
