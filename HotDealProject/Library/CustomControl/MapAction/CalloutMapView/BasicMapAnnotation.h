#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BasicMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
	NSString *_title;
    NSString * _icon;
    NSString * _logo;
    NSString * _content;
}

@property (nonatomic, retain) NSString *_title;
@property (nonatomic) CLLocationDegrees _latitude;
@property (nonatomic) CLLocationDegrees _longitude;
@property (nonatomic, retain) NSString *_icon;
@property (nonatomic, retain) NSString *_logo;
@property (nonatomic, retain) NSString *_content;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
