//
//  FMVViewController.m
//  movies
//
//  Created by Ian Meyer on 2/13/14.
//  Copyright (c) 2014 Ian Meyer. All rights reserved.
//

#import "FMVMovieListViewController.h"

#import "FMVDataHandler.h"

NS_ENUM( NSInteger, FMVMovieListSection ) {
    FMVMovieListSectionMovies = 0,
    
    FMVMovieListSectionCount
};


@interface FMVMovieListCell : UITableViewCell

@end

@implementation FMVMovieListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] )
    {
        // custom initialization
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return self;
}

@end


@interface FMVMovieListViewController ()

@end

@implementation FMVMovieListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setMovies:[FMVDataHandler movies]];
    
    [self.tableView registerClass:[FMVMovieListCell class] forCellReuseIdentifier:@"FMVMovieListCellIdentifier"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return FMVMovieListSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *rtnCell = [tableView dequeueReusableCellWithIdentifier:@"FMVMovieListCellIdentifier" forIndexPath:indexPath];
    
    // configure cell
    FMVMovie *tmpMovie = [self.movies objectAtIndex:indexPath.row];
    rtnCell.textLabel.text = tmpMovie.title;

    return rtnCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: adjust for multi-line titles
    return 60.0f;
}

@end
