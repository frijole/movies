//
//  FMVMovieDetailViewController.h
//  movies
//
//  Created by Ian Meyer on 2/14/14.
//  Copyright (c) 2014 Ian Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FMVDataHandler.h"

typedef NS_ENUM( NSInteger, FMVMovieDetailViewControllerMode ) {
    FMVMovieDetailViewControllerModeDefault = 0,
    FMVMovieDetailViewControllerModeEditMovie, // also set by setEditing
    FMVMovieDetailViewControllerModeNewMovie,
};

@interface FMVMovieDetailViewController : UITableViewController

@property (nonatomic, strong) FMVMovie *movie;
@property (nonatomic) FMVMovieDetailViewControllerMode mode;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *watchButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *favoriteButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *statusBarButtonItem;
@property (nonatomic, strong) IBOutlet UILabel *statusBarButtonItemLabel;

- (instancetype)initWithMovie:(FMVMovie *)movie; // FMVMovieDetailViewControllerModeDefault
- (instancetype)initWithMovie:(FMVMovie *)movie andMode:(FMVMovieDetailViewControllerMode)mode;

- (IBAction)watchButtonPressed:(id)sender;
- (IBAction)favoriteButtonPressed:(id)sender;

@end
