//
//  jodebox.m
//  jodebox
//
//  Created by Enea Gjoka on 10/24/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "jodebox.h"
#import <RocketBootstrap/rocketbootstrap.h>

@interface CPDistributedMessagingCenter
+ (id)centerNamed:(id)arg1;
- (void)runServerOnCurrentThread;
- (void)registerForMessageName:(id)arg1 target:(id)arg2 selector:(SEL)arg3;
- (BOOL)sendMessageName:(id)arg1 userInfo:(id)arg2;
- (NSDictionary*)sendMessageAndReceiveReplyName:(NSString*)name userInfo:(NSDictionary*)info;
@end

@implementation JODebox

+(NSDictionary *)importMediaType:(MediaType)type withUserInfo:(NSDictionary *)info {
    CCLOGWARN(@"=: %@", info);
    
    NSMutableDictionary *mediaInfo = [@{} mutableCopy];
    mediaInfo[@"isNotOpenIn"] = @(1);
    
    switch (type) {
        case kMusicVideo: {
            mediaInfo[@"mediaKind"] = @"music-video";
            break;
        }
        case kFeatureMovie: {
            mediaInfo[@"mediaKind"] = @"feature-movie";
            break;
        }
        case kTVEpisode: {
            mediaInfo[@"mediaKind"] = @"tv-episode";
            break;
        }
        default: {
            mediaInfo[@"mediaKind"] = @"song";
            break;
        }
    }
    
    [mediaInfo addEntriesFromDictionary:info];
    
    CPDistributedMessagingCenter *c = [NSClassFromString(@"CPDistributedMessagingCenter") centerNamed:@"com.ouraigua.jodebox.center"];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    
    return [c sendMessageAndReceiveReplyName:@"messageThatHasInfo" userInfo:mediaInfo];
}

+(NSDictionary *)importSongWithTitle:(NSString *)title artist:(NSString *)artist image:(UIImage *)image
                           albumName:(NSString *)albumName trackNumber:(NSNumber *)trackNumber
                            duration:(NSNumber *)duration year:(NSNumber *)year path:(NSString *)path genre:(NSString *)genre {
    NSMutableDictionary *metadata = [@{
                                       @"title"     : title,
                                       @"software"  : @"Lavf53.24.2" } mutableCopy];
    if (duration) {
        metadata[@"duration"] = duration;
    }
    
    if (albumName) {
        metadata[@"albumName"] = albumName;
    }
    
    if (trackNumber) {
        metadata[@"trackNumber"] = trackNumber;
    }
    
    if (year) {
        metadata[@"year"] = year;
    } else {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *date = [NSDate date];
        NSInteger yearFromDate = [calendar component:NSCalendarUnitYear fromDate:date];
        metadata[@"year"] = @(yearFromDate);
    }
    
    if (artist) {
        metadata[@"artist"] = artist;
    } else {
        metadata[@"artist"] = [[[NSBundle mainBundle] executablePath] lastPathComponent];
    }
    
    if (genre) {
        metadata[@"type"] = genre;
    } else {
        metadata[@"type"] = @"Music";
    }
    
    if (image) {
        metadata[@"imageData"] = UIImagePNGRepresentation(image);
    }
    NSDictionary *info = @{ @"metadata" : metadata,
                            @"path" : path };
    return [self importMediaType:kSong withUserInfo:info];
}

+(NSDictionary *)importMusicVideoWithTitle:(NSString *)title artist:(NSString *)artist image:(UIImage *)image
                                  duration:(NSNumber *)duration year:(NSNumber *)year path:(NSString *)path genre:(NSString *)genre {
    NSMutableDictionary *metadata = [@{
                                       @"title"     : title,
                                       @"software"  : @"Lavf53.24.2" } mutableCopy];
    
    if (duration) {
        metadata[@"duration"] = duration;
    }
    
    if (artist) {
        metadata[@"artist"] = artist;
    } else {
        metadata[@"artist"] = [[[NSBundle mainBundle] executablePath] lastPathComponent];
    }
    
    if (year) {
        metadata[@"year"] = year;
    } else {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *date = [NSDate date];
        NSInteger yearFromDate = [calendar component:NSCalendarUnitYear fromDate:date];
        metadata[@"year"] = @(yearFromDate);
    }
    
    if (genre) {
        metadata[@"type"] = genre;
    } else {
        metadata[@"type"] = @"Music Video";
    }
    
    if (image) {
        metadata[@"imageData"] = UIImagePNGRepresentation(image);
    }
    
    NSDictionary *info = @{ @"metadata" : metadata,
                            @"path" : path };
    
    return [self importMediaType:kMusicVideo withUserInfo:info];
}

+(NSDictionary *)importMovieWithTitle:(NSString *)title artist:(NSString *)artist image:(UIImage *)image
                                  duration:(NSNumber *)duration year:(NSNumber *)year path:(NSString *)path genre:(NSString *)genre {
    NSMutableDictionary *metadata = [@{
                                        @"title"     : title,
                                        @"software"  : @"Lavf53.24.2" } mutableCopy];
    
    if (duration) {
        metadata[@"duration"] = duration;
    }
    
    if (artist) {
        metadata[@"artist"] = artist;
    } else {
        metadata[@"artist"] = [[[NSBundle mainBundle] executablePath] lastPathComponent];
    }
    
    if (year) {
        metadata[@"year"] = year;
    } else {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *date = [NSDate date];
        NSInteger yearFromDate = [calendar component:NSCalendarUnitYear fromDate:date];
        metadata[@"year"] = @(yearFromDate);
    }
    
    if (genre) {
        metadata[@"type"] = genre;
    } else {
        metadata[@"type"] = @"Feature Movie";
    }
    
    if (image) {
        metadata[@"imageData"] = UIImagePNGRepresentation(image);
    }
    
    NSDictionary *info = @{ @"metadata" : metadata,
                            @"path" : path };
    return [self importMediaType:kFeatureMovie withUserInfo:info];
}

+(NSDictionary *)importTVEpisodeWithTitle:(NSString *)title artist:(NSString *)artist
                                    image:(UIImage *)image duration:(NSNumber *)duration
                                     year:(NSNumber *)year seriesName:(NSString *)seriesName
                             seasonNumber:(NSNumber *)seasonNumber episodeNumber:(NSNumber *)episodeNumber
                                     path:(NSString *)path genre:(NSString *)genre {
    NSMutableDictionary *metadata = [@{
                                        @"title"            : title,
                                        @"software"         : @"Lavf53.24.2",
                                        @"episodeNumber"    : episodeNumber,
                                        @"seasonNumber"     : seasonNumber,
                                        @"seriesName"       : seriesName } mutableCopy];
    
    if (duration) {
        metadata[@"duration"] = duration;
    }
    
    if (artist) {
        metadata[@"artist"] = artist;
    } else {
        metadata[@"artist"] = [[[NSBundle mainBundle] executablePath] lastPathComponent];
    }
    
    if (year) {
        metadata[@"year"] = year;
    } else {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *date = [NSDate date];
        NSInteger yearFromDate = [calendar component:NSCalendarUnitYear fromDate:date];
        metadata[@"year"] = @(yearFromDate);
    }
    
    if (genre) {
        metadata[@"type"] = genre;
    } else {
        metadata[@"type"] = @"TV Episode";
    }
    
    if (image) {
        metadata[@"imageData"] = UIImagePNGRepresentation(image);
    }
    
    NSDictionary *info = @{ @"metadata" : metadata,
                            @"path" : path };
    return [self importMediaType:kTVEpisode withUserInfo:info];
    
}

@end