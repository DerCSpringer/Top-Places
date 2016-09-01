//
//  RecentPhotos.m
//  TopPlaces
//
//  Created by Daniel Springer on 2/22/16.
//  Copyright (c) 2016 Daniel Springer. All rights reserved.
//

#import "RecentPhotos.h"
#import "FlickrFetcher.h"

@interface RecentPhotos ()

@end

@implementation RecentPhotos


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
}

-(IBAction)fetchPhotos
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher 3", NULL); //NUll means serial q
    dispatch_async(fetchQ, ^{
        NSData *jsonResult = [NSData dataWithContentsOfURL:self.locationURL];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                            options:0 error:NULL];
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        //NSArray *name = [photos valueForKeyPath:<#(NSString *)#>]
        //Just created our own q above and go back to main q to display the photo
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            //NSLog(@"%@", propertyListResults);
            self.photos = photos;
            //NSLog(@"%@", self.photos);
        });
        
    });
}

@end
