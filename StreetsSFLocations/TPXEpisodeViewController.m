//
//  TPXEpisodeViewController.m
//  StreetsSFLocations
//
//  Created by pixelhacker on 2/1/14.
//  Copyright (c) 2014 tinypixel. All rights reserved.
//

#import "TPXEpisodeViewController.h"
#import "TPXMapViewController.h"
#import "MBProgressHUD.h"
#import "MSCellAccessory.h"

@interface TPXEpisodeViewController ()

@property (strong, nonatomic) NSMutableArray *episodes;

@end

@implementation TPXEpisodeViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor colorWithRed:251/255.0 green:252/255.0 blue:236/255.0 alpha:1.0];
    self.tableView.backgroundView = nil;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Retrieving Data";
    [hud show:YES];
    
    PFQuery *episodeListQuery = [PFQuery queryWithClassName:self.seasonNumber];
    episodeListQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [episodeListQuery orderByAscending:kTPXEpisodeNumberKey];
    [episodeListQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.episodes = [objects mutableCopy];
            [self.tableView reloadData];
        }
        [hud hide:YES];
    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"episodeToMapSegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        NSDictionary *episodeInfo = @{@"episodeTitle" : self.episodes[indexPath.row][kTPXEpisodeNameKey],
                                      @"episodeNumber" : self.episodes[indexPath.row][kTPXEpisodeNumberKey],
                                      @"episodeID" : [self.episodes[indexPath.row] objectId],
                                      @"seasonNumber" : self.seasonNumber,
                                      @"synopsis" : self.episodes[indexPath.row][@"EpisodeSynopsis"]
                                      };
        
        TPXMapViewController *mapVC = segue.destinationViewController;
        mapVC.episodeDict = episodeInfo;
    }
}


#pragma mark - UITableView DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *episodeTitle;
    if(indexPath.row == 0 && [self.seasonNumber isEqualToString:kTPXSeasonOneKey]){
        episodeTitle = [NSString stringWithFormat:@"Pilot : %@", self.episodes[indexPath.row][kTPXEpisodeNameKey]];
    } else {
        episodeTitle = [NSString stringWithFormat:@"Ep %@ : %@", self.episodes[indexPath.row][kTPXEpisodeNumberKey], self.episodes[indexPath.row][kTPXEpisodeNameKey]];
    }
    
    static NSString *CellIdentifier = @"EpisodeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:64/255.0 green:77/255.0 blue:87/255.0 alpha:1.0];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
    cell.textLabel.text = episodeTitle;
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:self.episodes[indexPath.row][kTPXEpisodeAirDateKey]];
    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:64/255.0 green:77/255.0 blue:87/255.0 alpha:1.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Air Date : %@", stringFromDate];
    
    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor colorWithRed:64/255.0 green:77/255.0 blue:87/255.0 alpha:1.0], [UIColor colorWithWhite:0.5 alpha:1.0]]];
    
    UIView *bgColorView = [[UIView alloc] init];
    //bgColorView.backgroundColor = [UIColor colorWithRed:38/255.0 green:186/255.0 blue:158/255.0 alpha:1.0];
    bgColorView.backgroundColor = [UIColor colorWithRed:255/255.0 green:131/255.0 blue:85/255.0 alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    if([self.hasFullContent isEqualToString:@"NO"]){
        cell.userInteractionEnabled = NO;
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR colors:@[[UIColor colorWithRed:64/255.0 green:1/255.0 blue:1/255.0 alpha:0.0], [UIColor colorWithWhite:0.5 alpha:1.0]]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.episodes count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}



@end
