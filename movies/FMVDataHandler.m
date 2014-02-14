//
//  FMVDataHandler.m
//  movies
//
//  Created by Ian Meyer on 2/13/14.
//  Copyright (c) 2014 Ian Meyer. All rights reserved.
//

#import "FMVDataHandler.h"

static NSMutableArray *_movies = nil;

@implementation FMVDataHandler

// local store
+ (NSArray *)movies
{
    if ( !_movies ) {
        // load from disk
        
    }

    if ( !_movies ) {
        // failed to load from disk, start from scratch
        _movies = [NSMutableArray array];
    }

    return _movies;
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
