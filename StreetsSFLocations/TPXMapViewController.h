//
//  TPXMapViewController.h
//  StreetsSFLocations
//
//  Created by pixelhacker on 2/1/14.
//  Copyright (c) 2014 tinypixel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TPXMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) NSDictionary *episodeDict;

#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
