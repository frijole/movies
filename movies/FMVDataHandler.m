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
+ (NSMutableArray *)movies
{
    if ( !_movies ) {
        // load from disk
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *tmpAddressFilePath = [NSString stringWithFormat:@"%@/%@",[documentDirectories objectAtIndex:0],kFMVMovieFileName];
        NSArray *tmpMoviesFromDisk = [NSKeyedUnarchiver unarchiveObjectWithFile:tmpAddressFilePath];
        if ( tmpMoviesFromDisk && tmpMoviesFromDisk.count > 0 ) {
            _movies = [NSMutableArray arrayWithArray:tmpMoviesFromDisk];
            // NSLog(@"loaded movies from disk");
        } else {
            NSLog(@"failed to load movies from disk");
        }
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
        // NSLog(@"saved movies");
    } else {
        NSLog(@"error saving movies");
    }

}

// add to local store, from search or scratch
+ (BOOL)addMovie:(FMVMovie *)movie
{
    BOOL rtnStatus = NO;
    
    [[[self class] movies] addObject:movie];
    
    if ( [[[self class] movies] indexOfObject:movie] != NSNotFound )
        rtnStatus = YES;
    
    if ( rtnStatus )
        [self saveMovies];
    
    return rtnStatus;
}

+ (BOOL)removeMovie:(FMVMovie *)movie
{
    BOOL rtnStatus = NO;
    
    [[[self class] movies] removeObject:movie];
    
    if ( [[[self class] movies] indexOfObject:movie] == NSNotFound )
        rtnStatus = YES;
    
    if ( rtnStatus )
        [self saveMovies];
    
    return rtnStatus;
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

// for reordering
+ (void)moveMovieFromIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex
{
    // grab the movie we're moving
    FMVMovie *tmpMovie = [[[self class] movies] objectAtIndex:sourceIndex];

    // remove it and re-insert it
    [[self movies] removeObjectAtIndex:sourceIndex];
    [[self movies] insertObject:tmpMovie atIndex:destinationIndex];

    // and save changes
    [self saveMovies];
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

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.title forKey:@"title"];

    [coder encodeObject:self.directors forKey:@"directors"];
    [coder encodeObject:self.writers forKey:@"writers"];
    [coder encodeObject:self.actors forKey:@"actors"];
    [coder encodeObject:self.countries forKey:@"countries"];
    [coder encodeObject:self.languages forKey:@"languages"];
    [coder encodeObject:self.genres forKey:@"genres"];
    
    [coder encodeObject:self.year forKey:@"year"];
    [coder encodeObject:self.released forKey:@"released"];
    
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.runtime forKey:@"runtime"];
    [coder encodeObject:self.plot forKey:@"plot"];
    [coder encodeObject:self.poster forKey:@"poster"];
    [coder encodeObject:self.rated forKey:@"rated"];
    [coder encodeObject:self.awards forKey:@"awards"];
    [coder encodeObject:self.metascore forKey:@"metascore"];
    
    [coder encodeObject:self.imdbID forKey:@"imdbID"];
    [coder encodeObject:self.imdbRating forKey:@"imdbRating"];
    [coder encodeObject:self.imdbVotes forKey:@"imdbVotes"];
    
    [coder encodeObject:self.barcode forKey:@"barcode"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ( self = [self init] )
    {
        
        [self setTitle:[decoder decodeObjectForKey:@"title"]];
        
        [self setDirectors:[decoder decodeObjectForKey:@"directors"]];
        [self setWriters:[decoder decodeObjectForKey:@"writers"]];
        [self setActors:[decoder decodeObjectForKey:@"actors"]];
        [self setCountries:[decoder decodeObjectForKey:@"countries"]];
        [self setLanguages:[decoder decodeObjectForKey:@"languages"]];
        [self setGenres:[decoder decodeObjectForKey:@"genres"]];
        
        [self setYear:[decoder decodeObjectForKey:@"year"]];
        [self setReleased:[decoder decodeObjectForKey:@"released"]];
        
        [self setType:[decoder decodeObjectForKey:@"type"]];
        [self setRuntime:[decoder decodeObjectForKey:@"runtime"]];
        [self setPlot:[decoder decodeObjectForKey:@"plot"]];
        [self setPoster:[decoder decodeObjectForKey:@"poster"]];
        
        [self setRated:[decoder decodeObjectForKey:@"rated"]];
        [self setAwards:[decoder decodeObjectForKey:@"awards"]];
        [self setMetascore:[decoder decodeObjectForKey:@"metascore"]];
        
        [self setImdbID:[decoder decodeObjectForKey:@"imdbID"]];
        [self setImdbRating:[decoder decodeObjectForKey:@"imdbRating"]];
        [self setImdbVotes:[decoder decodeObjectForKey:@"imdbVotes"]];
        
        [self setBarcode:[decoder decodeObjectForKey:@"barcode"]];
    }
    
    return self;
}



@end
