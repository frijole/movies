//
//  FMVMovieDetailViewController.m
//  movies
//
//  Created by Ian Meyer on 2/14/14.
//  Copyright (c) 2014 Ian Meyer. All rights reserved.
//

#import "FMVMovieDetailViewController.h"

typedef NS_ENUM( NSInteger, FMVMovieDetailSection ) {
    FMVMovieDetailSectionInfo,
    FMVMovieDetailSectionButton,
    
    FMVMovieDetailSectionCount
};


@interface FMVMovieDetailInfoCell : UITableViewCell

@end

@implementation FMVMovieDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    return self;
}

@end


@interface FMVMovieDetailButtonCell : UITableViewCell

@end

@implementation FMVMovieDetailButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    return self;
}

@end


@interface FMVMovieDetailViewController ()

@end


@implementation FMVMovieDetailViewController

- (instancetype)initWithMovie:(FMVMovie *)movie
{
    self = [self initWithMovie:movie andMode:FMVMovieDetailViewControllerModeDefault];
    
    return self;
}

- (instancetype)initWithMovie:(FMVMovie *)movie andMode:(FMVMovieDetailViewControllerMode)mode
{
    if ( self = [super initWithStyle:UITableViewStyleGrouped] )
    {
        // Custom initialization
        [self setMovie:movie];
        [self setMode:mode];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[FMVMovieDetailInfoCell class] forCellReuseIdentifier:@"FMVMovieDetailInfoCellIdentifier"];
    [self.tableView registerClass:[FMVMovieDetailButtonCell class] forCellReuseIdentifier:@"FMVMovieDetailButtonCellIdentifier"];
    
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if ( editing ) // if we were viewing a movie, now we're editing it
        [self setMode:FMVMovieDetailViewControllerModeEditMovie];
    else // if we were adding a movie, now we're just viewing it
        [self setMode:FMVMovieDetailViewControllerModeDefault];
}

- (void)setMode:(FMVMovieDetailViewControllerMode)mode
{
    _mode = mode;
    
    if ( mode == FMVMovieDetailViewControllerModeEditMovie && !self.isEditing )
        [self setEditing:YES];
    else if ( mode == FMVMovieDetailViewControllerModeNewMovie && !self.isEditing )
        [self setEditing:YES];
    else if ( mode != FMVMovieDetailViewControllerModeEditMovie && self.isEditing )
        [self setEditing:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return FMVMovieDetailSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rtnCount = 0;
    
    switch ( section )
    {
        case FMVMovieDetailSectionInfo:
            rtnCount = 5;
            break;

        case FMVMovieDetailSectionButton:
            rtnCount = 1;
            break;
    }
    
    return rtnCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rtnHeight = 44.0f;
    
    switch ( indexPath.section ) {
        case FMVMovieDetailSectionInfo:
            // TODO: adjust for multi-line titles
            rtnHeight = 60.0f;
            break;
            
        case FMVMovieDetailSectionButton:
            rtnHeight = 44.0f;
            break;
    }
    
    return rtnHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // default cell identifier
    // note: no class or nib is registred for this identifier
    //       so if it is used, we will crash.
    NSString *tmpCellIdentifier = @"FMVMovieDetailCellIdentifier";

    // customize by section
    switch ( indexPath.section ) {
        case FMVMovieDetailSectionInfo:
            tmpCellIdentifier = @"FMVMovieDetailInfoCellIdentifier";
            break;
        case FMVMovieDetailSectionButton:
            tmpCellIdentifier = @"FMVMovieDetailButtonCellIdentifier";
            break;
            
        default:
            break;
    }
    
    // get the cell
    UITableViewCell *rtnCell = [tableView dequeueReusableCellWithIdentifier:tmpCellIdentifier forIndexPath:indexPath];
    
    // and configure it...
    if ( indexPath.section == FMVMovieDetailSectionInfo )
    {
        NSString *tmpTitleLabelString = @"title";
        NSString *tmpDetailLabelString = @"details";
        
        switch ( indexPath.row )
        {
            case 0:
                tmpTitleLabelString = @"1";
                tmpDetailLabelString = @"one";
                break;
            case 1:
                tmpTitleLabelString = @"2";
                tmpDetailLabelString = @"two";
                break;
                
            default:
                tmpTitleLabelString = @"lol";
                tmpDetailLabelString = @"wut";
                break;
                break;
        }
        
        rtnCell.textLabel.text = tmpTitleLabelString;
        rtnCell.detailTextLabel.text = tmpDetailLabelString;

    }
    else if ( indexPath.section == FMVMovieDetailSectionButton )
    {
        NSString *tmpButtonText = @"";
       
        switch ( self.mode )
        {
            case FMVMovieDetailViewControllerModeDefault:
                tmpButtonText = @"Watch Movie";
                break;
            case FMVMovieDetailViewControllerModeEditMovie:
                tmpButtonText = @"Delete Movie";
                break;
            case FMVMovieDetailViewControllerModeNewMovie:
                tmpButtonText = @"Save Movie";
                break;
        }
        
        rtnCell.textLabel.text = tmpButtonText;
    }
    
    return rtnCell;
}

@end
