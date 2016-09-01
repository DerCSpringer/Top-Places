//
//  TopPlacesHelper.m
//  TopPlaces
//
//  Created by Daniel Springer on 2/22/16.
//  Copyright (c) 2016 Daniel Springer. All rights reserved.
//

#import "TopPlacesHelper.h"
#import "FlickrFetcher.h"


@interface TopPlacesHelper ()


@end


@implementation TopPlacesHelper

static NSArray *staticCountries;
static NSArray *staticLocationsForTable;
static NSDictionary *staticCityAndPhotoIDs;
static NSDictionary *staticLocations;



+(NSArray *)getStaticCountries
{
    return staticCountries;
}
+(NSArray *)getStaticLocationsForTable
{
    return staticLocationsForTable;
}
+(NSDictionary *)getStaticCityAndPhotoIDs
{
    return staticCityAndPhotoIDs;
}
+(NSDictionary *)getStaticLocations
{
    return staticLocations;
}


+(void)setCityAndPhotoIDs:(NSDictionary *)cityAndPhotoIDs
{
    staticCityAndPhotoIDs = cityAndPhotoIDs;
    staticLocations = [self locationInformation:cityAndPhotoIDs countries:[self extractCountryNames:cityAndPhotoIDs]];
}

+(NSArray *)extractCountryNames:(NSDictionary *)placesAndPlaceID
{
    NSMutableArray *listOfCitiesInCountry = [[NSMutableArray alloc] init];
    
    for (NSString *location in placesAndPlaceID) {
        NSArray *locationSeperated = [location componentsSeparatedByString:@", "];
        NSString *country = [locationSeperated lastObject];
        if (![listOfCitiesInCountry containsObject:country]) {
            [listOfCitiesInCountry addObject:country];
        }
    }
    
    NSArray *sortedArray = [listOfCitiesInCountry sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        
        if ([obj1 compare:obj2] > 0)
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 compare:obj2] < 0) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    //This orders the dictionary from the with country with the least entries to the the one with the most.  This makes it eaiser to not skip a country in the list.  IE a country with one entry in the middle of two countries with long location counts.
     
    
    staticCountries = sortedArray;
    return sortedArray;
}

+(NSDictionary *)locationInformation:(NSDictionary *)placesAndPlaceID countries:(NSArray *)countryList
//Goes through a dictoinary of location information(city, region, country) which is connected with a place_id
//It checks this list with the list of countries and creates a ditionary of coutries.
//the Dictionary's key is the country name.  The value is an array which contains a list of the cities which are dictionaries
//These dictionaries have a key of the location information and a key which is the place_id.
//This is used to fetch flikr photos in that area(in a diffent method).

{
    NSMutableArray *locationsForTable = [[NSMutableArray alloc] init];
    NSMutableDictionary *locationInformation = [[NSMutableDictionary alloc] init];
    NSMutableArray *cityList = [[NSMutableArray alloc] init];
    for (NSString *country in countryList) { //Goes through my country list
        for (NSString *location in placesAndPlaceID) { //Goes through dictionary of Places and place id
            
            NSArray *locationSeperated = [location componentsSeparatedByString:@", "];
            
            if ([[locationSeperated lastObject] isEqualToString:country]) {//Seperates out the country name
                //Create array of dictionarys for a country.  Keys are cities, values are place id
                [cityList addObject:[[NSDictionary alloc] initWithObjectsAndKeys:[placesAndPlaceID valueForKey:location], location , nil]];
            }
        }
        
        
        
        NSArray *sortedArray = [cityList sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            
            obj1 = [[[obj1 allKeys][0] componentsSeparatedByString:@", "] firstObject];
            obj2 = [[[obj2 allKeys][0] componentsSeparatedByString:@", "] firstObject];
            
            //obj1 and obj2 are NSDictionary Objects each containing 1 entry.  The entry has a key for a location and the value is the PhotoID.  Since it's each dictionary is only one element I get all the keys(which is only 1) seperate the location information to just get the city name.  This then will order the array alphabetically by city name.
            
            if ([obj1  compare:obj2] > 0)
            {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 compare:obj2] < 0) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
    
        
        [locationInformation setObject:[sortedArray copy] forKey:country];
        [locationsForTable addObjectsFromArray:sortedArray];
        [cityList removeAllObjects];
        sortedArray = nil;
    }
    staticLocationsForTable = locationsForTable;
    return locationInformation;
    
}



/*
+(NSDictionary *)getCityAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keys = [self.locations allKeys]; //Get all keys in location
    NSString *path = keys[indexPath.section]; //Return the key name for a giving indexPath section(this is the country)
    NSArray *city = [self.locations objectForKey:path]; //Array of the dictionaries that are of country path
    
    return city[indexPath.row]; //Returns dictionary at indexPath for a specific locaiton
    
}
 */
+(void)addPhotosTo:(NSDictionary *)recentPhotos
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *photos = [[defaults objectForKey:@"recent photos"] mutableCopy];
    if (!photos) {
        photos = [[NSMutableArray alloc] init];
    }
    

    
    NSUInteger key = [photos indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[recentPhotos valueForKeyPath:FLICKR_PHOTO_ID] isEqualToString:[obj valueForKeyPath:FLICKR_PHOTO_ID]];
    }];
    if (key != NSNotFound) [photos removeObjectAtIndex:key];
    [defaults setObject:photos forKey:@"recent photos"];
    
    
    [photos insertObject:recentPhotos atIndex:0];
    [defaults setObject:photos forKey:@"recent photos"];
    //The above looks for photos in the array(photos) and looks at each photo's ID.  If it finds the passed in photo with the same unique ID it removes the orginal photo from the recent photos.  It makes sure that duplicate recent photo entries are not entered into UserDefaults.
    
    
    if ([photos count] > 20) {//Only allow 20 most recent photos
        [photos removeLastObject];
        [defaults setObject:photos forKey:@"recent photos"];
    }
    [defaults synchronize];

}

+(NSArray *)retrieveRecentPhotos
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"recent photos"];
}


+(NSString *)titleForPhoto:(NSDictionary *)photo
{
    
    if ([[photo valueForKeyPath:FLICKR_PHOTO_TITLE] isEqualToString:@""]) {
        if ([[photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] isEqualToString:@""]) {
            return @"Unknon Title";
        }
        return [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    }
    else
    {
        return [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    }
}



+(NSString *)descriptionForPhoto:(NSDictionary *)photo
{

    return [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];

}



@end
