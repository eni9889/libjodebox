//
//  jodebox.h
//  jodebox
//
//  Created by Enea Gjoka on 10/24/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    kSong,
    kMusicVideo,
    kFeatureMovie,
    kTVEpisode,
    kPodcast
} MediaType;

@interface JODebox : NSObject

+(NSDictionary *)importMediaType:(MediaType)type withUserInfo:(NSDictionary *)info;

/*
 albumName = TestingAlbum;
 trackNumber = 1;
 */


+(NSDictionary *)importSongWithTitle:(NSString *)title artist:(NSString *)artist image:(UIImage *)image
                           albumName:(NSString *)albumName trackNumber:(NSNumber *)trackNumber
                            duration:(NSNumber *)duration year:(NSNumber *)year path:(NSString *)path genre:(NSString *)genre;

+(NSDictionary *)importMusicVideoWithTitle:(NSString *)title artist:(NSString *)artist image:(UIImage *)image
                                  duration:(NSNumber *)duration year:(NSNumber *)year path:(NSString *)path genre:(NSString *)genre;

+(NSDictionary *)importMovieWithTitle:(NSString *)title artist:(NSString *)artist image:(UIImage *)image
                                  duration:(NSNumber *)duration year:(NSNumber *)year path:(NSString *)path genre:(NSString *)genre;

+(NSDictionary *)importTVEpisodeWithTitle:(NSString *)title artist:(NSString *)artist
                                    image:(UIImage *)image duration:(NSNumber *)duration
                                     year:(NSNumber *)year seriesName:(NSString *)seriesName
                             seasonNumber:(NSNumber *)seasonNumber episodeNumber:(NSNumber *)episodeNumber
                                     path:(NSString *)path genre:(NSString *)genre;

+(NSDictionary *)importPodcastWithTitle:(NSString *)title podcastName:(NSString *)name
                          episodeNumber:(NSNumber *)episodeNumber year:(NSNumber *)year image:(UIImage *)image
                                   path:(NSString *)path genre:(NSString *)genre;
@end