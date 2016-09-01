//
//  ViewController.m
//  TopPlaces
//
//  Created by Daniel Springer on 2/5/16.
//  Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "FetchFlickrData.h"
#import "FlickrFetcher.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchPhotos
{
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
        NSData *jsonResult = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResult
                                                                            options:0 error:NULL];
        
        //NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_PLACE_NAME];
        //Just created our own q above and go back to main q to display the photo
            //self.photos = photos;
            NSLog(@"%@", propertyListResults);

}


@end
