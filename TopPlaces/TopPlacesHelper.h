//
//  TopPlacesHelper.h
//  TopPlaces
//
//  Created by Daniel Springer on 2/22/16.
//  Copyright (c) 2016 Daniel Springer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopPlacesHelper : NSObject



+(void)addPhotosTo:(NSDictionary *)recentPhotos;
//Above adds recent photos to NSUserDefaults to be retrieved even if app is closed.  Stores 20 most recent photos
+(NSArray *)retrieveRecentPhotos;
+(NSString *)titleForPhoto:(NSDictionary *)photo;
//Above uses the title for the photo.   If none is found then it uses the description.  If there is no description then Unknown is used for the title.
+(NSString *)descriptionForPhoto:(NSDictionary *)photo;
+(void)setCityAndPhotoIDs:(NSDictionary *)setCityAndPhotoIDs;
+(NSArray *)getStaticCountries;
+(NSArray *)getStaticLocationsForTable;
+(NSDictionary *)getStaticCityAndPhotoIDs;
+(NSDictionary *)getStaticLocations;

@end
