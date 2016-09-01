//
//  RetrieveTopPlaces.m
//  TopPlaces
//
//  Created by Daniel Springer on 2/17/16.
//  Copyright (c) 2016 Daniel Springer. All rights reserved.
//

#import "RetrieveTopPlaces.h"
#import "FlickrFetcher.h"
#import "TopPlacesHelper.h"

@implementation RetrieveTopPlaces


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
}

-(IBAction)fetchPhotos
{
    //[self countryParser];
   //***put back in*** [self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    //NSURL *url = [FlickrFetcher URLforPhotosInPlace:@"EsIQUYZXU79_kEA" maxResults:10];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL); //NUll means serial q
    dispatch_async(fetchQ, ^{
        NSData *jsonResult = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                            options:0 error:NULL];
        NSDictionary *cityAndPhotoIDs = [[NSDictionary alloc] initWithObjects:[propertyListResults valueForKeyPath:@"places.place.place_id"] forKeys:[propertyListResults valueForKeyPath:@"places.place._content"]];
        //[self orderPhotos:cityAndPhotoIDs];
        //Just created our own q above and go back to main q to display the photo
        dispatch_async(dispatch_get_main_queue(), ^{
           //***put back in****\ [self.refreshControl endRefreshing];
            [TopPlacesHelper setCityAndPhotoIDs:cityAndPhotoIDs];
            self.countries = [TopPlacesHelper getStaticCountries];
            self.locationsForTable = [TopPlacesHelper getStaticLocationsForTable];
            self.locations = [TopPlacesHelper getStaticLocations];
            //Placed last becuase locations reloads table data once it is set
            
        });
        
    });
    

}


@end
