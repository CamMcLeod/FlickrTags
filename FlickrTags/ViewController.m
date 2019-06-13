//
//  ViewController.m
//  FlickrTags
//
//  Created by Cameron Mcleod on 2019-06-13.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=1648e27ecf2333ddd82c92f031d7d91e&tags=cat"]; // 1
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url]; // 2
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *queryResult = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]; // 2
        
        if (jsonError) { // 3
            // Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        // If we reach this point, we have successfully retrieved the JSON from the API
        NSDictionary *photos = queryResult[@"photos"];
        NSArray *photoArray = photos[@"photo"];
        for (NSDictionary *photo in photoArray) { // 4
//            server
//            farm
//            id
//            secret
//            url
//            title
            NSString *title =  photo[@"title"];
            NSLog(@"title: %@", title);
            NSLog(@"server: %@", photo[@"server"]);
            NSLog(@"farm: %@", photo[@"farm"]);
            NSLog(@"id: %@", photo[@"id"]);
            NSLog(@"secret: %@", photo[@"secret"]);
            
            
            
            
            
        }
    }];
    
    [dataTask resume]; // 6
    
}


@end
