//
//  MapView.h
//  TemplateAndAction
//
//  Created by MAC on 5/29/14.
//  Copyright (c) 2014 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import  <MapKit/MKGeometry.h>
#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"
#import "CallOutAnnotationVifew.h"
#import "JingDianMapCell.h"
#import "DealObject.h"
@protocol MapViewControllerDidSelectDelegate;
@interface MapView : UIView<MKMapViewDelegate>

@property (retain, nonatomic) MKMapView *mapView;
@property (nonatomic, assign) int zoomLevel;
@property(nonatomic,assign)id<MapViewControllerDidSelectDelegate> delegate;

-(void)initMap:(NSArray *)arrMapItem;
- (void)resetAnnitations:(NSArray *)data;
- (void)startLocationRequest;
- (void)zoomToCurrentLocation;
@end

@protocol MapViewControllerDidSelectDelegate <NSObject>

@optional
- (void)customMKMapViewDidSelectedWithInfo:(id)info;
- (void)customMKMapViewDidSelectedWithValue:(DealObject*)info;
@end
