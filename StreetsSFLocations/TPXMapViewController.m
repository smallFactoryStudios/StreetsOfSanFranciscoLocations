//
//  TPXMapViewController.m
//  StreetsSFLocations
//
//  Created by pixelhacker on 2/1/14.
//  Copyright (c) 2014 tinypixel. All rights reserved.
//

#import "TPXMapViewController.h"
#import "TPXAnnotation.h"
#import "TPXAnnotationView.h"
#import "TPXDetailViewController.h"
#import "MSCellAccessory.h"

#define METERS_PER_MILE 1609.3440

@interface TPXMapViewController ()

@property (strong, nonatomic) NSMutableArray *pinsArray;
@property (strong, nonatomic) UIButton *rightButton;
@property (nonatomic) int pinIndex;

@end

@implementation TPXMapViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CLLocationCoordinate2D startCood;
    startCood.latitude = 37.76225;
    startCood.longitude = -122.439463;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(startCood, 9700, 9700);
    [self.mapView setRegion:viewRegion animated:YES];
    self.mapView.delegate = self;
    
    PFQuery *episodeLocationsQuery;
    
    NSString *seasonString = self.episodeDict[@"seasonNumber"];
    if([seasonString isEqualToString:@"Season_1"]){
        episodeLocationsQuery = [PFQuery queryWithClassName:kTPXLocationsKey1];
    } else if([seasonString isEqualToString:@"Season_2"]){
        episodeLocationsQuery = [PFQuery queryWithClassName:kTPXLocationsKey2];
    } else if([seasonString isEqualToString:@"Season_3"]){
        episodeLocationsQuery = [PFQuery queryWithClassName:kTPXLocationsKey3];
    } else if([seasonString isEqualToString:@"Season_4"]){
        episodeLocationsQuery = [PFQuery queryWithClassName:kTPXLocationsKey4];
    } else if([seasonString isEqualToString:@"Season_5"]){
        episodeLocationsQuery = [PFQuery queryWithClassName:kTPXLocationsKey5];
    }
    
    
    
    [episodeLocationsQuery whereKey:@"fromEpisode" equalTo:[PFObject objectWithoutDataWithClassName:self.episodeDict[@"seasonNumber"] objectId:self.episodeDict[@"episodeID"]]];
    
    episodeLocationsQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
    [episodeLocationsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            self.pinsArray = [objects mutableCopy];
        }
        [self grabPoints];
        
    }];
}

-(void)grabPoints{
    //Loops thru pinsArray length grabs geoPoint
    //creates annotation with indexed title/subtext
    //assigns pinIndex & adds annotation to map
    for(int i=0;i < [self.pinsArray count];i++){
        PFGeoPoint *geoPoint = self.pinsArray[i][@"LongLat"];
        CLLocationCoordinate2D tempCood;
        
        tempCood.latitude = geoPoint.latitude;
        tempCood.longitude = geoPoint.longitude;
        
        TPXAnnotation *annotation = [[TPXAnnotation alloc] initWithCoordinate:tempCood andTitle:self.pinsArray[i][@"Description"] andSubTitle:self.pinsArray[i][@"Subtext"]];
        
        annotation.pinIndex = i;
        
        [self.mapView addAnnotation:annotation];
    }
    
    [self zoomToFitMapAnnotations:self.mapView];
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.5   ;
    
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *identifier = @"TPXAnnotation";
    MKPinAnnotationView * annotationView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!annotationView){
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.animatesDrop = NO;
        annotationView.canShowCallout = YES;
        
    }else {
        annotationView.annotation = annotation;
    }
    annotationView.image = [UIImage imageNamed:@"ios7Marker.png"];
    annotationView.canShowCallout = YES;
    //WORKS
    //annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
    //
    
    CGRect frameBtn = CGRectMake(0.0f, 0.0f, 22.0f, 22.0f);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"calloutInfoBtn.png"] forState:UIControlStateNormal];
    [button setFrame:frameBtn];
    annotationView.rightCalloutAccessoryView = button;
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    TPXAnnotation *ann = (TPXAnnotation *)view.annotation;
    self.pinIndex = ann.pinIndex;
    [self performSegueWithIdentifier:@"calloutToDetailView" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSDictionary *pinsDict = @{kTPXDetailImage : self.pinsArray[self.pinIndex][@"image"] ? self.pinsArray[self.pinIndex][@"image"] : @"placeHolder.jpg",
                               kTPXDetailHeader : self.episodeDict[@"episodeTitle"],
                               kTPXDetailTimeCode : self.pinsArray[self.pinIndex][@"TimeCode"] ? self.pinsArray[self.pinIndex][@"TimeCode"] : @"",
                               kTPXDetailAddress : self.pinsArray[self.pinIndex][@"Subtext"] ? self.pinsArray[self.pinIndex][@"Subtext"] : @"",
                               kTPXDetailExtraInfo : self.pinsArray[self.pinIndex][@"fullText"] ? self.pinsArray[self.pinIndex][@"fullText"] : @"",
                               kTPXDetailDefImage : self.pinsArray[self.pinIndex][@"useDefaultImage"]
                               };
    
    if([segue.identifier isEqualToString:@"calloutToDetailView"]){
        TPXDetailViewController *detailVC = segue.destinationViewController;
        detailVC.detailDictionary = pinsDict;
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end