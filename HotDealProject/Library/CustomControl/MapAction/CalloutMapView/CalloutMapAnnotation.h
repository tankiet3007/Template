#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CalloutMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
    NSString * strDescription;
    NSString * strTitle;
    NSString * strLogo;
    NSString * strPOI;
}
@property (nonatomic, retain) NSString * strDescription;
@property (nonatomic, retain) NSString * strTitle;
@property (nonatomic, retain) NSString * strLogo;
@property (nonatomic, retain) NSString * strPOI;

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;

@end
