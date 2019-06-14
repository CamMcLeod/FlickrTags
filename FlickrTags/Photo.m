//
//  Photo.m
//  FlickrTags
//
//  Created by Cameron Mcleod on 2019-06-13.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "Photo.h"

@implementation Photo


- (instancetype)initWithDict:(NSDictionary *)photoDict {
    
    self = [super init];
    if (self) {
        NSString *title = photoDict[@"title"];
        _title = title;
        _farm = photoDict[@"farm"];
        _photoID = photoDict[@"id"];
        _server = photoDict[@"server"];
        _secret = photoDict[@"secret"];
        
        /*
        https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        establish url using this format
         */
        NSString *url = [[NSString alloc] initWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", photoDict[@"farm"], photoDict[@"server"], photoDict[@"id"],photoDict[@"secret"]];
        
        
        _url = url;
        
    }
    return self;
}

@end
