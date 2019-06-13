//
//  Photo.h
//  FlickrTags
//
//  Created by Cameron Mcleod on 2019-06-13.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Photo : NSObject


@property NSString *repoName;

- (instancetype)initWithDict:(NSDictionary *)repoDict;


@end

NS_ASSUME_NONNULL_END
