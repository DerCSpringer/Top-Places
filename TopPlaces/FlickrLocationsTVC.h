//
//  FlickrLocations.h
//  TopPlaces
//
//  Created by Daniel Springer on 2/18/16.
//  Copyright (c) 2016 Daniel Springer. All rights reserved.
//

#import "FlickrPhotosTVC.h"

@interface FlickrLocationsTVC : UITableViewController
@property (strong, nonatomic) NSDictionary *locations;
@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSArray *locationsForTable;

@end
