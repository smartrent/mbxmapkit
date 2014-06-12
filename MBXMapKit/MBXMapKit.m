//
//  MBXMapKit.m
//  MBXMapKit
//
//  Copyright (c) 2014 Mapbox. All rights reserved.
//

#import "MBXMapKit.h"


#pragma mark - Add support to MKMapView for using Mapbox-style center/zoom to configure the visible region

@implementation MKMapView (MBXMapView)

- (void)mbx_setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated
{
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, MKCoordinateSpanMake(0, 360 / pow(2, zoomLevel) * self.frame.size.width / 256));
    [self setRegion:region animated:animated];
}

@end


#pragma mark - Constants for the MBXMapKit error domain

NSString *const MBXMapKitErrorDomain = @"MBXMapKitErrorDomain";
NSInteger const MBXMapKitErrorCodeHTTPStatus = -1;
NSInteger const MBXMapKitErrorCodeDictionaryMissingKeys = -2;
NSInteger const MBXMapKitErrorCodeDownloadingCanceled = -3;
NSInteger const MBXMapKitErrorCodeOfflineMapHasNoDataForURL = -4;
NSInteger const MBXMapKitErrorCodeOfflineMapSqlite = -5;
NSInteger const MBXMapKitErrorCodeURLSessionConnectivity = -6;


#pragma mark - Helpers for creating verbose errors

@implementation NSError (MBXError)

+ (NSError *)mbx_errorWithCode:(NSInteger)code reason:(NSString *)reason description:(NSString *)description
{
    // Return an error in the MBXMapKit error domain with the specified reason and description
    //
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey        : NSLocalizedString(description, nil),
                                NSLocalizedFailureReasonErrorKey : NSLocalizedString(reason, nil) };

    return [NSError errorWithDomain:MBXMapKitErrorDomain code:code userInfo:userInfo];
}


+ (NSError *)mbx_errorCannotOpenOfflineMapDatabase:(NSString *)path sqliteError:(const char *)sqliteError
{
    return [NSError mbx_errorWithCode:MBXMapKitErrorCodeOfflineMapSqlite reason:[NSString stringWithFormat:@"Unable to open database %@: %@", path, [NSString stringWithUTF8String:sqliteError]] description:@"Failed to open the sqlite offline map database file"];
}

+ (NSError *)mbx_errorQueryFailedForOfflineMapDatabase:(NSString *)path sqliteError:(const char *)sqliteError
{
    return [NSError mbx_errorWithCode:MBXMapKitErrorCodeOfflineMapSqlite reason:[NSString stringWithFormat:@"There was an sqlite error while executing a query on database %@: %@", path, [NSString stringWithUTF8String:sqliteError]] description:@"Failed to execute query"];
}

@end
