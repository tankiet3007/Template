#import "BasicMapAnnotation.h"

@interface BasicMapAnnotation()

@end

@implementation BasicMapAnnotation

@synthesize _latitude = _latitude;
@synthesize _longitude = _longitude;
@synthesize _title = _title;
@synthesize _icon = _icon;
@synthesize _logo = _logo;
@synthesize _content = _content;
- (id)initWithLatitude:(CLLocationDegrees)clatitude
		  andLongitude:(CLLocationDegrees)clongitude {
	if (self = [super init]) {
		self._latitude = clatitude;
		self._longitude = clongitude;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self._latitude;
	coordinate.longitude = self._longitude;
	return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	self._latitude = newCoordinate.latitude;
	self._longitude = newCoordinate.longitude;
}


@end
