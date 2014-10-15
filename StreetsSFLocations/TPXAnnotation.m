//
//  TPXAnnotations.m
//  StreetsSFLocations
//
//  Created by pixelhacker on 2/1/14.
//  Copyright (c) 2014 tinypixel. All rights reserved.
//

#import "TPXAnnotation.h"

@implementation TPXAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title andSubTitle:(NSString *)subtitle{
    if ((self = [super init])) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
    }
    
    return self;
}


@end
