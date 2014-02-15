//
//  FMVDataHandler.h
//  movies
//
//  Created by Ian Meyer on 2/13/14.
//  Copyright (c) 2014 Ian Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMVMovie;


@interface FMVDataHandler : NSObject

// local store
+ (NSMutableArray *)movies;

// add to local store, from search or scratch
+ (BOOL)addMovie:(FMVMovie *)movie;
+ (BOOL)removeMovie:(FMVMovie *)movie;

// hit the omdb search api
+ (NSArray *)moviesForSearchString:(NSString *)searchString;

// update or complete a movie via omdb via id, barcode, or title[+year]
// if more than one of the above are present, will validate response against extra data
+ (void)updateMovie:(FMVMovie *)movie
            success:(void (^)(FMVMovie *movie))successBlock
            failure:(void (^)(NSError *error))failureBlock;

// for reordering
+ (void)moveMovieFromIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;

@end


@interface FMVMovie : NSObject <NSCoding>

// this comes back from the api, but i dunno what it does
// @property (nonatomic)         BOOL response;        // "True"

@property (nonatomic, strong) NSString *title;      // "Howl's Moving Castle"

// the following are parsed from comma-seperated strings
@property (nonatomic, strong) NSArray  *directors;  // "Hayao Miyazaki"
@property (nonatomic, strong) NSArray  *writers;    // "Hayao Miyazaki (screenplay), Diana Wynne Jones (novel)"
@property (nonatomic, strong) NSArray  *actors;     // "Chieko Baishô, Takuya Kimura, Akihiro Miwa, Tatsuya Gashûin"
@property (nonatomic, strong) NSArray  *countries;  // "Japan"
@property (nonatomic, strong) NSArray  *languages;  // "Japanese"
@property (nonatomic, strong) NSArray  *genres;     // "Animation, Adventure, Family"

@property (nonatomic, strong) NSString *year;       // "2004"
@property (nonatomic, strong) NSString *released;   // "17 Jun 2005"

@property (nonatomic, strong) NSString *type;       // "movie"
@property (nonatomic, strong) NSString *runtime;    // "119 min"
@property (nonatomic, strong) NSString *plot;       // "When an unconfident young woman is cursed with an old body by a spiteful witch, her only chance of breaking the spell lies with a self-indulgent yet insecure young wizard and his companions in his legged, walking home.",
@property (nonatomic, strong) NSString *poster;     // "http://ia.media-imdb.com/images/M/MV5BMTY1OTg0MjE3MV5BMl5BanBnXkFtZTcwNTUxMTkyMQ@@._V1_SX300.jpg"

@property (nonatomic, strong) NSString *rated;      // "PG"
@property (nonatomic, strong) NSString *awards;     // "Nominated for 1 Oscar. Another 9 wins & 14 nominations."
@property (nonatomic, strong) NSString *metascore;  // "80"

@property (nonatomic, strong) NSString *imdbID;     // "tt0347149"
@property (nonatomic, strong) NSString *imdbRating; // "8.2"
@property (nonatomic, strong) NSString *imdbVotes;  // "130,272"

@property (nonatomic, strong) NSString *barcode;    // Scanned from case, used for loookup

// convenience method for creating movies from search results (or simple prompt)
+ (instancetype)movieWithTitle:(NSString *)movieTitle id:(NSString *)movieId year:(NSString *)year;

// convenience method for creating a movie from scanning a barcode
+ (instancetype)movieWithBarcode:(NSString *)barcode;

@end