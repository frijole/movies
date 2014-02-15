//
//  FMVViewController.m
//  movies
//
//  Created by Ian Meyer on 2/13/14.
//  Copyright (c) 2014 Ian Meyer. All rights reserved.
//

#import "FMVMovieListViewController.h"

#import "FMVMovieDetailViewController.h"

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
    
    [self.navigationItem setLeftBarButtonItem:self.editButtonItem animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addButtonPressed:(id)sender
{
    // create an empty movie
    FMVMovie *tmpMovie = [[FMVMovie alloc] init];
    
    // try to add it
    if ( [FMVDataHandler addMovie:tmpMovie] ) {
        // present editor
        FMVMovieDetailViewController *tmpDetailVC = [[FMVMovieDetailViewController alloc] initWithMovie:tmpMovie andMode:FMVMovieDetailViewControllerModeNewMovie];
        [self.navigationController pushViewController:tmpDetailVC animated:YES];
    }
    else
    {
        // or present error
        UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:@"Movies" message:@"Sorry, there was a problem adding a new movie." delegate:nil cancelButtonTitle:@"Darn" otherButtonTitles:nil];
        [tmpAlert show];
    }
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
    rtnCell.textLabel.text = tmpMovie.title?:@"Untitled Movie";

    return rtnCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: adjust for multi-line titles
    return 60.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( editingStyle == UITableViewCellEditingStyleDelete )
    {
        FMVMovie *tmpMovie = [[FMVDataHandler movies] objectAtIndex:indexPath.row];
        if ( [FMVDataHandler removeMovie:tmpMovie] )
        {
            // deleted
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            // failed :(
        }
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [FMVDataHandler moveMovieFromIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

@end
