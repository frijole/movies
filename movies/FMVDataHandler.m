//
//  FMVDataHandler.m
//  movies
//
//  Created by Ian Meyer on 2/13/14.
//  Copyright (c) 2014 Ian Meyer. All rights reserved.
//

#import "FMVDataHandler.h"

#define kFMVMovieFileName @"movies"


static NSMutableArray *_movies = nil;


@implementation FMVDataHandler

// local store
+ (NSArray *)movies
{
    if ( !_movies ) {
        // load from disk
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *tmpAddressFilePath = [NSString stringWithFormat:@"%@/%@",[documentDirectories objectAtIndex:0],kFMVMovieFileName];
        NSArray *tmpMoviesFromDisk = [NSKeyedUnarchiver unarchiveObjectWithFile:tmpAddressFilePath];
        if ( tmpMoviesFromDisk && tmpMoviesFromDisk.count > 0 )
            _movies = [NSMutableArray arrayWithArray:tmpMoviesFromDisk];
    }

    if ( !_movies ) {
        // failed to load from disk, start from scratch
        _movies = [NSMutableArray array];
    }

    return _movies;
}

+ (void)saveMovies
{
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *tmpAddressFilePath = [NSString stringWithFormat:@"%@/%@",[documentsDirectories objectAtIndex:0],kFMVMovieFileName];
    if ( [NSKeyedArchiver archiveRootObject:[[self class] movies] toFile:tmpAddressFilePath] ) {
        NSLog(@"saved movies");
    } else {
        NSLog(@"error saving movies");
    }

}

// add to local store, from search or scratch
+ (BOOL)addMovie:(FMVMovie *)movie
{
    return NO;
}

+ (BOOL)removeMovie:(FMVMovie *)movie
{
    return NO;
}

// hit the omdb search api
+ (NSArray *)moviesForSearchString:(NSString *)searchString
{
    return nil;
}

// update or complete a movie via omdb
// searches on id first, then by title (w/year if present)
+ (void)updateMovie:(FMVMovie *)movie
            success:(void (^)(FMVMovie *movie))successBlock
            failure:(void (^)(NSError *error))failureBlock
{
    if ( failureBlock )
        failureBlock(nil);
}

@end


@implementation FMVMovie

// convenience method for creating movies from search results (or simple prompt)
+ (instancetype)movieWithTitle:(NSString *)movieTitle id:(NSString *)movieId year:(NSString *)movieYear
{
    FMVMovie *rtnMovie = [[FMVMovie alloc] init];
    
    [rtnMovie setTitle:movieTitle];
    [rtnMovie setImdbID:movieId];
    [rtnMovie setYear:movieYear];
    
    return rtnMovie;
}

// convenience method for creating a movie from scanning a barcode
+ (instancetype)movieWithBarcode:(NSString *)barcode
{
    FMVMovie *rtnMovie = [[FMVMovie alloc] init];
    
    [rtnMovie setBarcode:barcode];
    
    return rtnMovie;
}


@end
