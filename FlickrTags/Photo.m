//
//  Photo.m
//  FlickrTags
//
//  Created by Cameron Mcleod on 2019-06-13.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "Photo.h"

@implementation Photo


- (instancetype)initWithDict:(NSDictionary *)repoDict {
    
    self = [super init];
    if (self) {
        _repoName = repoDict[@"name"];
    }
    return self;
}

@end
