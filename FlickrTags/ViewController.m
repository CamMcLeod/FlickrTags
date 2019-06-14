//
//  ViewController.m
//  FlickrTags
//
//  Created by Cameron Mcleod on 2019-06-13.
//  Copyright © 2019 Cameron Mcleod. All rights reserved.
//

#import "ViewController.h"
#import "Photo.h"
#import "PhotoCollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) NSMutableArray *catPhotos;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

-(void)loadDataWithURLString:(NSString *)url;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.catPhotos = [[NSMutableArray alloc] init];
    [self registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
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
        for (NSDictionary *photoImport in photoArray) { // 4
            
            Photo *photo = [[Photo alloc] initWithDict:photoImport];
            [self.catPhotos addObject: photo];
            NSLog(@"%@ IMPORTED TO ALL PHOTOS ARRAY", [[self.catPhotos lastObject] title]);
            
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
        }];
        
    }];
    
    [dataTask resume]; // 6
    
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath: indexPath];
    
    // Configure the cell’s contents.
    Photo *photo = self.catPhotos[indexPath.row];
    
    cell.label.text = photo.title;
    cell.imageView.image = [UIImage imageNamed:@"raccoon-2.jpg"];
    
    NSURL *url = [NSURL URLWithString:photo.url]; // 1
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url]; // 2
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        // If we reach this point, we have successfully retrieved the JSON from the API
        UIImage *image = [UIImage imageWithData:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            cell.imageView.image = image;
        }];
        
    }];
    
    [dataTask resume];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return [self.catPhotos count];
}

-(void)loadDataWithURLString:(NSString *)url {
    
}

@end
