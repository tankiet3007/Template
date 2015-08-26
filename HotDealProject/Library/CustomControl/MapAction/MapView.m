//
//  MapView.m
//  TemplateAndAction
//
//  Created by MAC on 5/29/14.
//  Copyright (c) 2014 MAC. All rights reserved.
//

#import "MapView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIButton+WebCache.h"
#import "INTULocationManager.h"

#import "HotNewDetailViewController.h"
#define spa 40000
@implementation MapView
{
    NSMutableArray *_annotationList;
    __block CLLocation *currLocation;
    CalloutMapAnnotation *_calloutAnnotation;
    CalloutMapAnnotation *_previousdAnnotation;
    
}
@synthesize zoomLevel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevels animated:(BOOL)animated {
//    MKCoordinateSpan spans = MKCoordinateSpanMake(0, 360/pow(2, 16)*self.frame.size.width/256);
                MKCoordinateSpan spans = MKCoordinateSpanMake(0,0.01);
    [_mapView setRegion:MKCoordinateRegionMake(centerCoordinate, spans) animated:animated];
    
}

- (void)initAnnotationList:(NSArray *)arrMapAnnotation
{
    _annotationList = [[NSMutableArray alloc] init];
    _annotationList = [NSMutableArray arrayWithArray:arrMapAnnotation];
    [self setAnnotionsWithList:_annotationList];
}

-(void)setAnnotionsWithList:(NSMutableArray *)list
{
    @try {
        for (BasicMapAnnotation *mapItem in list) {
            
            CLLocationDegrees latitude= mapItem._latitude;
            CLLocationDegrees longitude=mapItem._longitude;
            CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
            
            MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location,spa ,spa );
            MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:region];
            [_mapView setRegion:adjustedRegion animated:YES];
            
            //        BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
            //        annotation._title = [NSString stringWithFormat:@"Item No %f", longitude];
            [_mapView   addAnnotation:mapItem];
            //            [_mapView selectAnnotation:mapItem animated:YES];
        }
        //        [self zoomMapViewToFitAnnotationsWithExtraZoomToAdjust:12 withList:list];
    }
    @catch (NSException *exception) {
    }
}
- (void)startLocationRequest
{
    
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    NSInteger iResult = [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity
                                                           timeout:10
                                              delayUntilAuthorized:YES
                                                             block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                                                 
                                                                 if (status == INTULocationStatusSuccess) {
                                                                     // achievedAccuracy is at least the desired accuracy (potentially better)
                                                                     currLocation = currentLocation;
                                                                     [self zoomToCurrentLocation];
                                                                     UA_log(@"%@", [NSString stringWithFormat:@"Location request successful! Current Location:\n%@", currentLocation]);
                                                                 }
                                                                 else if (status == INTULocationStatusTimedOut) {
                                                                     // You may wish to inspect achievedAccuracy here to see if it is acceptable, if you plan to use currentLocation
                                                                     UA_log(@"%@", [NSString stringWithFormat:@"Location request timed out. Current Location:\n%@", currentLocation]);
                                                                 }
                                                             }];
    UA_log(@"%ld",(long)iResult);
}

- (void)zoomToCurrentLocation{
    [UIView animateWithDuration:1.5 animations:^{
        MKCoordinateSpan span;
        span.latitudeDelta  = 1;
        span.longitudeDelta = 1;
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = currLocation.coordinate;
        [self.mapView setRegion:region animated:YES];
        
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            [self setCenterCoordinate:currLocation.coordinate zoomLevel:15 animated:YES];
        }];
    }];
    //    MKCoordinateSpan span;
    //    span.latitudeDelta  = 1;
    //    span.longitudeDelta = 1;
    //
    //    MKCoordinateRegion region;
    //    region.span = span;
    //    region.center = currLocation.coordinate;
    //    [self.mapView setRegion:region animated:YES];
    
    //    [UIView animateWithDuration:1.5 animations:^{
    ////       /[self setCenterCoordinate:_calloutAnnotation.coordinate zoomLevel:15 animated:YES];
    //        [self setCenterCoordinate:currLocation.coordinate zoomLevel:15 animated:YES];
    //
    //    } completion:^(BOOL finished) {
    //        [UIView animateWithDuration:1.5 animations:^{
    //            MKCoordinateSpan span;
    //            span.latitudeDelta  = 1;
    //            span.longitudeDelta = 1;
    //
    //            MKCoordinateRegion region;
    //            region.span = span;
    //            region.center = currLocation.coordinate;
    //            [self.mapView setRegion:region animated:YES];
    //        }];
    //    }];
}
- (void)zoomMapViewToFitAnnotationsWithExtraZoomToAdjust:(double)extraZoom withList :(NSMutableArray *)list
{
    if ([list count] == 0) return;
    
    int i = 0;
    MKMapPoint points[[list count]];
    
    for (id<MKAnnotation> annotation in list)
    {
        points[i++] = MKMapPointForCoordinate(annotation.coordinate);
    }
    
    MKPolygon *poly = [MKPolygon polygonWithPoints:points count:i];
    
    MKCoordinateRegion r = MKCoordinateRegionForMapRect([poly boundingMapRect]);
    r.span.latitudeDelta += extraZoom;
    r.span.longitudeDelta += extraZoom;
    
    [_mapView setRegion: r animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[BasicMapAnnotation class]]) {
        @try {
            if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
                _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
                return;
            }
            if (_calloutAnnotation) {
                [mapView removeAnnotation:_calloutAnnotation];
                //            _calloutAnnotation = nil;
            }
            _calloutAnnotation = [[CalloutMapAnnotation alloc]
                                  initWithLatitude:view.annotation.coordinate.latitude
                                  andLongitude:view.annotation.coordinate.longitude];
            BasicMapAnnotation *  bsAnnotation = (BasicMapAnnotation *)view.annotation;
            _calloutAnnotation.strDescription = bsAnnotation._content;
            _calloutAnnotation.strTitle = bsAnnotation._title;
            _calloutAnnotation.strLogo = bsAnnotation._logo;
            _calloutAnnotation.strPOI = bsAnnotation._icon;
            _calloutAnnotation.strID = bsAnnotation.iID;
            [mapView addAnnotation:_calloutAnnotation];
            //        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];
            [self setCenterCoordinate:_calloutAnnotation.coordinate zoomLevel:15 animated:YES];
        }
        @catch (NSException *exception) {
            UA_log(@"%@", exception.description);
        }
    }
    else{
        @try {
            if([_delegate respondsToSelector:@selector(customMKMapViewDidSelectedWithInfo:)]){
                [_delegate customMKMapViewDidSelectedWithInfo:@"info"];
            }
        }
        @catch (NSException *exception) {
            UA_log(@"%@", exception.description);
        }
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    //    if (_calloutAnnotation&& ![view isKindOfClass:[CallOutAnnotationVifew class]]) {
    //        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
    //            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
    //            //            dispatch_async(dispatch_get_main_queue(), ^{
    //            @try {
    //                [mapView removeAnnotation:_calloutAnnotation];
    //                //                _calloutAnnotation = nil;
    //            }
    //            @catch (NSException *exception) {
    //                UA_log(@"%@", exception.description);
    //            }
    //        }
    //    }
}
-(void)annotationBtnAction:(UIButton*)sender
{
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[CalloutMapAnnotation class]]) {
        @try {
            CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
            NSArray *arrSupview = [annotationView.contentView subviews];
            for (UIView * vItem in arrSupview) {
                if([vItem isKindOfClass:[JingDianMapCell class]])
                {
                    [vItem removeFromSuperview];
                }
                
            }
            if (!annotationView) {
                annotationView = [[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
            }
            CalloutMapAnnotation * calloutAnno = (CalloutMapAnnotation*)annotation;
            JingDianMapCell  * cell = [[[NSBundle mainBundle] loadNibNamed:@"JingDianMapCell" owner:self options:nil] objectAtIndex:0];
            cell.lblTitle.text = @"";
            cell.lblDescription.text = calloutAnno.strDescription;
            cell.lblTitle.text = calloutAnno.strTitle;
            
            UIButton *tembtn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            // Frame required to render on position and size. Add below line
            [tembtn setFrame:CGRectMake(200, 15, 30, 30)];
            tembtn.tag = calloutAnno.strID;
            [tembtn setTitle:@"..." forState:UIControlStateNormal];
            [tembtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [tembtn addTarget:self action:@selector(annotationBtnAction:)
             forControlEvents:UIControlEventTouchUpInside];
//            tembtn.backgroundColor=[UIColor grayColor];
            [cell addSubview:tembtn];
            

            
            NSString * strStandarURL = calloutAnno.strLogo;
            NSString *photourl;
            if ([strStandarURL containsString:@"http://"]||[strStandarURL containsString:@"https://"]) {
                photourl = strStandarURL;
            }
            
            
            [cell.imgLogo setImageWithURL:[NSURL URLWithString:photourl]
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            cell.imgLogo.contentMode = UIViewContentModeScaleAspectFit;
            [annotationView.contentView addSubview:cell];
            return annotationView;
        }
        @catch (NSException *exception) {
            UA_log(@"%@", exception.description);
        }
    } else if ([annotation isKindOfClass:[BasicMapAnnotation class]]) {
        @try {
            MKAnnotationView *pinView =[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
            if (pinView == nil)
            {
                pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                       reuseIdentifier:@"CustomAnnotation"];
                pinView.canShowCallout = NO;
                pinView.image = [UIImage imageNamed:@"location_pin"];
            }
            else
            {
                pinView.annotation = annotation;
            }
            
            
            return pinView;
        }
        @catch (NSException *exception) {
            UA_log(@"%@", exception.description);
        }
        
    }
    return nil;
}
- (void)resetAnnitations:(NSMutableArray *)data
{
    [_annotationList removeAllObjects];
    [_annotationList addObjectsFromArray:data];
    [self setAnnotionsWithList:_annotationList];
}

-(void)initMap:(NSArray *)arrMapItem
{
    _mapView = [[MKMapView alloc]initWithFrame:self.frame];
    _mapView.delegate = self;
    [self addSubview:_mapView];
    [self initAnnotationList:arrMapItem];
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
