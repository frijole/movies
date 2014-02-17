//
//  FMVMovieDetailViewController.m
//  movies
//
//  Created by Ian Meyer on 2/14/14.
//  Copyright (c) 2014 Ian Meyer. All rights reserved.
//

#import "FMVMovieDetailViewController.h"

typedef NS_ENUM( NSInteger, FMVMovieDetailSection ) {
    FMVMovieDetailSectionInfo = 0,
    FMVMovieDetailSectionButton,
    
    FMVMovieDetailSectionCount
};


@interface FMVMovieDetailInfoCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UITextField *textField;

@end

@implementation FMVMovieDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:UITableViewCellStyleValue1
                     reuseIdentifier:reuseIdentifier] )
    {
        // custom init
        NSLog(@"loaded FMVMovieDetailInfoCell via init");
        
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        self.detailTextLabel.textColor = [UIColor blackColor];
        
        self.backgroundColor = [UIColor clearColor];
    }

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSLog(@"loaded FMVMovieDetailInfoCell from nib");
}

@end


@interface FMVMovieDetailButtonCell : UITableViewCell

@property (nonatomic, strong) UIButton *button;

@end

@implementation FMVMovieDetailButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:UITableViewCellStyleDefault
                     reuseIdentifier:reuseIdentifier])
    {
        [self.textLabel setHidden:YES];
        [self.detailTextLabel setHidden:YES];
        
        UIButton *tmpButton = [[UIButton alloc] initWithFrame:self.contentView.bounds];
        [tmpButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:tmpButton];
        [self setButton:tmpButton];
        
        // ???
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSLog(@"loaded FMVMovieDetailButtonCell from nib");
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
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIView *tmpBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    [tmpBackgroundView setBackgroundColor:[UIColor purpleColor]];
    [self.tableView setBackgroundView:tmpBackgroundView];
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.watchButton = [[UIBarButtonItem alloc] initWithTitle:@"Watch" style:UIBarButtonItemStylePlain target:self action:@selector(watchButtonPressed:)];

    UIBarButtonItem *tmpSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.statusBarButtonItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 36.0f)];
    self.statusBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.statusBarButtonItemLabel];
    
    UIBarButtonItem *tmpSpacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.favoriteButton = [[UIBarButtonItem alloc] initWithTitle:@"Fav" style:UIBarButtonItemStylePlain target:self action:@selector(favoriteButtonPressed:)];
    
    [self setToolbarItems:@[self.watchButton, tmpSpacer, self.statusBarButtonItem, tmpSpacer2, self.favoriteButton]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:(self.isEditing) animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if ( editing )
    {   // if we were viewing a movie, now we're editing it
        [self setMode:FMVMovieDetailViewControllerModeEditMovie];
        
        // and replace the back button with a cancel button
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)] animated:animated];
    
        // hide the toolbar
        [self.navigationController setToolbarHidden:YES animated:animated];
        
        // show the separators
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        // we also want to insert a row
        
        // jarring, but works.
        [self.tableView reloadData];
        
        // this gets weird, the existing cells expand to fill the new section size or other unwanted behavior.
        // [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:FMVMovieDetailSectionInfo] withRowAnimation:UITableViewRowAnimationAutomatic];

        // this causes a crash due to adding a row *after* numberOfRowsInSection increases. could be done more robustly and work, though.
        // NSIndexPath *tmpIndexPathToAdd = [NSIndexPath indexPathForRow:[self tableView:self.tableView numberOfRowsInSection:FMVMovieDetailSectionInfo] inSection:FMVMovieDetailSectionInfo];
        // [self.tableView insertRowsAtIndexPaths:@[tmpIndexPathToAdd] withRowAnimation:UITableViewRowAnimationAutomatic];

    }
    else
    {   // if we were adding a movie, now we're just viewing it
        [self setMode:FMVMovieDetailViewControllerModeDefault];

        // restore back button
        [self.navigationItem setLeftBarButtonItem:nil animated:animated];
    
        // and the toolbar
        [self.navigationController setToolbarHidden:NO animated:animated];

        // hide the separators
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        // and remove the "add info" row

        // jarring, but works.
        [self.tableView reloadData];

        // this gets weird, the existing cells expand to fill the new section size or other unwanted behavior.
        // [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:FMVMovieDetailSectionInfo] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // this causes a crash due to adding a row *after* numberOfRowsInSection increases. could be done more robustly and work, though.
        // NSIndexPath *tmpIndexPathToDelete = [NSIndexPath indexPathForRow:[self tableView:self.tableView numberOfRowsInSection:FMVMovieDetailSectionInfo]-1 inSection:FMVMovieDetailSectionInfo];
        // [self.tableView insertRowsAtIndexPaths:@[tmpIndexPathToDelete] withRowAnimation:UITableViewRowAnimationAutomatic];

    }
}

- (void)setMode:(FMVMovieDetailViewControllerMode)mode
{
    _mode = mode;
    
    if ( mode == FMVMovieDetailViewControllerModeEditMovie )
    {
        if ( !self.isEditing )
            [self setEditing:YES];
        
        [self setTitle:@"Edit Movie"];
    }
    else if ( mode == FMVMovieDetailViewControllerModeNewMovie )
    {
        if ( !self.isEditing )
            [self setEditing:YES];
        
        [self setTitle:@"New Movie"];
    }
    else if ( mode != FMVMovieDetailViewControllerModeEditMovie )
    {
        if ( self.isEditing )
            [self setEditing:NO];
        
        // a little fancy work to set a title
        NSNumber *tmpIndex = @([[FMVDataHandler movies] indexOfObject:self.movie]+1); // add one since the array is zero-indexed
        NSNumber *tmpTotal = @([[FMVDataHandler movies] count]);
        if ( tmpIndex.integerValue != NSNotFound )
            [self setTitle:[NSString stringWithFormat:@"%d of %d",tmpIndex.intValue,tmpTotal.intValue]];
        else
            [self setTitle:@"wat"];
    }
}

#pragma mark - Buttons
- (void)favoriteButtonPressed:(UIBarButtonItem *)favoriteButton
{
    
}

- (void)watchButtonPressed:(UIBarButtonItem *)watchButton
{
    
}

- (void)cancelButtonPressed:(UIBarButtonItem *)cancelButton
{
    [self setEditing:NO animated:YES];

    // TODO: clear changes
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger rtnCount = FMVMovieDetailSectionCount;
    
    if ( !self.isEditing )
        rtnCount--; // only show button section when editing
    
    return rtnCount;
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

    if ( self.isEditing && section == FMVMovieDetailSectionInfo )
        rtnCount++;
    
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
        
        // special case for last row when editing
        if ( self.isEditing && indexPath.row == ([self tableView:tableView numberOfRowsInSection:indexPath.section]-1) )
        {
            tmpTitleLabelString = @"Add Info...";
            tmpDetailLabelString = @"";
        }
        else
        {
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
            }
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL rtnStatus = NO;
    
    if ( indexPath.section == FMVMovieDetailSectionInfo )
        rtnStatus = YES;
    
    return rtnStatus;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle rtnStyle = UITableViewCellEditingStyleNone;

    // last row is "Add Info" others can be removed
    if ( indexPath.row == ([self tableView:tableView numberOfRowsInSection:indexPath.section]-1) )
        rtnStyle = UITableViewCellEditingStyleInsert;
    else
        rtnStyle = UITableViewCellEditingStyleDelete;
    

    return rtnStyle;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( editingStyle == UITableViewCellEditingStyleInsert )
    {
        [self.tableView beginUpdates];
        
        // add a row above the one that was tapped
        NSIndexPath *tmpIndexPathToInsert = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:@[tmpIndexPathToInsert] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // since numberOfRowsInSection won't change, remove a row above for now
        NSIndexPath *tmpIndexPathToRemove = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView deleteRowsAtIndexPaths:@[tmpIndexPathToRemove] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView endUpdates];

    }
    else if ( editingStyle == UITableViewCellEditingStyleDelete )
    {
        // depending on the info in this row, remove the row or just clear+refresh the cell
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat rtnHeight = 18.0f;
    
    if ( section == FMVMovieDetailSectionInfo )
        rtnHeight = (self.isEditing?32.0f:250.0f); // gonna show the poster here (maybe?)
    
    // NSLog(@"height for header in section %d is %f",section,rtnHeight);
    
    return rtnHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *rtnHeaderView = nil;

    if ( !self.isEditing ) {
        rtnHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        [rtnHeaderView setBackgroundColor:[UIColor blueColor]];
    }
    
    return rtnHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat rtnHeight = 18.0f;

    // NSLog(@"height for footer in section %d is %f",section,rtnHeight);
    
    return rtnHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *rtnFooterView = nil;

    /*
    if ( !self.isEditing ) {
        rtnFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [rtnFooterView setBackgroundColor:[UIColor redColor]];
    }
    */
    
    return rtnFooterView;
}

@end
