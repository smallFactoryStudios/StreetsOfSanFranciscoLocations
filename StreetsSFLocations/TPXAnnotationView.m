//
//  TPXAnnotationView.m
//  StreetsSFLocations
//
//  Created by pixelhacker on 2/6/14.
//  Copyright (c) 2014 tinypixel. All rights reserved.
//

#import "TPXAnnotationView.h"
#import "TPXAnnotation.h"

@implementation TPXAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [UIImage imageNamed:@"ios7Marker.png"];
    }
    
    return self;
}
@end
