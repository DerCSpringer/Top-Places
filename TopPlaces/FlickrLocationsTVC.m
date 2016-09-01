//
//  FlickrLocations.m
//  TopPlaces
//
//  Created by Daniel Springer on 2/18/16.
//  Copyright (c) 2016 Daniel Springer. All rights reserved.
//

#import "FlickrLocationsTVC.h"
//#import "RetrieveTopPlaces.h"
#import "FlickrFetcher.h"

@interface FlickrLocationsTVC ()

@end

@implementation FlickrLocationsTVC

-(void)setLocations:(NSDictionary *)locations
{
    _locations = locations;
    [self.tableView reloadData];
}

- (NSArray *)countries
{
    if (!_countries) _countries = [[NSArray alloc] init];
    return _countries;
}

- (NSArray *)locationsForTable
{
    if (!_locationsForTable) _locationsForTable = [[NSArray alloc] init];
    return _locationsForTable;
}


/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 
 */


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.countries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    NSArray *keys = [self.locations allKeys];
    NSString *key = keys[section];
    return [[self.locations valueForKey:key] count];
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSArray *components = [[[[self getCityAtIndexPath:indexPath] allKeys] firstObject] componentsSeparatedByString:@", "];
    //First it finds the dictionary entry for the one at indexPath.  This dictionary has one key with a lcoation and a value of the locationID for flickr.  This locaiton is then seperated so I can display the City as the title and region as the subtitle in the cell.
    cell.textLabel.text = [components firstObject];

    cell.detailTextLabel.text = components[1];
    
    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *header = [[UILabel alloc] init];
    
    
    NSArray *keys = [self.locations allKeys];
    header.text = keys[section];
    header.backgroundColor = [UIColor grayColor];
    header.textColor = [UIColor lightTextColor];
    return header;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    if ([detail isKindOfClass:[FlickrPhotosTVC class]]) {
        [self prepareFlickrPhotosTVC:detail forLocation:[self getCityAtIndexPath:indexPath]];
    }
}

-(NSDictionary *)getCityAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keys = [self.locations allKeys]; //Get all keys in location
    NSString *path = keys[indexPath.section]; //Return the key name for a giving indexPath section(this is the country)
    NSArray *city = [self.locations objectForKey:path]; //Array of the dictionaries that are of country path

    return city[indexPath.row]; //Returns dictionary at indexPath for a specific locaiton
    
}

-(void)prepareFlickrPhotosTVC:(FlickrPhotosTVC *)fptvc forLocation:(NSDictionary *)location
{
    fptvc.locationURL = [FlickrFetcher URLforPhotosInPlace:[[location allValues] firstObject] maxResults:50];
    fptvc.title =  [[[[location allKeys] firstObject] componentsSeparatedByString:@", "] firstObject];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"Display Location Photos"]) {
            if ([segue.destinationViewController isKindOfClass:[FlickrPhotosTVC class]]) {
                [self prepareFlickrPhotosTVC:segue.destinationViewController
                                  forLocation:[self getCityAtIndexPath:indexPath]];
            }
        }
    }
}


@end
