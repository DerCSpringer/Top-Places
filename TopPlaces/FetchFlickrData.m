//
//  FetchFlickrData.m
//  TopPlaces
//
//  Created by Daniel Springer on 2/5/16.
//  Copyright (c) 2016 Daniel Springer. All rights reserved.
//

#import "FetchFlickrData.h"
#import "FlickrFetcher.h"

@implementation FetchFlickrData


-(void)fetchPhotos
{
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL); //NUll means serial q
    dispatch_async(fetchQ, ^{
        NSData *jsonResult = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                            options:0 error:NULL];
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_PLACE_NAME];
        //Just created our own q above and go back to main q to display the photo
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.photos = photos;
            NSLog(@"%@", [photos description]);
        });
        
    });
}






@end
