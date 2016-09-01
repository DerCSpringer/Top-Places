//
//  RecentPhotosTVC.m
//  TopPlaces
//
//  Created by Daniel Springer on 2/25/16.
//  Copyright (c) 2016 Daniel Springer. All rights reserved.
//

#import "RecentPhotosTVC.h"
#import "TopPlacesHelper.h"

@interface RecentPhotosTVC ()

@end

@implementation RecentPhotosTVC


-(void)viewWillAppear:(BOOL)animated
{
    [self fetchPhotos];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
    // Do any additional setup after loading the view.
}

-(IBAction)fetchPhotos
{
    //Fetches photos from NSUserDefault to display the 20 most recent photos
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    defaults = [NSUserDefaults standardUserDefaults];
    NSArray *photos = [TopPlacesHelper retrieveRecentPhotos];
    self.photos = photos;
    
}



@end
