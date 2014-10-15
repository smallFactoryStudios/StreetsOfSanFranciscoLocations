//
//  TPXAnnotations.h
//  StreetsSFLocations
//
//  Created by pixelhacker on 2/1/14.
//  Copyright (c) 2014 tinypixel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TPXAnnotation : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSDictionary *dict;
@property (nonatomic) int pinIndex;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

//-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title andSubTitle:(NSString *)subtitle andDictionaryElements:(NSDictionary *)locationDict;
-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title andSubTitle:(NSString *)subtitle;

@end
